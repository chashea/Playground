<#
.SYNOPSIS
    Applies or updates Microsoft Purview sensitivity labels on local files or network shares.

.DESCRIPTION
    This script uses the PurviewInformationProtection module (AIP Unified Labeling Client) to apply
    sensitivity labels to files stored locally or on network shares. This is useful for bulk
    operations on files that haven't been uploaded to SharePoint yet.

.PARAMETER FilePath
    Path to a single file or directory containing files to label

.PARAMETER LabelName
    The display name of the sensitivity label to apply

.PARAMETER LabelId
    The GUID of the sensitivity label to apply (alternative to LabelName)

.PARAMETER FileFilter
    Optional filter for file names when processing directories (e.g., "*.docx", "*.xlsx")

.PARAMETER Recurse
    Process subdirectories recursively

.PARAMETER WhatIf
    Shows what would be done without actually applying the labels

.EXAMPLE
    .\Set-LocalFileSensitivityLabel.ps1 -FilePath "C:\Data\Document.docx" -LabelName "Confidential"

.EXAMPLE
    .\Set-LocalFileSensitivityLabel.ps1 -FilePath "\\server\share\Documents" -LabelName "Internal" -FileFilter "*.docx" -Recurse

.NOTES
    Prerequisites:
    - PurviewInformationProtection module installed (Install-Module PurviewInformationProtection)
    - AIP Unified Labeling client may need to be installed separately
    - The account must have permissions to modify the target files

    Important:
    - This method works best for local files and network shares
    - For SharePoint/OneDrive files, use Set-SharePointSensitivityLabel.ps1 instead
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$FilePath,
    
    [Parameter(Mandatory = $false, ParameterSetName = "ByName")]
    [string]$LabelName,
    
    [Parameter(Mandatory = $false, ParameterSetName = "ById")]
    [string]$LabelId,
    
    [Parameter(Mandatory = $false)]
    [string]$FileFilter = "*",
    
    [Parameter(Mandatory = $false)]
    [switch]$Recurse,
    
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

# Error handling
$ErrorActionPreference = "Stop"

# Check if PurviewInformationProtection module is available
function Test-PurviewModule {
    if (-not (Get-Module -ListAvailable -Name PurviewInformationProtection)) {
        Write-Error "PurviewInformationProtection module is not installed. Install it with: Install-Module PurviewInformationProtection"
        throw "Module not found"
    }
    
    Import-Module PurviewInformationProtection -ErrorAction Stop
    Write-Host "PurviewInformationProtection module loaded" -ForegroundColor Green
}

# Function to get sensitivity label by name or ID
function Get-SensitivityLabel {
    param(
        [string]$Name,
        [string]$Id
    )
    
    Write-Host "Retrieving sensitivity label..." -ForegroundColor Cyan
    
    try {
        if ($Name) {
            $labels = Get-Label
            $label = $labels | Where-Object { $_.Name -eq $Name }
            
            if (-not $label) {
                Write-Error "Sensitivity label '$Name' not found. Available labels:"
                Get-Label | Select-Object Name, Guid | Format-Table
                throw "Label not found"
            }
        }
        elseif ($Id) {
            $label = Get-Label | Where-Object { $_.Guid -eq $Id }
            if (-not $label) {
                throw "Sensitivity label with ID '$Id' not found"
            }
        }
        
        Write-Host "Found label: $($label.Name) (GUID: $($label.Guid))" -ForegroundColor Green
        return $label
    }
    catch {
        Write-Error "Failed to retrieve sensitivity label: $_"
        throw
    }
}

# Function to get files to process
function Get-FilesToProcess {
    param(
        [string]$Path,
        [string]$Filter,
        [bool]$Recurse
    )
    
    Write-Host "Collecting files to process..." -ForegroundColor Cyan
    
    try {
        $item = Get-Item -Path $Path -ErrorAction Stop
        
        if ($item.PSIsContainer) {
            # It's a directory
            $params = @{
                Path = $Path
                Filter = $Filter
                File = $true
            }
            
            if ($Recurse) {
                $params['Recurse'] = $true
            }
            
            $files = Get-ChildItem @params
        }
        else {
            # It's a single file
            $files = @($item)
        }
        
        Write-Host "Found $($files.Count) file(s) to process" -ForegroundColor Green
        return $files
    }
    catch {
        Write-Error "Failed to access path '$Path': $_"
        throw
    }
}

# Main execution
try {
    # Check module availability
    Test-PurviewModule
    
    # Get the sensitivity label
    $label = Get-SensitivityLabel -Name $LabelName -Id $LabelId
    $labelGuid = $label.Guid
    
    # Get files to process
    $files = Get-FilesToProcess -Path $FilePath -Filter $FileFilter -Recurse $Recurse
    
    if ($files.Count -eq 0) {
        Write-Warning "No files found matching the criteria"
        exit 0
    }
    
    # Display summary
    Write-Host "`nSummary:" -ForegroundColor Cyan
    Write-Host "  Path: $FilePath" -ForegroundColor Gray
    Write-Host "  Label: $($label.Name)" -ForegroundColor Gray
    Write-Host "  Files to process: $($files.Count)" -ForegroundColor Gray
    Write-Host ""
    
    if ($WhatIf) {
        Write-Host "WHAT IF MODE - No changes will be made" -ForegroundColor Yellow
        Write-Host "Files that would be labeled:" -ForegroundColor Yellow
        $files | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Gray }
        exit 0
    }
    
    # Confirm before proceeding
    if (-not $PSCmdlet.ShouldProcess("$($files.Count) file(s)", "Apply sensitivity label '$($label.Name)'")) {
        Write-Host "Operation cancelled by user" -ForegroundColor Yellow
        exit 0
    }
    
    # Process files
    $successCount = 0
    $failureCount = 0
    $processedCount = 0
    
    foreach ($file in $files) {
        $processedCount++
        Write-Progress -Activity "Applying sensitivity labels" -Status "Processing: $($file.Name)" -PercentComplete (($processedCount / $files.Count) * 100)
        
        Write-Host "[$processedCount/$($files.Count)] Processing: $($file.FullName)" -ForegroundColor Cyan
        
        try {
            Set-FileLabel -Path $file.FullName -LabelId $labelGuid -ErrorAction Stop
            $successCount++
            Write-Host "  ✓ Label applied successfully" -ForegroundColor Green
        }
        catch {
            $failureCount++
            Write-Host "  ✗ Failed to apply label: $_" -ForegroundColor Red
        }
    }
    
    Write-Progress -Activity "Applying sensitivity labels" -Completed
    
    # Final summary
    Write-Host "`nOperation completed:" -ForegroundColor Cyan
    Write-Host "  Success: $successCount" -ForegroundColor Green
    Write-Host "  Failed: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Gray" })
    Write-Host "  Total: $($files.Count)" -ForegroundColor Gray
}
catch {
    Write-Error "Script execution failed: $_"
    exit 1
}

