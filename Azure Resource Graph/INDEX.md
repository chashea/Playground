# Azure Resource Graph Queries - Complete Index

## 📚 Documentation Files

| File | Description | Read This When... |
|------|-------------|-------------------|
| **README.md** | Setup and getting started | You're new to Azure Resource Graph |
| **QUICK_REFERENCE.md** | One-page cheat sheet | You need a quick command reference |
| **EXAMPLES.md** | Detailed practical examples | You want to see real-world use cases |
| **INDEX.md** | This file - complete navigation | You want to find something specific |

---

## 📁 Query Files (queries/ directory)

### Resource Dependencies

| Query | File | Description | Key Use Case |
|-------|------|-------------|--------------|
| All Dependencies | `01_all_dependencies.kql` | Complete overview of all resources and dependencies | Initial environment assessment |
| VM Dependencies | `02_vm_dependencies.kql` | VMs with NICs, disks, availability sets | Before deleting VMs |
| Network Dependencies | `03_network_dependencies.kql` | Firewalls, Bastion, Gateways, Load Balancers | Network infrastructure planning |
| NIC Dependencies | `04_nic_dependencies.kql` | NICs attached to VMs and subnets | Network interface cleanup |
| Disk Dependencies | `05_disk_dependencies.kql` | Managed disks and VM attachments | Finding orphaned disks |
| Public IP Dependencies | `06_public_ip_dependencies.kql` | Public IPs and what's using them | IP address management |
| VNet Dependencies | `07_vnet_dependencies.kql` | VNets, subnets, and connected resources | Network architecture review |

### Infrastructure Management

| Query | File | Description | Key Use Case |
|-------|------|-------------|--------------|
| Resource Locks | `08_resource_locks.kql` | All locks preventing deletion | Troubleshooting deletion failures |
| Unused Resources | `09_unused_resources.kql` | Unattached resources that may be deleted | Cost optimization |
| Deletion Order | `10_deletion_order.kql` | Safe order to delete resources | Resource group cleanup |

### Specific Resource Types

| Query | File | Description | Key Use Case |
|-------|------|-------------|--------------|
| Firewall Dependencies | `11_firewall_dependencies.kql` | Azure Firewall configuration and dependencies | Firewall management |
| Bastion Dependencies | `12_bastion_dependencies.kql` | Azure Bastion configuration and dependencies | Bastion management |
| Storage Dependencies | `13_storage_dependencies.kql` | Storage account details and usage | Storage management |

### Advanced Analysis

| Query | File | Description | Key Use Case |
|-------|------|-------------|--------------|
| Cross-RG Dependencies | `14_cross_resource_group_deps.kql` | Dependencies spanning resource groups | Multi-RG cleanup planning |
| Resource Summary | `15_resource_summary.kql` | High-level resource statistics | Environment overview |

---

## 🛠️ Execution Scripts

| Script | Platform | Purpose |
|--------|----------|---------|
| `run_all_queries.sh` | Linux/Mac | Run all queries and generate report |
| `run_all_queries.ps1` | Windows/PowerShell | Run all queries and generate report |
| `run_single_query.sh` | Linux/Mac | Run a single specific query |

### Script Usage

**Run all queries:**
```bash
# Linux/Mac
./run_all_queries.sh YOUR_SUB_ID [RESOURCE_GROUP]

# Windows
.\run_all_queries.ps1 -SubscriptionId YOUR_SUB_ID [-ResourceGroup RG_NAME]
```

**Run single query:**
```bash
./run_single_query.sh QUERY_FILE YOUR_SUB_ID [RESOURCE_GROUP]

# Examples:
./run_single_query.sh 02_vm_dependencies.kql abc123...
./run_single_query.sh deletion_order YOUR_SUB_ID rg-test
```

---

## 🎯 Quick Task Finder

### I want to...

**Delete a VM safely**
→ Use `02_vm_dependencies.kql` to see NICs and disks
→ Then use `10_deletion_order.kql` to get safe order

**Clean up a Resource Group**
→ Use `10_deletion_order.kql` with RG filter
→ Check `08_resource_locks.kql` first

**Reduce costs**
→ Use `09_unused_resources.kql` to find orphaned resources
→ Review before deleting

**Understand network layout**
→ Use `03_network_dependencies.kql` for appliances
→ Use `07_vnet_dependencies.kql` for VNet structure
→ Use `04_nic_dependencies.kql` for connections

**Troubleshoot deletion failures**
→ Use `08_resource_locks.kql` to check for locks
→ Use specific dependency query for the resource type

**Plan Azure Firewall changes**
→ Use `11_firewall_dependencies.kql` for current config
→ Check `06_public_ip_dependencies.kql` for IPs

**Migrate resources**
→ Use `14_cross_resource_group_deps.kql` to check cross-RG deps
→ Use specific resource query to understand relationships

**Get environment overview**
→ Use `15_resource_summary.kql` for high-level view
→ Run `./run_all_queries.sh` for complete report

**Find specific resource type dependencies**
→ VM: `02_vm_dependencies.kql`
→ Network: `03_network_dependencies.kql`
→ Firewall: `11_firewall_dependencies.kql`
→ Bastion: `12_bastion_dependencies.kql`

---

## 📊 Output Examples

### Console Output (Table Format)
```
ResourceName    ResourceType                           ResourceGroup    Location
--------------  ------------------------------------   ---------------  --------
vm-web-01       microsoft.compute/virtualmachines      rg-web          eastus2
vm-app-01       microsoft.compute/virtualmachines      rg-app          eastus2
```

### JSON Output (For Automation)
```json
{
  "data": [
    {
      "resourceName": "vm-web-01",
      "resourceType": "microsoft.compute/virtualmachines",
      "resourceGroup": "rg-web",
      "location": "eastus2"
    }
  ]
}
```

### Report Output (run_all_queries.sh)
```
output/
└── 20250105_143022/
    ├── 01_all_dependencies.json
    ├── 02_vm_dependencies.json
    ├── ...
    └── SUMMARY.md
```

---

## 🔍 Query Syntax Reference

### Basic Query Structure
```kql
resources                              // Start with resources table
| where type == 'resource.type'       // Filter by type
| where resourceGroup == 'rg-name'    // Filter by RG
| extend newColumn = property         // Add calculated column
| project col1, col2, col3            // Select columns to show
| order by col1                       // Sort results
```

### Common Filters
```kql
// Resource type
| where type == 'microsoft.compute/virtualmachines'

// Resource group
| where resourceGroup == 'rg-prod'

// Name pattern
| where name contains 'web'

// Location
| where location == 'eastus2'

// Tags
| where tags['environment'] == 'production'

// Multiple conditions
| where type == 'microsoft.compute/virtualmachines' and resourceGroup == 'rg-prod'
```

---

## 🚀 Getting Started Workflow

### First Time Setup
1. **Install Azure CLI** (if not already installed)
   ```bash
   # Check version
   az --version
   ```

2. **Login to Azure**
   ```bash
   az login
   ```

3. **Install Resource Graph Extension**
   ```bash
   az extension add --name resource-graph
   ```

4. **Test with Simple Query**
   ```bash
   az graph query -q "resources | take 5" --subscriptions YOUR_SUB_ID
   ```

### Regular Usage
1. **Choose your query** from the table above
2. **Run it** using one of the methods:
   - Azure Portal (Resource Graph Explorer)
   - Azure CLI command
   - Provided scripts (easiest)
3. **Review results** in table or JSON format
4. **Take action** based on findings

---

## 📋 Common Workflows

### Workflow 1: VM Deletion
```bash
# Step 1: Check VM dependencies
./run_single_query.sh 02_vm_dependencies rg-test

# Step 2: Note down NICs and disks
# Step 3: Stop and delete VM
# Step 4: Delete NICs
# Step 5: Delete disks (if not needed)
```

### Workflow 2: Resource Group Cleanup
```bash
# Step 1: Check for locks
./run_single_query.sh 08_resource_locks rg-test

# Step 2: Get deletion order
./run_single_query.sh 10_deletion_order rg-test

# Step 3: Check cross-RG dependencies
./run_single_query.sh 14_cross_resource_group_deps

# Step 4: Delete resources in order
# Step 5: Delete resource group
```

### Workflow 3: Cost Optimization
```bash
# Step 1: Find unused resources
./run_single_query.sh 09_unused_resources

# Step 2: Review list
# Step 3: Verify resources are truly unused
# Step 4: Delete unused resources
# Step 5: Monitor cost reduction
```

---

## 🔗 Related Resources

### Python Solution
If you prefer programmatic access with more features:
- `/workspace/Python/check_azure_dependencies.py`
- Full Python SDK integration
- Advanced dependency graph building
- Automated safe deletion

### Azure CLI Scripts
For lightweight checks:
- `/workspace/Az Cli/check_dependencies.azcli`
- Pure Azure CLI implementation
- No Python required

### Documentation
- Main Solution Guide: `/workspace/AZURE_DEPENDENCY_SOLUTION.md`
- Quick Start: `/workspace/QUICK_START.md`
- Python Guide: `/workspace/Python/README_DEPENDENCIES.md`

---

## 💡 Tips for Success

1. **Start Small**: Begin with summary query (`15_resource_summary.kql`)
2. **Filter Early**: Use resource group filter to reduce result size
3. **Save Output**: Always export important results to JSON
4. **Check Locks First**: Before deletion, run `08_resource_locks.kql`
5. **Test Queries**: Use `| take 10` to test queries with limited results
6. **Understand Dependencies**: Review dependency queries before making changes
7. **Use Scripts**: The provided scripts handle complexity for you

---

## 🆘 Troubleshooting Guide

| Problem | Solution | Command |
|---------|----------|---------|
| Extension not found | Install Resource Graph extension | `az extension add --name resource-graph` |
| Not authenticated | Login to Azure | `az login` |
| No permissions | Request Reader role | Contact subscription admin |
| Query timeout | Add result limit | Add `\| take 100` to query |
| No results | Check filters | Verify RG name, subscription ID |
| Syntax error | Check KQL syntax | Review examples in EXAMPLES.md |

---

## 📞 Support

- **Examples**: See `EXAMPLES.md`
- **Quick Commands**: See `QUICK_REFERENCE.md`
- **Setup Issues**: See `README.md`
- **KQL Help**: [Microsoft KQL Documentation](https://docs.microsoft.com/azure/data-explorer/kql-quick-reference)

---

## 🎓 Learning Path

1. **Beginner**: Start with `QUICK_REFERENCE.md` and run `15_resource_summary.kql`
2. **Intermediate**: Review `EXAMPLES.md` and run all queries with `run_all_queries.sh`
3. **Advanced**: Modify queries for custom needs, integrate with CI/CD
4. **Expert**: Use Python solution for advanced automation

---

**Last Updated**: 2025-11-05
**Version**: 1.0
