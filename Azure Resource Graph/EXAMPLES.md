# Azure Resource Graph Queries - Practical Examples

## 🚀 Quick Start Examples

### Example 1: Check VM Dependencies Before Deletion

**Scenario**: You want to delete a VM but need to know what resources are attached to it.

**Using Azure Portal:**
1. Go to Azure Portal → Resource Graph Explorer
2. Paste this query:

```kql
resources
| where type == 'microsoft.compute/virtualmachines'
| where name == 'YOUR_VM_NAME'
| extend 
    nicIds = properties.networkProfile.networkInterfaces,
    osDiskId = properties.storageProfile.osDisk.managedDisk.id,
    dataDisks = properties.storageProfile.dataDisks
| mv-expand nicIds
| project 
    vmName = name,
    nicId = tostring(nicIds.id),
    osDiskId,
    dataDisksCount = array_length(dataDisks)
```

3. Replace `YOUR_VM_NAME` with your VM name
4. Click "Run Query"

**Using Azure CLI:**
```bash
az graph query -q "resources | where type == 'microsoft.compute/virtualmachines' | where name == 'YOUR_VM_NAME' | extend nicIds = properties.networkProfile.networkInterfaces, osDiskId = properties.storageProfile.osDisk.managedDisk.id | mv-expand nicIds | project vmName = name, nicId = tostring(nicIds.id), osDiskId" --subscriptions YOUR_SUB_ID
```

**Using the provided query file:**
```bash
./run_single_query.sh 02_vm_dependencies.kql YOUR_SUB_ID
```

---

### Example 2: Find What's Using a Public IP

**Scenario**: You have a public IP and want to know what resource is using it before deletion.

**Query:**
```kql
resources
| where type == 'microsoft.network/publicipaddresses'
| where name == 'YOUR_PUBLIC_IP_NAME'
| extend attachedTo = properties.ipConfiguration.id
| project 
    publicIpName = name,
    ipAddress = properties.ipAddress,
    attachedToResource = tostring(attachedTo),
    attachedToType = tostring(split(attachedTo, '/')[7]),
    attachedToName = tostring(split(attachedTo, '/')[8])
```

**Azure CLI:**
```bash
az graph query -q "$(cat queries/06_public_ip_dependencies.kql)" --subscriptions YOUR_SUB_ID
```

---

### Example 3: Find Unused Resources (Cost Optimization)

**Scenario**: You want to find resources that are not being used to reduce costs.

**Unattached Disks:**
```kql
resources
| where type == 'microsoft.compute/disks'
| where properties.diskState == 'Unattached'
| extend diskSizeGB = properties.diskSizeGB, sku = sku.name
| project name, resourceGroup, diskSizeGB, sku, location
```

**Unattached Public IPs:**
```kql
resources
| where type == 'microsoft.network/publicipaddresses'
| where isnull(properties.ipConfiguration.id)
| project name, resourceGroup, location, ipAddress = properties.ipAddress
```

**Run all unused resource checks:**
```bash
./run_single_query.sh 09_unused_resources.kql YOUR_SUB_ID
```

---

### Example 4: Plan Resource Group Deletion Order

**Scenario**: You need to delete an entire resource group and want to know the safe order.

**Query:**
```bash
# Replace YOUR_RESOURCE_GROUP with your actual resource group name
./run_single_query.sh 10_deletion_order.kql YOUR_SUB_ID YOUR_RESOURCE_GROUP
```

Or manually:
```kql
resources
| where resourceGroup == 'YOUR_RESOURCE_GROUP'
| extend priority = case(
    type == 'microsoft.compute/virtualmachines', 1,
    type == 'microsoft.network/networkinterfaces', 3,
    type == 'microsoft.network/publicipaddresses', 4,
    type == 'microsoft.network/virtualnetworks', 5,
    7
)
| project priority, type, name
| order by priority
```

---

### Example 5: Check Azure Firewall Dependencies

**Scenario**: You want to understand what resources your Azure Firewall depends on.

**Azure CLI:**
```bash
./run_single_query.sh 11_firewall_dependencies.kql YOUR_SUB_ID
```

**Result shows:**
- Firewall name and location
- Public IP addresses attached
- Subnet ID (AzureFirewallSubnet)
- Firewall policy ID
- SKU and tier

---

### Example 6: Find Cross-Resource Group Dependencies

**Scenario**: Before deleting a resource group, you want to ensure no resources in other RGs depend on it.

**Query:**
```bash
./run_single_query.sh 14_cross_resource_group_deps.kql YOUR_SUB_ID
```

This shows:
- NICs in one RG attached to VMs in another RG
- Disks in one RG attached to VMs in another RG
- Network resources spanning multiple RGs

---

### Example 7: Check for Resource Locks

**Scenario**: Resources won't delete and you suspect locks are preventing it.

**Query:**
```bash
./run_single_query.sh 08_resource_locks.kql YOUR_SUB_ID
```

**Or specific resource group:**
```kql
authorizationresources
| where type == 'microsoft.authorization/locks'
| where id contains '/resourceGroups/YOUR_RG/'
| extend lockLevel = properties.level
| project lockName = name, lockLevel, resource = split(id, '/providers/Microsoft.Authorization')[0]
```

---

### Example 8: Understand NIC Dependencies

**Scenario**: You want to see which VMs are using which NICs and subnets.

**Query:**
```bash
./run_single_query.sh 04_nic_dependencies.kql YOUR_SUB_ID
```

**Custom query for specific subnet:**
```kql
resources
| where type == 'microsoft.network/networkinterfaces'
| extend subnetId = properties.ipConfigurations[0].properties.subnet.id
| where subnetId contains 'YOUR_SUBNET_NAME'
| project 
    nicName = name,
    vmName = tostring(split(properties.virtualMachine.id, '/')[8]),
    privateIP = properties.ipConfigurations[0].properties.privateIPAddress
```

---

### Example 9: Get Complete Environment Overview

**Scenario**: You want a dashboard-like view of all your resources.

**Run all queries:**
```bash
# Linux/Mac
./run_all_queries.sh YOUR_SUB_ID

# Windows
.\run_all_queries.ps1 -SubscriptionId YOUR_SUB_ID
```

This creates a timestamped folder with JSON outputs for all queries and a summary report.

---

### Example 10: Export Dependencies to JSON for Automation

**Scenario**: You want to use the dependency data in a script or pipeline.

**Export specific query:**
```bash
az graph query -q "$(cat queries/02_vm_dependencies.kql)" \
  --subscriptions YOUR_SUB_ID \
  --output json > vm_deps.json
```

**Process in Python:**
```python
import json

with open('vm_deps.json', 'r') as f:
    data = json.load(f)

for vm in data['data']:
    print(f"VM: {vm['vmName']}")
    print(f"  NIC: {vm['nicId']}")
    print(f"  OS Disk: {vm['osDiskId']}")
```

---

## 🎯 Advanced Examples

### Example 11: Find All Resources Depending on a Specific VNet

```kql
resources
| where type == 'microsoft.network/virtualnetworks'
| where name == 'YOUR_VNET_NAME'
| extend subnets = properties.subnets
| mv-expand subnets
| extend subnetId = tostring(subnets.id)
| project vnetName = name, subnetId
| join kind=inner (
    resources
    | where type == 'microsoft.network/networkinterfaces'
    | extend subnetId = tostring(properties.ipConfigurations[0].properties.subnet.id)
    | project nicName = name, subnetId, vmId = properties.virtualMachine.id
) on subnetId
| project vnetName, subnetId, nicName, vmId
```

### Example 12: Find Resources Created in Last 7 Days

```kql
resources
| where type in (
    'microsoft.compute/virtualmachines',
    'microsoft.network/publicipaddresses',
    'microsoft.storage/storageaccounts'
)
| extend createdDate = todatetime(properties.timeCreated)
| where createdDate >= ago(7d)
| project name, type, resourceGroup, createdDate
| order by createdDate desc
```

### Example 13: Find VMs with Unmanaged Disks

```kql
resources
| where type == 'microsoft.compute/virtualmachines'
| where isnotnull(properties.storageProfile.osDisk.vhd)
| project 
    vmName = name,
    resourceGroup,
    osDiskVhd = properties.storageProfile.osDisk.vhd.uri
```

### Example 14: Calculate Total Disk Size by Resource Group

```kql
resources
| where type == 'microsoft.compute/disks'
| extend diskSizeGB = toint(properties.diskSizeGB)
| summarize 
    totalDisks = count(),
    totalSizeGB = sum(diskSizeGB)
    by resourceGroup
| order by totalSizeGB desc
```

### Example 15: Find NSGs and What They're Attached To

```kql
resources
| where type == 'microsoft.network/networksecuritygroups'
| extend 
    subnets = properties.subnets,
    nics = properties.networkInterfaces
| project 
    nsgName = name,
    resourceGroup,
    subnetsCount = array_length(subnets),
    nicsCount = array_length(nics),
    subnets,
    nics
```

---

## 🔧 Integration Examples

### GitHub Actions

```yaml
- name: Check Dependencies
  run: |
    RESULTS=$(az graph query -q "$(cat queries/02_vm_dependencies.kql)" \
      --subscriptions ${{ secrets.AZURE_SUBSCRIPTION_ID }} \
      --output json)
    
    echo "::set-output name=dependencies::$RESULTS"
```

### Azure DevOps

```yaml
- task: AzureCLI@2
  inputs:
    scriptType: 'bash'
    scriptLocation: 'inlineScript'
    inlineScript: |
      cd "Azure Resource Graph"
      ./run_all_queries.sh $(SUBSCRIPTION_ID)
```

### Terraform

```bash
# Before terraform destroy
./run_all_queries.sh YOUR_SUB_ID YOUR_RG > pre_destroy_deps.txt

# Review dependencies
cat pre_destroy_deps.txt

# Then run terraform
terraform destroy
```

---

## 📊 Output Formats

### Table Format (Human Readable)
```bash
az graph query -q "QUERY" --subscriptions SUB_ID --output table
```

### JSON Format (Automation)
```bash
az graph query -q "QUERY" --subscriptions SUB_ID --output json
```

### YAML Format
```bash
az graph query -q "QUERY" --subscriptions SUB_ID --output yaml
```

### TSV Format (Spreadsheet)
```bash
az graph query -q "QUERY" --subscriptions SUB_ID --output tsv > output.tsv
```

---

## 🎓 Tips & Tricks

### 1. Filter by Tags
```kql
resources
| where tags['environment'] == 'production'
| where type == 'microsoft.compute/virtualmachines'
```

### 2. Search Across Multiple Subscriptions
```bash
az graph query -q "QUERY" --subscriptions SUB_ID1 SUB_ID2 SUB_ID3
```

### 3. Use Management Groups
```bash
az graph query -q "QUERY" --management-groups MG_ID
```

### 4. Limit Results
```kql
resources
| where type == 'microsoft.compute/virtualmachines'
| take 10
```

### 5. Count Results
```kql
resources
| where type == 'microsoft.compute/virtualmachines'
| count
```

---

## 📚 Additional Resources

- [KQL Quick Reference](https://docs.microsoft.com/azure/data-explorer/kql-quick-reference)
- [Resource Graph Samples](https://docs.microsoft.com/azure/governance/resource-graph/samples/starter)
- [Query Language Documentation](https://docs.microsoft.com/azure/governance/resource-graph/concepts/query-language)
