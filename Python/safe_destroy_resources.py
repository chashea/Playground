"""
Safe Azure Resource Destroyer with Dependency Checking
This script checks dependencies before destroying resources to prevent failures.
"""

from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.containerservice import ContainerServiceClient
from azure.mgmt.sql import SqlManagementClient
from azure.mgmt.web import WebSiteManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.core.exceptions import AzureError
from check_azure_dependencies import AzureDependencyChecker
from typing import List, Set
import time


class SafeResourceDestroyer:
    """
    Safely destroy Azure resources by checking dependencies first.
    """
    
    def __init__(self, subscription_id: str, dry_run: bool = True):
        """
        Initialize the safe resource destroyer.
        
        Args:
            subscription_id: Azure subscription ID
            dry_run: If True, only show what would be done without making changes
        """
        self.subscription_id = subscription_id
        self.dry_run = dry_run
        self.credential = DefaultAzureCredential()
        
        # Initialize management clients
        self.resource_client = ResourceManagementClient(self.credential, subscription_id)
        self.compute_client = ComputeManagementClient(self.credential, subscription_id)
        self.aks_client = ContainerServiceClient(self.credential, subscription_id)
        self.sql_client = SqlManagementClient(self.credential, subscription_id)
        self.web_client = WebSiteManagementClient(self.credential, subscription_id)
        self.network_client = NetworkManagementClient(self.credential, subscription_id)
        self.storage_client = StorageManagementClient(self.credential, subscription_id)
        
        # Initialize dependency checker
        self.dependency_checker = AzureDependencyChecker([subscription_id])
        
    def check_dependencies_before_deletion(self, resource_group: str = None):
        """
        Check and report dependencies before any deletion.
        
        Args:
            resource_group: Optional resource group to scope the check
        """
        print("\n" + "="*80)
        print("🔍 CHECKING RESOURCE DEPENDENCIES...")
        print("="*80 + "\n")
        
        self.dependency_checker.print_dependency_report(resource_group)
    
    def get_safe_deletion_order(self, resource_group: str = None) -> List[str]:
        """
        Get the safe deletion order for resources.
        
        Args:
            resource_group: Optional resource group to scope the deletion
            
        Returns:
            List of resource IDs in safe deletion order
        """
        return self.dependency_checker.get_deletion_order(resource_group)
    
    def stop_or_deallocate_resource(self, resource_id: str, resource_type: str, 
                                   resource_name: str, resource_group: str):
        """
        Stop or deallocate a specific resource based on its type.
        
        Args:
            resource_id: Azure resource ID
            resource_type: Type of resource
            resource_name: Name of the resource
            resource_group: Resource group name
        """
        try:
            action_taken = False
            
            if 'virtualmachines' in resource_type.lower():
                print(f"{'[DRY RUN] Would stop' if self.dry_run else 'Stopping'} VM: {resource_name}")
                if not self.dry_run:
                    self.compute_client.virtual_machines.begin_deallocate(
                        resource_group, resource_name
                    ).wait()
                action_taken = True
                
            elif 'managedclusters' in resource_type.lower():
                print(f"{'[DRY RUN] Would scale down' if self.dry_run else 'Scaling down'} AKS: {resource_name}")
                if not self.dry_run:
                    node_pools = self.aks_client.agent_pools.list(resource_group, resource_name)
                    for pool in node_pools:
                        print(f"  Scaling node pool {pool.name} to 0")
                        pool.count = 0
                        self.aks_client.agent_pools.begin_create_or_update(
                            resource_group, resource_name, pool.name, pool
                        ).wait()
                action_taken = True
                
            elif 'sqldatabases' in resource_type.lower():
                server_name = resource_id.split("/")[8]
                print(f"{'[DRY RUN] Would pause' if self.dry_run else 'Pausing'} SQL DB: {resource_name}")
                if not self.dry_run:
                    self.sql_client.databases.begin_pause(
                        resource_group, server_name, resource_name
                    ).wait()
                action_taken = True
                
            elif 'microsoft.web/sites' in resource_type.lower():
                print(f"{'[DRY RUN] Would stop' if self.dry_run else 'Stopping'} Web App: {resource_name}")
                if not self.dry_run:
                    self.web_client.web_apps.stop(resource_group, resource_name)
                action_taken = True
                
            elif 'azurefirewalls' in resource_type.lower():
                print(f"{'[DRY RUN] Would delete' if self.dry_run else 'Deleting'} Azure Firewall: {resource_name}")
                if not self.dry_run:
                    self.network_client.azure_firewalls.begin_delete(
                        resource_group, resource_name
                    ).wait()
                action_taken = True
                
            elif 'publicipaddresses' in resource_type.lower():
                print(f"{'[DRY RUN] Would delete' if self.dry_run else 'Deleting'} Public IP: {resource_name}")
                if not self.dry_run:
                    self.network_client.public_ip_addresses.begin_delete(
                        resource_group, resource_name
                    ).wait()
                action_taken = True
                
            elif 'virtualnetworkgateways' in resource_type.lower():
                print(f"{'[DRY RUN] Would delete' if self.dry_run else 'Deleting'} VPN Gateway: {resource_name}")
                if not self.dry_run:
                    self.network_client.virtual_network_gateways.begin_delete(
                        resource_group, resource_name
                    ).wait()
                action_taken = True
                
            elif 'microsoft.storage/storageaccounts' in resource_type.lower():
                print(f"{'[DRY RUN] Would delete' if self.dry_run else 'Deleting'} Storage Account: {resource_name}")
                if not self.dry_run:
                    self.storage_client.storage_accounts.delete(resource_group, resource_name)
                action_taken = True
            
            if not action_taken:
                print(f"ℹ️  Resource type {resource_type} not handled by this script")
                
        except AzureError as e:
            print(f"❌ Error processing {resource_name}: {e}")
    
    def destroy_resources_safely(self, resource_group: str = None):
        """
        Destroy resources in safe order based on dependencies.
        
        Args:
            resource_group: Optional resource group to scope the destruction
        """
        # First, check all dependencies
        self.check_dependencies_before_deletion(resource_group)
        
        # Get safe deletion order
        deletion_order = self.get_safe_deletion_order(resource_group)
        
        if not deletion_order:
            print("ℹ️  No resources to destroy")
            return
        
        print("\n" + "="*80)
        print(f"{'🔍 DRY RUN MODE - NO CHANGES WILL BE MADE' if self.dry_run else '⚠️  DESTROYING RESOURCES IN SAFE ORDER'}")
        print("="*80 + "\n")
        
        if not self.dry_run:
            confirmation = input("⚠️  This will destroy resources! Type 'YES' to continue: ")
            if confirmation != "YES":
                print("❌ Destruction cancelled")
                return
        
        # Process resources in safe deletion order
        for i, resource_id in enumerate(deletion_order, 1):
            try:
                # Parse resource ID
                parts = resource_id.split('/')
                resource_group_name = parts[4]
                resource_type = '/'.join(parts[6:8])
                resource_name = parts[-1]
                
                print(f"\n[{i}/{len(deletion_order)}] Processing: {resource_name}")
                print(f"  Type: {resource_type}")
                print(f"  Resource Group: {resource_group_name}")
                
                # Check if resource can be safely deleted
                check_result = self.dependency_checker.check_resource_can_be_deleted(resource_id)
                
                if not check_result['can_delete_safely']:
                    print(f"  ⚠️  Warning: {len(check_result['blocking_resources'])} resources still depend on this")
                    print(f"     {check_result['message']}")
                
                # Stop or deallocate the resource
                self.stop_or_deallocate_resource(
                    resource_id, resource_type, resource_name, resource_group_name
                )
                
                # Small delay between operations
                if not self.dry_run:
                    time.sleep(2)
                
            except Exception as e:
                print(f"❌ Error processing resource {resource_id}: {e}")
                continue
        
        print("\n" + "="*80)
        print(f"✅ {'DRY RUN COMPLETE' if self.dry_run else 'RESOURCE DESTRUCTION COMPLETE'}")
        print("="*80 + "\n")


def main():
    """
    Main execution function.
    """
    # Configuration
    SUBSCRIPTION_ID = "<enter subscription id>"
    RESOURCE_GROUP = None  # Set to specific resource group or None for all
    DRY_RUN = True  # Set to False to actually destroy resources (BE CAREFUL!)
    
    print("🚀 Safe Azure Resource Destroyer with Dependency Checking")
    print(f"   Mode: {'DRY RUN (no changes)' if DRY_RUN else 'LIVE (will make changes)'}")
    print(f"   Subscription: {SUBSCRIPTION_ID}")
    print(f"   Scope: {'Resource Group: ' + RESOURCE_GROUP if RESOURCE_GROUP else 'All Resources'}\n")
    
    try:
        destroyer = SafeResourceDestroyer(SUBSCRIPTION_ID, dry_run=DRY_RUN)
        destroyer.destroy_resources_safely(RESOURCE_GROUP)
        
    except AzureError as e:
        print(f"❌ Azure Error: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")


if __name__ == "__main__":
    main()
