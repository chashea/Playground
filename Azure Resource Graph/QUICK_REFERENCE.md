# Azure Resource Graph - Quick Reference Card

## 🚀 Running Queries

### Azure Portal
1. Search for "Resource Graph Explorer"
2. Paste query → Click "Run Query"

### Azure CLI
```bash
az graph query -q "YOUR_QUERY" --subscriptions YOUR_SUB_ID
```

### PowerShell
```powershell
Search-AzGraph -Query "YOUR_QUERY" -Subscription YOUR_SUB_ID
```

### Using Scripts (Easiest)
```bash
# Run all queries
./run_all_queries.sh YOUR_SUB_ID [RESOURCE_GROUP]

# Run single query
./run_single_query.sh QUERY_FILE.kql YOUR_SUB_ID [RESOURCE_GROUP]
```

---

## 📁 Available Query Files

| File | Purpose | Most Useful For |
|------|---------|-----------------|
| `01_all_dependencies.kql` | All resources | Initial overview |
| `02_vm_dependencies.kql` | VM dependencies | Before deleting VMs |
| `03_network_dependencies.kql` | Network resources | Firewall/Bastion planning |
| `04_nic_dependencies.kql` | NIC attachments | Network cleanup |
| `05_disk_dependencies.kql` | Disk attachments | Finding orphaned disks |
| `06_public_ip_dependencies.kql` | Public IP usage | IP cleanup |
| `07_vnet_dependencies.kql` | VNet structure | Network architecture |
| `08_resource_locks.kql` | Resource locks | Deletion troubleshooting |
| `09_unused_resources.kql` | Unused resources | Cost optimization |
| `10_deletion_order.kql` | Safe deletion order | Resource group cleanup |
| `11_firewall_dependencies.kql` | Firewall details | Firewall management |
| `12_bastion_dependencies.kql` | Bastion details | Bastion management |
| `13_storage_dependencies.kql` | Storage accounts | Storage cleanup |
| `14_cross_resource_group_deps.kql` | Cross-RG deps | RG deletion planning |
| `15_resource_summary.kql` | Resource summary | Environment overview |

---

## 🎯 Common Use Cases

### 1. Before Deleting a VM
```bash
./run_single_query.sh 02_vm_dependencies.kql YOUR_SUB_ID
```
Shows: NICs, Disks, Availability Sets attached to VMs

### 2. Before Deleting a Resource Group
```bash
./run_single_query.sh 10_deletion_order.kql YOUR_SUB_ID YOUR_RG
```
Shows: Safe deletion order for all resources in RG

### 3. Find Unused Resources
```bash
./run_single_query.sh 09_unused_resources.kql YOUR_SUB_ID
```
Shows: Unattached disks, NICs, public IPs, empty RGs

### 4. Check for Locks
```bash
./run_single_query.sh 08_resource_locks.kql YOUR_SUB_ID
```
Shows: All locks preventing deletion

### 5. Understand Network Dependencies
```bash
./run_single_query.sh 03_network_dependencies.kql YOUR_SUB_ID
```
Shows: Firewalls, Bastion, Gateways, and their dependencies

---

## 📊 Output Formats

```bash
# Human-readable table
az graph query -q "QUERY" --subscriptions SUB_ID --output table

# JSON for automation
az graph query -q "QUERY" --subscriptions SUB_ID --output json

# Export to file
az graph query -q "QUERY" --subscriptions SUB_ID --output json > output.json
```

---

## 🔍 KQL Quick Syntax

### Basic Structure
```kql
resources
| where type == 'microsoft.compute/virtualmachines'
| where resourceGroup == 'my-rg'
| project name, location, id
| order by name
```

### Common Operators
- `where` - Filter rows
- `project` - Select columns
- `extend` - Add calculated columns
- `summarize` - Aggregate data
- `order by` - Sort results
- `take` - Limit results
- `mv-expand` - Expand arrays

### Common Filters
```kql
| where type == 'TYPE'                    // Specific resource type
| where resourceGroup == 'RG_NAME'        // Specific resource group
| where name contains 'vm'                // Name contains text
| where location == 'eastus2'             // Specific location
| where tags['env'] == 'prod'             // Tag filter
```

### Useful Functions
- `tostring()` - Convert to string
- `toint()` - Convert to integer
- `array_length()` - Array size
- `split()` - Split string
- `isnull()` - Check if null
- `isnotnull()` - Check if not null
- `ago()` - Time ago (e.g., `ago(7d)`)

---

## 🛠️ Troubleshooting

### "Resource Graph extension not found"
```bash
az extension add --name resource-graph
```

### "Not authenticated"
```bash
az login
```

### "Permission denied"
Need **Reader** role:
```bash
az role assignment create --assignee USER --role Reader --scope /subscriptions/SUB_ID
```

### Query returns no results
- Check resource group name (case-sensitive)
- Verify subscription ID
- Check resource type spelling

### Query timeout
- Add `| take 100` to limit results
- Filter by resource group first

---

## 💡 Pro Tips

### 1. Multiple Subscriptions
```bash
az graph query -q "QUERY" --subscriptions SUB1 SUB2 SUB3
```

### 2. Save Frequently Used Queries
```bash
alias vm-deps='az graph query -q "$(cat queries/02_vm_dependencies.kql)" --subscriptions'
vm-deps YOUR_SUB_ID
```

### 3. Combine with jq for JSON Processing
```bash
az graph query -q "QUERY" --subscriptions SUB_ID --output json | jq '.data[] | .name'
```

### 4. Export All Results
```bash
./run_all_queries.sh YOUR_SUB_ID
# Creates output/TIMESTAMP/ directory with all results
```

### 5. Filter by Resource Group
```bash
./run_all_queries.sh YOUR_SUB_ID YOUR_RESOURCE_GROUP
```

---

## 🔗 Quick Links

- **Portal**: [Resource Graph Explorer](https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade)
- **Docs**: [Azure Resource Graph Documentation](https://docs.microsoft.com/azure/governance/resource-graph/)
- **KQL Reference**: [Kusto Query Language](https://docs.microsoft.com/azure/data-explorer/kql-quick-reference)

---

## 📞 Need Help?

1. Check `EXAMPLES.md` for detailed examples
2. Review query comments in `.kql` files
3. Consult `README.md` for setup instructions

---

## ⚡ One-Liners

```bash
# List all VMs
az graph query -q "resources | where type == 'microsoft.compute/virtualmachines' | project name" --subscriptions YOUR_SUB_ID

# Count resources by type
az graph query -q "resources | summarize count() by type" --subscriptions YOUR_SUB_ID

# Find expensive VMs (large sizes)
az graph query -q "resources | where type == 'microsoft.compute/virtualmachines' | where properties.hardwareProfile.vmSize contains 'Standard_D' | project name, size = properties.hardwareProfile.vmSize" --subscriptions YOUR_SUB_ID

# Find public IPs with addresses
az graph query -q "resources | where type == 'microsoft.network/publicipaddresses' | where isnotnull(properties.ipAddress) | project name, ip = properties.ipAddress" --subscriptions YOUR_SUB_ID

# List all resource groups with resource count
az graph query -q "resources | summarize count() by resourceGroup | order by count_ desc" --subscriptions YOUR_SUB_ID
```
