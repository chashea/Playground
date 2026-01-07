# PowerShell script to run dependency checks on Azure resources

param(
    [string]$ResourceGroup = "",
    [switch]$Export,
    [switch]$Live,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-Host "Azure Dependency Checker" -ForegroundColor Green
    Write-Host "========================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: .\run_dependency_check.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -ResourceGroup NAME    Check specific resource group"
    Write-Host "  -Export               Export results to JSON"
    Write-Host "  -Live                 Run in live mode (make actual changes)"
    Write-Host "  -Help                 Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\run_dependency_check.ps1                                    # Check all resources (dry run)"
    Write-Host "  .\run_dependency_check.ps1 -ResourceGroup rg-eus2-001        # Check specific resource group"
    Write-Host "  .\run_dependency_check.ps1 -ResourceGroup rg-eus2-001 -Export # Check and export to JSON"
    Write-Host "  .\run_dependency_check.ps1 -ResourceGroup rg-eus2-001 -Live   # Actually destroy resources"
    exit 0
}

if ($Help) {
    Show-Help
}

Write-ColorOutput "================================" "Green"
Write-ColorOutput "Azure Dependency Checker" "Green"
Write-ColorOutput "================================`n" "Green"

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-ColorOutput "✓ Python found: $pythonVersion" "Green"
} catch {
    Write-ColorOutput "Error: Python is not installed or not in PATH" "Red"
    exit 1
}

# Check if Azure CLI is installed
try {
    $azVersion = az --version 2>&1 | Select-Object -First 1
    Write-ColorOutput "✓ Azure CLI found" "Green"
} catch {
    Write-ColorOutput "Warning: Azure CLI not found. Make sure you have valid Azure credentials." "Yellow"
}

# Check if virtual environment exists
if (-not (Test-Path "venv")) {
    Write-ColorOutput "Creating virtual environment..." "Yellow"
    python -m venv venv
}

# Activate virtual environment
Write-ColorOutput "Activating virtual environment..." "Green"
& ".\venv\Scripts\Activate.ps1"

# Install/upgrade dependencies
Write-ColorOutput "Installing dependencies..." "Green"
pip install -q --upgrade pip
pip install -q -r requirements.txt

# Check if user is logged in to Azure
if (Get-Command az -ErrorAction SilentlyContinue) {
    try {
        az account show | Out-Null
        Write-ColorOutput "✓ Azure authentication verified" "Green"
    } catch {
        Write-ColorOutput "Not logged in to Azure. Running 'az login'..." "Yellow"
        az login
    }
}

# Run the dependency checker
Write-ColorOutput "`nRunning dependency check...`n" "Green"

if (-not $Live) {
    python check_azure_dependencies.py
} else {
    Write-ColorOutput "⚠️  WARNING: Running in LIVE mode!" "Red"
    $confirm = Read-Host "Are you sure you want to proceed? (yes/no)"
    if ($confirm -ne "yes") {
        Write-ColorOutput "Operation cancelled" "Yellow"
        exit 0
    }
    python safe_destroy_resources.py
}

# Export to JSON if requested
if ($Export) {
    Write-ColorOutput "`nResults exported to azure_dependencies.json" "Green"
}

Write-ColorOutput "`n✓ Dependency check complete!`n" "Green"

# Deactivate virtual environment
deactivate
