### For Testing Purposes only

from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.containerservice import ContainerServiceClient
from azure.mgmt.sql import SqlManagementClient
from azure.mgmt.web import WebSiteManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.core.exceptions import AzureError

# Authenticate
credential = DefaultAzureCredential()

# Set your subscription ID
subscription_id = "<enter subscription id>"

# Resource Management Client
resource_client = ResourceManagementClient(credential, subscription_id)

# Compute Management Client
compute_client = ComputeManagementClient(credential, subscription_id)

# AKS (Container Service) Management Client
aks_client = ContainerServiceClient(credential, subscription_id)

# SQL Management Client
sql_client = SqlManagementClient(credential, subscription_id)

# Web Site Management Client
web_client = WebSiteManagementClient(credential, subscription_id)

# Network Management Client
network_client = NetworkManagementClient(credential, subscription_id)

# Storage Management Client
storage_client = StorageManagementClient(credential, subscription_id)

# List all resources
try:
    resources = resource_client.resources.list()
except AzureError as e:
    print(f"Failed to list resources: {e}")
    exit(1)

for resource in resources:
    resource_type = resource.type.lower()

    try:
        if 'virtualmachines' in resource_type:
            # Get resource group name and VM name from the resource ID
            resource_group = resource.id.split("/")[4]
            vm_name = resource.name

            print(f"Stopping VM: {vm_name} in resource group: {resource_group}")
            compute_client.virtual_machines.begin_deallocate(resource_group, vm_name).wait()

        elif 'managedclusters' in resource_type:
            # Managed Kubernetes Cluster (AKS)
            resource_group = resource.id.split("/")[4]
            aks_name = resource.name

            print(f"Scaling down AKS cluster: {aks_name} in resource group: {resource_group}")

            # List node pools for the AKS cluster
            node_pools = aks_client.agent_pools.list(resource_group, aks_name)

            # Scale down each node pool to zero
            for pool in node_pools:
                pool_name = pool.name
                print(f"Scaling down node pool: {pool_name} to 0 nodes")
                pool.count = 0
                aks_client.agent_pools.begin_create_or_update(resource_group, aks_name, pool_name, pool).wait()

        elif 'sqldatabases' in resource_type:
            # SQL Database
            resource_group = resource.id.split("/")[4]
            server_name = resource.id.split("/")[8]
            database_name = resource.name

            print(f"Pausing SQL Database: {database_name} on server: {server_name} in resource group: {resource_group}")
            sql_client.databases.begin_pause(resource_group, server_name, database_name).wait()

        elif 'microsoft.web/sites' in resource_type:
            # Web App
            resource_group = resource.id.split("/")[4]
            web_app_name = resource.name

            print(f"Stopping Web App: {web_app_name} in resource group: {resource_group}")
            web_client.web_apps.stop(resource_group, web_app_name)

        elif 'microsoft.web/serverfarms' in resource_type:
            # App Service Plan
            resource_group = resource.id.split("/")[4]
            app_service_plan_name = resource.name

            print(f"Deleting App Service Plan: {app_service_plan_name} in resource group: {resource_group}")
            web_client.app_service_plans.delete(resource_group, app_service_plan_name)

        elif 'microsoft.network' in resource_type:
            # Network resources
            resource_group = resource.id.split("/")[4]
            resource_name = resource.name

            if 'azurefirewalls' in resource_type:
                print(f"Deleting Azure Firewall: {resource_name} in resource group: {resource_group}")
                network_client.azure_firewalls.begin_delete(resource_group, resource_name).wait()

            elif 'publicipaddresses' in resource_type:
                print(f"Deleting Public IP Address: {resource_name} in resource group: {resource_group}")
                network_client.public_ip_addresses.begin_delete(resource_group, resource_name).wait()

            elif 'virtualnetworkgateways' in resource_type:
                print(f"Deleting Virtual Network Gateway: {resource_name} in resource group: {resource_group}")
                network_client.virtual_network_gateways.begin_delete(resource_group, resource_name).wait()

            # Add more network resource types as needed
            else:
                print(f"Network resource type {resource_type} is not specifically handled by this script.")

        elif 'microsoft.storage/storageaccounts' in resource_type:
            # Storage Account
            resource_group = resource.id.split("/")[4]
            storage_account_name = resource.name

            print(f"Deleting Storage Account: {storage_account_name} in resource group: {resource_group}")
            storage_client.storage_accounts.delete(resource_group, storage_account_name)

        # Add more resource types and their shutdown logic as needed
        else:
            print(f"Resource type {resource_type} is not handled by this script.")
    except AzureError as e:
        print(f"Failed to process resource {resource.name} of type {resource_type}: {e}")

print("All specified resources have been stopped or deallocated.")
