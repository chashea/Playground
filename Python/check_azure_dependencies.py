"""
Azure Resource Dependency Checker
This script automatically checks and maps dependencies between Azure resources.
It uses Azure Resource Graph API for efficient querying across subscriptions.
"""

from azure.identity import DefaultAzureCredential
from azure.mgmt.resourcegraph import ResourceGraphClient
from azure.mgmt.resourcegraph.models import QueryRequest, QueryRequestOptions
from azure.mgmt.resource import ResourceManagementClient
from azure.core.exceptions import AzureError
import json
from typing import Dict, List, Set
from collections import defaultdict


class AzureDependencyChecker:
    """
    Automated Azure resource dependency checker using Resource Graph API.
    """
    
    def __init__(self, subscription_ids: List[str]):
        """
        Initialize the dependency checker.
        
        Args:
            subscription_ids: List of Azure subscription IDs to check
        """
        self.credential = DefaultAzureCredential()
        self.subscription_ids = subscription_ids
        self.resource_graph_client = ResourceGraphClient(self.credential)
        self.resource_client = ResourceManagementClient(
            self.credential, 
            subscription_ids[0] if subscription_ids else None
        )
        
    def query_resource_graph(self, query: str) -> List[Dict]:
        """
        Execute a query against Azure Resource Graph.
        
        Args:
            query: KQL query string
            
        Returns:
            List of query results
        """
        try:
            query_request = QueryRequest(
                subscriptions=self.subscription_ids,
                query=query,
                options=QueryRequestOptions(result_format="objectArray")
            )
            
            response = self.resource_graph_client.resources(query_request)
            return response.data
        except AzureError as e:
            print(f"Error querying Resource Graph: {e}")
            return []
    
    def get_all_resources_with_dependencies(self) -> List[Dict]:
        """
        Get all resources and their dependencies using Resource Graph.
        
        Returns:
            List of resources with their dependency information
        """
        query = """
        resources
        | extend dependencies = properties.dependencies
        | extend dependsOn = properties.dependsOn
        | project 
            id,
            name,
            type,
            resourceGroup,
            location,
            properties,
            dependencies,
            dependsOn,
            tags
        """
        return self.query_resource_graph(query)
    
    def get_network_dependencies(self) -> List[Dict]:
        """
        Get network-specific dependencies (NICs, VNets, Subnets, etc.).
        
        Returns:
            List of network resources with dependencies
        """
        query = """
        resources
        | where type in (
            'microsoft.network/networkinterfaces',
            'microsoft.network/virtualnetworks',
            'microsoft.network/publicipaddresses',
            'microsoft.network/loadbalancers',
            'microsoft.network/azurefirewalls',
            'microsoft.network/applicationgateways',
            'microsoft.network/bastionhosts',
            'microsoft.network/virtualnetworkgateways'
        )
        | extend 
            subnet = properties.ipConfigurations[0].properties.subnet.id,
            publicIp = properties.ipConfigurations[0].properties.publicIPAddress.id,
            vnetId = tostring(properties.subnets[0].id)
        | project 
            id,
            name,
            type,
            resourceGroup,
            subnet,
            publicIp,
            vnetId,
            properties
        """
        return self.query_resource_graph(query)
    
    def get_vm_dependencies(self) -> List[Dict]:
        """
        Get VM-specific dependencies (NICs, Disks, etc.).
        
        Returns:
            List of VM resources with dependencies
        """
        query = """
        resources
        | where type == 'microsoft.compute/virtualmachines'
        | extend 
            nicIds = properties.networkProfile.networkInterfaces,
            osDisk = properties.storageProfile.osDisk.managedDisk.id,
            dataDisks = properties.storageProfile.dataDisks
        | project 
            id,
            name,
            type,
            resourceGroup,
            nicIds,
            osDisk,
            dataDisks
        """
        return self.query_resource_graph(query)
    
    def get_disk_attachments(self) -> List[Dict]:
        """
        Get managed disk attachments.
        
        Returns:
            List of disks and what they're attached to
        """
        query = """
        resources
        | where type == 'microsoft.compute/disks'
        | extend attachedTo = properties.diskState
        | extend vmId = properties.managedBy
        | project 
            id,
            name,
            type,
            resourceGroup,
            attachedTo,
            vmId
        """
        return self.query_resource_graph(query)
    
    def get_resource_locks(self) -> List[Dict]:
        """
        Get resources with locks that might prevent deletion.
        
        Returns:
            List of locked resources
        """
        query = """
        resourcecontainers
        | where type == 'microsoft.resources/subscriptions/resourcegroups'
        | join kind=leftouter (
            resources
            | where type == 'microsoft.authorization/locks'
        ) on subscriptionId, resourceGroup
        | project 
            resourceGroup,
            lockName = name1,
            lockLevel = properties.level
        """
        return self.query_resource_graph(query)
    
    def build_dependency_graph(self) -> Dict[str, Set[str]]:
        """
        Build a comprehensive dependency graph.
        
        Returns:
            Dictionary mapping resource IDs to their dependencies
        """
        dependency_graph = defaultdict(set)
        reverse_dependency_graph = defaultdict(set)
        
        # Get VM dependencies
        vms = self.get_vm_dependencies()
        for vm in vms:
            vm_id = vm.get('id', '')
            
            # NIC dependencies
            if vm.get('nicIds'):
                for nic in vm['nicIds']:
                    nic_id = nic.get('id', '')
                    if nic_id:
                        dependency_graph[vm_id].add(nic_id)
                        reverse_dependency_graph[nic_id].add(vm_id)
            
            # OS Disk dependency
            if vm.get('osDisk'):
                dependency_graph[vm_id].add(vm['osDisk'])
                reverse_dependency_graph[vm['osDisk']].add(vm_id)
            
            # Data Disk dependencies
            if vm.get('dataDisks'):
                for disk in vm['dataDisks']:
                    disk_id = disk.get('managedDisk', {}).get('id', '')
                    if disk_id:
                        dependency_graph[vm_id].add(disk_id)
                        reverse_dependency_graph[disk_id].add(vm_id)
        
        # Get network dependencies
        network_resources = self.get_network_dependencies()
        for resource in network_resources:
            resource_id = resource.get('id', '')
            
            # Subnet dependencies
            if resource.get('subnet'):
                dependency_graph[resource_id].add(resource['subnet'])
                reverse_dependency_graph[resource['subnet']].add(resource_id)
            
            # Public IP dependencies
            if resource.get('publicIp'):
                dependency_graph[resource_id].add(resource['publicIp'])
                reverse_dependency_graph[resource['publicIp']].add(resource_id)
        
        return {
            'depends_on': dict(dependency_graph),
            'depended_by': dict(reverse_dependency_graph)
        }
    
    def get_deletion_order(self, resource_group: str = None) -> List[str]:
        """
        Calculate safe deletion order for resources.
        
        Args:
            resource_group: Optional resource group to scope the analysis
            
        Returns:
            List of resource IDs in safe deletion order
        """
        graph = self.build_dependency_graph()
        depends_on = graph['depends_on']
        
        # Filter by resource group if specified
        if resource_group:
            depends_on = {
                k: v for k, v in depends_on.items() 
                if f'/resourcegroups/{resource_group.lower()}/' in k.lower()
            }
        
        # Topological sort for deletion order
        deletion_order = []
        visited = set()
        
        def visit(resource_id: str):
            if resource_id in visited:
                return
            visited.add(resource_id)
            
            # Visit dependencies first
            for dependency in depends_on.get(resource_id, set()):
                if dependency not in visited:
                    visit(dependency)
            
            deletion_order.append(resource_id)
        
        # Visit all resources
        for resource_id in depends_on.keys():
            visit(resource_id)
        
        # Reverse to get deletion order (dependents before dependencies)
        deletion_order.reverse()
        return deletion_order
    
    def check_resource_can_be_deleted(self, resource_id: str) -> Dict:
        """
        Check if a resource can be safely deleted.
        
        Args:
            resource_id: Azure resource ID
            
        Returns:
            Dictionary with deletion safety information
        """
        graph = self.build_dependency_graph()
        depended_by = graph['depended_by']
        
        dependents = depended_by.get(resource_id, set())
        
        return {
            'resource_id': resource_id,
            'can_delete_safely': len(dependents) == 0,
            'blocking_resources': list(dependents),
            'message': (
                'Resource can be safely deleted' 
                if len(dependents) == 0 
                else f'Resource has {len(dependents)} dependent resource(s)'
            )
        }
    
    def print_dependency_report(self, resource_group: str = None):
        """
        Print a formatted dependency report.
        
        Args:
            resource_group: Optional resource group to scope the report
        """
        print("\n" + "="*80)
        print("AZURE RESOURCE DEPENDENCY REPORT")
        print("="*80 + "\n")
        
        if resource_group:
            print(f"Scope: Resource Group '{resource_group}'")
        else:
            print(f"Scope: Subscriptions {', '.join(self.subscription_ids)}")
        
        graph = self.build_dependency_graph()
        depends_on = graph['depends_on']
        depended_by = graph['depended_by']
        
        # Filter by resource group if specified
        if resource_group:
            depends_on = {
                k: v for k, v in depends_on.items() 
                if f'/resourcegroups/{resource_group.lower()}/' in k.lower()
            }
            depended_by = {
                k: v for k, v in depended_by.items() 
                if f'/resourcegroups/{resource_group.lower()}/' in k.lower()
            }
        
        print(f"\n📊 Total Resources Analyzed: {len(set(list(depends_on.keys()) + list(depended_by.keys())))}")
        
        # Resources with dependencies
        print(f"\n🔗 Resources with Dependencies: {len(depends_on)}")
        for resource_id, dependencies in sorted(depends_on.items()):
            if dependencies:
                resource_name = resource_id.split('/')[-1]
                resource_type = '/'.join(resource_id.split('/')[6:8])
                print(f"\n  • {resource_name} ({resource_type})")
                print(f"    Depends on {len(dependencies)} resource(s):")
                for dep in dependencies:
                    dep_name = dep.split('/')[-1]
                    dep_type = '/'.join(dep.split('/')[6:8])
                    print(f"      → {dep_name} ({dep_type})")
        
        # Resources that others depend on
        print(f"\n⚠️  Resources Others Depend On: {len(depended_by)}")
        for resource_id, dependents in sorted(depended_by.items()):
            if dependents:
                resource_name = resource_id.split('/')[-1]
                resource_type = '/'.join(resource_id.split('/')[6:8])
                print(f"\n  • {resource_name} ({resource_type})")
                print(f"    ⚠️  {len(dependents)} resource(s) depend on this:")
                for dep in dependents:
                    dep_name = dep.split('/')[-1]
                    dep_type = '/'.join(dep.split('/')[6:8])
                    print(f"      ← {dep_name} ({dep_type})")
        
        # Get deletion order
        print(f"\n🗑️  Safe Deletion Order:")
        deletion_order = self.get_deletion_order(resource_group)
        for i, resource_id in enumerate(deletion_order, 1):
            resource_name = resource_id.split('/')[-1]
            resource_type = '/'.join(resource_id.split('/')[6:8])
            print(f"  {i}. {resource_name} ({resource_type})")
        
        # Check for locks
        locks = self.get_resource_locks()
        if locks:
            print(f"\n🔒 Resource Locks Found: {len(locks)}")
            for lock in locks:
                if lock.get('lockName'):
                    print(f"  • RG: {lock.get('resourceGroup')} - Lock: {lock.get('lockName')} ({lock.get('lockLevel')})")
        
        print("\n" + "="*80 + "\n")
    
    def export_to_json(self, filename: str, resource_group: str = None):
        """
        Export dependency information to JSON file.
        
        Args:
            filename: Output filename
            resource_group: Optional resource group to scope the export
        """
        graph = self.build_dependency_graph()
        deletion_order = self.get_deletion_order(resource_group)
        
        output = {
            'subscription_ids': self.subscription_ids,
            'resource_group': resource_group,
            'dependency_graph': {
                'depends_on': {k: list(v) for k, v in graph['depends_on'].items()},
                'depended_by': {k: list(v) for k, v in graph['depended_by'].items()}
            },
            'safe_deletion_order': deletion_order
        }
        
        with open(filename, 'w') as f:
            json.dump(output, f, indent=2)
        
        print(f"✅ Dependency information exported to {filename}")


def main():
    """
    Main execution function.
    """
    # Configuration
    SUBSCRIPTION_IDS = ["<enter subscription id>"]  # Add your subscription IDs here
    RESOURCE_GROUP = None  # Set to a specific resource group name or None for all
    
    print("🚀 Starting Azure Resource Dependency Check...")
    
    try:
        # Initialize checker
        checker = AzureDependencyChecker(SUBSCRIPTION_IDS)
        
        # Print dependency report
        checker.print_dependency_report(RESOURCE_GROUP)
        
        # Export to JSON
        output_file = "azure_dependencies.json"
        checker.export_to_json(output_file, RESOURCE_GROUP)
        
        # Example: Check if specific resource can be deleted
        # resource_id = "/subscriptions/xxx/resourceGroups/yyy/providers/Microsoft.Network/publicIPAddresses/zzz"
        # result = checker.check_resource_can_be_deleted(resource_id)
        # print(f"\nCan delete {result['resource_id']}? {result['can_delete_safely']}")
        # print(f"Message: {result['message']}")
        
    except AzureError as e:
        print(f"❌ Error: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")


if __name__ == "__main__":
    main()
