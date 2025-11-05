# Azure Resource Dependency Checker

Automated solution for checking Azure resource dependencies before performing operations like deletion or modification.

## 🎯 Problem Solved

This solution addresses the challenge of understanding Azure resource dependencies to:
- Prevent deletion failures due to dependency conflicts
- Understand the impact of resource changes
- Determine safe deletion order for complex environments
- Automate dependency checking in CI/CD pipelines

## 📦 Components

### 1. `check_azure_dependencies.py`
Standalone dependency checker that uses Azure Resource Graph API to query and analyze resource dependencies across your Azure environment.

**Features:**
- ✅ Queries all resource dependencies efficiently using Resource Graph
- ✅ Identifies "depends on" and "depended by" relationships
- ✅ Calculates safe deletion order using topological sorting
- ✅ Checks for resource locks
- ✅ Exports dependency graph to JSON
- ✅ Provides detailed dependency reports

### 2. `safe_destroy_resources.py`
Enhanced version of your `destroyr_resources.py` that checks dependencies before taking action.

**Features:**
- ✅ Checks dependencies before destroying resources
- ✅ Uses safe deletion order based on dependency analysis
- ✅ Dry-run mode to preview actions without making changes
- ✅ Prevents deletion of resources that others depend on
- ✅ Provides warnings about blocking dependencies

### 3. `requirements.txt`
Python dependencies needed for the scripts.

## 🚀 Setup

### Prerequisites
- Python 3.8 or higher
- Azure CLI installed and authenticated, OR
- Azure credentials configured (Service Principal, Managed Identity, etc.)

### Installation

1. Install Python dependencies:
```bash
pip install -r requirements.txt
```

2. Authenticate with Azure (choose one method):

**Option A: Azure CLI**
```bash
az login
```

**Option B: Service Principal (Environment Variables)**
```bash
export AZURE_CLIENT_ID="<your-client-id>"
export AZURE_CLIENT_SECRET="<your-client-secret>"
export AZURE_TENANT_ID="<your-tenant-id>"
```

**Option C: Managed Identity**
(Automatically works when running on Azure VMs, App Service, etc.)

3. Update configuration in the scripts:
   - Edit `SUBSCRIPTION_IDS` in `check_azure_dependencies.py`
   - Edit `SUBSCRIPTION_ID` in `safe_destroy_resources.py`

## 📖 Usage Examples

### Example 1: Check Dependencies for All Resources

```python
from check_azure_dependencies import AzureDependencyChecker

checker = AzureDependencyChecker(["your-subscription-id"])
checker.print_dependency_report()
```

**Command line:**
```bash
python check_azure_dependencies.py
```

### Example 2: Check Dependencies for Specific Resource Group

```python
checker = AzureDependencyChecker(["your-subscription-id"])
checker.print_dependency_report(resource_group="rg-eus2-001")
```

### Example 3: Export Dependencies to JSON

```python
checker = AzureDependencyChecker(["your-subscription-id"])
checker.export_to_json("dependencies.json", resource_group="rg-eus2-001")
```

### Example 4: Check if Specific Resource Can Be Deleted

```python
resource_id = "/subscriptions/xxx/resourceGroups/yyy/providers/Microsoft.Network/publicIPAddresses/pip-fw"
result = checker.check_resource_can_be_deleted(resource_id)

print(f"Can delete? {result['can_delete_safely']}")
print(f"Blocking resources: {result['blocking_resources']}")
```

### Example 5: Safe Resource Destruction (Dry Run)

```bash
python safe_destroy_resources.py
```

This will:
1. Analyze all dependencies
2. Show what would be done
3. NOT make any actual changes (dry run mode)

### Example 6: Safe Resource Destruction (Live)

⚠️ **WARNING: This will actually destroy resources!**

1. Edit `safe_destroy_resources.py`
2. Set `DRY_RUN = False`
3. Run: `python safe_destroy_resources.py`

## 🔧 Integration with CI/CD

### GitHub Actions Example

```yaml
name: Check Azure Dependencies

on:
  pull_request:
    branches: [ main ]

jobs:
  check-dependencies:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      
      - name: Install dependencies
        run: pip install -r Python/requirements.txt
      
      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      - name: Check Dependencies
        run: |
          cd Python
          python check_azure_dependencies.py
      
      - name: Upload Dependency Report
        uses: actions/upload-artifact@v3
        with:
          name: azure-dependencies
          path: Python/azure_dependencies.json
```

### Azure DevOps Pipeline Example

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.10'
  displayName: 'Use Python 3.10'

- script: |
    pip install -r Python/requirements.txt
  displayName: 'Install dependencies'

- task: AzureCLI@2
  inputs:
    azureSubscription: 'Azure-Connection'
    scriptType: 'bash'
    scriptLocation: 'inlineScript'
    inlineScript: |
      cd Python
      python check_azure_dependencies.py
  displayName: 'Check Azure Dependencies'

- task: PublishBuildArtifacts@1
  inputs:
    pathToPublish: 'Python/azure_dependencies.json'
    artifactName: 'dependency-report'
  displayName: 'Publish Dependency Report'
```

## 📊 Sample Output

```
================================================================================
AZURE RESOURCE DEPENDENCY REPORT
================================================================================

Scope: Resource Group 'rg-eus2-001'

📊 Total Resources Analyzed: 12

🔗 Resources with Dependencies: 8

  • azfw-eus2-001 (microsoft.network/azurefirewalls)
    Depends on 2 resource(s):
      → pip-fw (microsoft.network/publicipaddresses)
      → AzureFirewallSubnet (microsoft.network/virtualnetworks/subnets)

  • bastion-xyz (microsoft.network/bastionhosts)
    Depends on 2 resource(s):
      → pip-bastion (microsoft.network/publicipaddresses)
      → AzureBastionSubnet (microsoft.network/virtualnetworks/subnets)

⚠️  Resources Others Depend On: 4

  • pip-fw (microsoft.network/publicipaddresses)
    ⚠️  1 resource(s) depend on this:
      ← azfw-eus2-001 (microsoft.network/azurefirewalls)

  • vnet-hub-eus2-001 (microsoft.network/virtualnetworks)
    ⚠️  4 resource(s) depend on this:
      ← azfw-eus2-001 (microsoft.network/azurefirewalls)
      ← bastion-xyz (microsoft.network/bastionhosts)

🗑️  Safe Deletion Order:
  1. azfw-eus2-001 (microsoft.network/azurefirewalls)
  2. bastion-xyz (microsoft.network/bastionhosts)
  3. pip-fw (microsoft.network/publicipaddresses)
  4. pip-bastion (microsoft.network/publicipaddresses)
  5. vnet-hub-eus2-001 (microsoft.network/virtualnetworks)

================================================================================
```

## 🔍 How It Works

### Azure Resource Graph
The solution uses Azure Resource Graph, which is:
- **Fast**: Queries across subscriptions in seconds
- **Efficient**: No need to iterate through individual resources
- **Powerful**: Supports complex KQL queries
- **Scalable**: Works with thousands of resources

### Dependency Detection
The tool detects dependencies by analyzing:
1. **VM Dependencies**: NICs, disks, availability sets
2. **Network Dependencies**: Subnets, public IPs, VNets
3. **Firewall Dependencies**: Public IPs, VNets, policies
4. **Bastion Dependencies**: Public IPs, subnets
5. **Storage Dependencies**: Keys, containers
6. **General Dependencies**: ARM template references

### Topological Sorting
Uses topological sorting algorithm to calculate safe deletion order:
- Resources with no dependencies are deleted first
- Resources others depend on are deleted last
- Prevents circular dependency issues

## 🛡️ Permissions Required

The service principal or user needs:
- **Reader** role on subscriptions/resource groups to check dependencies
- **Contributor** role if using `safe_destroy_resources.py` to make changes

## 🎓 Advanced Usage

### Custom Queries
You can add custom Resource Graph queries:

```python
def get_app_service_dependencies(self) -> List[Dict]:
    query = """
    resources
    | where type == 'microsoft.web/sites'
    | extend appServicePlanId = properties.serverFarmId
    | project id, name, type, resourceGroup, appServicePlanId
    """
    return self.query_resource_graph(query)
```

### Integration with Terraform
Export dependencies and use them in Terraform:

```python
checker = AzureDependencyChecker(["subscription-id"])
checker.export_to_json("terraform/dependencies.json")
```

Then in Terraform, use `depends_on` based on the JSON output.

## ⚠️ Important Notes

1. **Dry Run First**: Always test with `DRY_RUN = True` before making changes
2. **Backup**: Take backups before destroying resources
3. **Resource Locks**: Check for resource locks that prevent deletion
4. **Hidden Dependencies**: Some dependencies may not be visible through Resource Graph
5. **Async Operations**: Some operations are asynchronous and may take time

## 🐛 Troubleshooting

### "Subscription not registered for Resource Graph"
```bash
az provider register --namespace Microsoft.ResourceGraph
```

### Authentication Issues
```bash
az login --tenant <tenant-id>
```

### Missing Permissions
Ensure you have at least Reader role:
```bash
az role assignment create --assignee <user-or-sp> --role Reader --scope /subscriptions/<sub-id>
```

## 📚 Resources

- [Azure Resource Graph Documentation](https://docs.microsoft.com/azure/governance/resource-graph/)
- [Azure Python SDK Documentation](https://docs.microsoft.com/python/api/overview/azure/)
- [KQL Query Reference](https://docs.microsoft.com/azure/data-explorer/kusto/query/)

## 🤝 Contributing

Feel free to extend this solution with:
- Additional resource type support
- Custom dependency detection logic
- Integration with other tools (Ansible, ARM templates, etc.)
- Enhanced reporting formats

## 📝 License

This is provided as-is for educational and operational purposes.
