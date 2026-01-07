# PowerShell script to run all Azure Resource Graph queries

param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroup = ""
)

$ErrorActionPreference = "Stop"

Write-Host "================================" -ForegroundColor Green
Write-Host "Azure Resource Graph Query Runner" -ForegroundColor Green
Write-Host "================================`n" -ForegroundColor Green
Write-Host "Subscription ID: $SubscriptionId" -ForegroundColor Blue
if ($ResourceGroup) {
    Write-Host "Resource Group: $ResourceGroup" -ForegroundColor Blue
}
Write-Host ""

# Check if Azure CLI is installed
try {
    az --version | Out-Null
} catch {
    Write-Host "Error: Azure CLI is not installed" -ForegroundColor Yellow
    exit 1
}

# Check if logged in
try {
    az account show | Out-Null
} catch {
    Write-Host "Not logged in. Running 'az login'..." -ForegroundColor Yellow
    az login
}

# Set subscription
az account set --subscription $SubscriptionId

# Check if Resource Graph extension is installed
$rgExtension = az extension list --query "[?name=='resource-graph']" -o tsv
if (-not $rgExtension) {
    Write-Host "Installing Resource Graph extension..." -ForegroundColor Yellow
    az extension add --name resource-graph
}

# Create output directory
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputDir = "output/$timestamp"
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

Write-Host "`nRunning queries...`n" -ForegroundColor Green

# Query definitions
$queries = @{
    "01_all_dependencies.kql" = "All Resources with Dependencies"
    "02_vm_dependencies.kql" = "Virtual Machine Dependencies"
    "03_network_dependencies.kql" = "Network Resource Dependencies"
    "04_nic_dependencies.kql" = "Network Interface Dependencies"
    "05_disk_dependencies.kql" = "Managed Disk Dependencies"
    "06_public_ip_dependencies.kql" = "Public IP Address Dependencies"
    "07_vnet_dependencies.kql" = "Virtual Network Dependencies"
    "08_resource_locks.kql" = "Resource Locks"
    "09_unused_resources.kql" = "Potentially Unused Resources"
    "10_deletion_order.kql" = "Resource Deletion Order"
    "11_firewall_dependencies.kql" = "Azure Firewall Dependencies"
    "12_bastion_dependencies.kql" = "Azure Bastion Dependencies"
    "13_storage_dependencies.kql" = "Storage Account Dependencies"
    "14_cross_resource_group_deps.kql" = "Cross-Resource Group Dependencies"
    "15_resource_summary.kql" = "Resource Summary by Type"
}

# Run each query
foreach ($queryFile in $queries.Keys | Sort-Object) {
    $description = $queries[$queryFile]
    $queryPath = "queries/$queryFile"
    $outputFile = "$outputDir/$($queryFile -replace '.kql', '.json')"
    
    if (-not (Test-Path $queryPath)) {
        Write-Host "⚠ Skipping $queryFile - file not found" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "Running: $description" -ForegroundColor Blue
    
    # Read and modify query
    $query = Get-Content -Path $queryPath -Raw
    
    # Add resource group filter if specified
    if ($ResourceGroup -and $queryFile -ne "08_resource_locks.kql") {
        if ($query -notmatch "resourceGroup" -or $query -match "YOUR_RESOURCE_GROUP") {
            $query = $query -replace "YOUR_RESOURCE_GROUP", $ResourceGroup
            if ($query -notmatch "where resourceGroup ==") {
                $lines = $query -split "`n"
                $query = $lines[0] + "`n| where resourceGroup == '$ResourceGroup'`n" + ($lines[1..($lines.Length-1)] -join "`n")
            }
        }
    } else {
        $query = $query -replace "YOUR_RESOURCE_GROUP", $ResourceGroup
    }
    
    # Run query
    try {
        $query | az graph query --subscriptions $SubscriptionId --output json > $outputFile
        $result = Get-Content $outputFile | ConvertFrom-Json
        $resultCount = $result.data.Count
        Write-Host "  ✓ Results: $resultCount records → $outputFile`n" -ForegroundColor Gray
    } catch {
        Write-Host "  ✗ Query failed`n" -ForegroundColor Red
        "{`"error`": `"Query failed`"}" | Out-File -FilePath $outputFile
    }
}

Write-Host "================================" -ForegroundColor Green
Write-Host "✓ All queries complete!" -ForegroundColor Green
Write-Host "================================`n" -ForegroundColor Green
Write-Host "Results saved to: $outputDir`n" -ForegroundColor Blue

# Generate summary report
Write-Host "Generating summary report..." -ForegroundColor Green
$summaryContent = @"
# Azure Resource Dependency Report
Generated: $(Get-Date)
Subscription: $SubscriptionId
$(if ($ResourceGroup) { "Resource Group: $ResourceGroup" })

## Query Results

"@

foreach ($queryFile in $queries.Keys | Sort-Object) {
    $description = $queries[$queryFile]
    $outputFile = "$outputDir/$($queryFile -replace '.kql', '.json')"
    
    try {
        $result = Get-Content $outputFile | ConvertFrom-Json
        $resultCount = $result.data.Count
    } catch {
        $resultCount = 0
    }
    
    $summaryContent += "- **$description**: $resultCount results`n"
}

$summaryContent | Out-File -FilePath "$outputDir/SUMMARY.md"
Write-Host "`n✓ Summary report: $outputDir/SUMMARY.md`n" -ForegroundColor Green
