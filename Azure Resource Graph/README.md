# Azure Resource Graph Queries for Dependency Checking

Azure Resource Graph is the fastest and most efficient way to check dependencies across your Azure environment. It uses KQL (Kusto Query Language) to query resources at scale.

## 🚀 Quick Start

### Option 1: Azure Portal
1. Go to [Azure Portal](https://portal.azure.com)
2. Search for "Resource Graph Explorer"
3. Paste any query from this collection
4. Click "Run Query"

### Option 2: Azure CLI
```bash
az graph query -q "resources | take 5"
```

### Option 3: PowerShell
```powershell
Search-AzGraph -Query "resources | take 5"
```

### Option 4: Python (Programmatic)
```python
from azure.identity import DefaultAzureCredential
from azure.mgmt.resourcegraph import ResourceGraphClient
from azure.mgmt.resourcegraph.models import QueryRequest

credential = DefaultAzureCredential()
client = ResourceGraphClient(credential)
query = QueryRequest(subscriptions=["your-sub-id"], query="resources | take 5")
response = client.resources(query)
```

## 📚 Query Collection

See the `queries/` directory for all queries organized by category.

## 🎯 Most Useful Queries

1. **All Resource Dependencies** - `queries/01_all_dependencies.kql`
2. **VM Dependencies** - `queries/02_vm_dependencies.kql`
3. **Network Dependencies** - `queries/03_network_dependencies.kql`
4. **Safe Deletion Order** - `queries/10_deletion_order.kql`

## 🔧 Running Queries

### Using the Provided Scripts

**Run all queries:**
```bash
./run_all_queries.sh your-subscription-id
```

**Run specific query:**
```bash
az graph query -q "$(cat queries/02_vm_dependencies.kql)" --subscriptions your-sub-id
```

**Export to JSON:**
```bash
az graph query -q "$(cat queries/02_vm_dependencies.kql)" \
  --subscriptions your-sub-id \
  --output json > vm_dependencies.json
```

## 📖 Learning KQL

- [KQL Quick Reference](https://docs.microsoft.com/azure/data-explorer/kql-quick-reference)
- [Resource Graph Query Language](https://docs.microsoft.com/azure/governance/resource-graph/concepts/query-language)
