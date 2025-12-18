<#
.SYNOPSIS
    Applies or updates Microsoft Purview sensitivity labels on documents in SharePoint Online or OneDrive.

.DESCRIPTION
    This script uses the Microsoft Graph PowerShell SDK to apply sensitivity labels to existing documents
    in SharePoint Document Libraries or OneDrive. It supports bulk operations and can filter files by
    various criteria.

.PARAMETER SiteUrl
    The URL of the SharePoint site (e.g., https://contoso.sharepoint.com/sites/MySite)

.PARAMETER LibraryName
    The name of the document library (e.g., "Documents", "Shared Documents")

.PARAMETER LabelName
    The display name of the sensitivity label to apply

.PARAMETER LabelId
    The GUID of the sensitivity label to apply (alternative to LabelName)

.PARAMETER FileFilter
    Optional filter for file names (supports wildcards, e.g., "*.docx")

.PARAMETER FolderPath
    Optional subfolder path within the library (e.g., "Projects/2024")

.PARAMETER WhatIf
    Shows what would be done without actually applying the labels

.EXAMPLE
    .\Set-SharePointSensitivityLabel.ps1 -SiteUrl "https://contoso.sharepoint.com/sites/MySite" -LibraryName "Documents" -LabelName "Confidential"

.EXAMPLE
    .\Set-SharePointSensitivityLabel.ps1 -SiteUrl "https://contoso.sharepoint.com/sites/MySite" -LibraryName "Documents" -LabelId "a1b2c3d4-e5f6-7890-abcd-ef1234567890" -FileFilter "*.docx"

.NOTES
    Prerequisites:
    - Microsoft.Graph PowerShell module installed (Install-Module Microsoft.Graph)
    - Appropriate permissions: Sites.ReadWrite.All or Files.ReadWrite.All
    - The account must have permissions to modify files in the target library

    Important:
    - This script overwrites existing labels without checking label priority rules
    - Consider implementing label priority validation if downgrades should be prevented
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$SiteUrl,
    
    [Parameter(Mandatory = $true)]
    [string]$LibraryName,
    
    [Parameter(Mandatory = $false, ParameterSetName = "ByName")]
    [string]$LabelName,
    
    [Parameter(Mandatory = $false, ParameterSetName = "ById")]
    [string]$LabelId,
    
    [Parameter(Mandatory = $false)]
    [string]$FileFilter = "*",
    
    [Parameter(Mandatory = $false)]
    [string]$FolderPath = "",
    
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

# Error handling
$ErrorActionPreference = "Stop"

# Function to connect to Microsoft Graph
function Connect-ToGraph {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
    
    try {
        # Check if already connected
        $context = Get-MgContext
        if ($context) {
            Write-Host "Already connected to Microsoft Graph as: $($context.Account)" -ForegroundColor Green
            return
        }
        
        # Connect with required scopes
        Connect-MgGraph -Scopes "Sites.ReadWrite.All", "InformationProtectionPolicy.Read.All" -NoWelcome
        Write-Host "Successfully connected to Microsoft Graph" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to connect to Microsoft Graph: $_"
        throw
    }
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
            $labels = Get-MgInformationProtectionLabel -All
            $label = $labels | Where-Object { $_.Name -eq $Name }
            
            if (-not $label) {
                Write-Error "Sensitivity label '$Name' not found. Available labels:"
                Get-MgInformationProtectionLabel -All | Select-Object Name, Id | Format-Table
                throw "Label not found"
            }
        }
        elseif ($Id) {
            $label = Get-MgInformationProtectionLabel -InformationProtectionLabelId $Id
            if (-not $label) {
                throw "Sensitivity label with ID '$Id' not found"
            }
        }
        
        Write-Host "Found label: $($label.Name) (ID: $($label.Id))" -ForegroundColor Green
        return $label
    }
    catch {
        Write-Error "Failed to retrieve sensitivity label: $_"
        throw
    }
}

# Function to get SharePoint site and drive
function Get-SharePointDrive {
    param(
        [string]$SiteUrl,
        [string]$LibraryName
    )
    
    Write-Host "Retrieving SharePoint site information..." -ForegroundColor Cyan
    
    try {
        # Get the site
        $site = Get-MgSite -SiteId $SiteUrl
        $siteId = $site.Id
        
        Write-Host "Site ID: $siteId" -ForegroundColor Gray
        
        # Get all drives (document libraries) for the site
        $drives = Get-MgSiteDrive -SiteId $siteId -All
        
        # Find the target library
        $drive = $drives | Where-Object { $_.Name -eq $LibraryName }
        
        if (-not $drive) {
            Write-Warning "Available libraries:"
            $drives | Select-Object Name, Id | Format-Table
            throw "Document library '$LibraryName' not found on site"
        }
        
        Write-Host "Found library: $($drive.Name) (ID: $($drive.Id))" -ForegroundColor Green
        return $drive
    }
    catch {
        Write-Error "Failed to retrieve SharePoint drive: $_"
        throw
    }
}

# Function to get files from a drive
function Get-DriveFiles {
    param(
        [object]$Drive,
        [string]$FileFilter,
        [string]$FolderPath
    )
    
    Write-Host "Retrieving files from library..." -ForegroundColor Cyan
    
    try {
        $driveId = $Drive.Id
        $items = @()
        
        # Build the path for the folder
        if ($FolderPath) {
            # Find the folder first
            $folderPathParts = $FolderPath.Trim('/').Split('/')
            $currentFolderId = "root"
            
            foreach ($part in $folderPathParts) {
                $children = Get-MgDriveItemChild -DriveId $driveId -DriveItemId $currentFolderId -All
                $folder = $children | Where-Object { $_.Name -eq $part -and $null -ne $_.Folder }
                
                if (-not $folder) {
                    throw "Folder '$part' not found in path '$FolderPath'"
                }
                
                $currentFolderId = $folder.Id
            }
            
            $items = Get-MgDriveItemChild -DriveId $driveId -DriveItemId $currentFolderId -All
        }
        else {
            # Get items from root
            $items = Get-MgDriveItemChild -DriveId $driveId -DriveItemId "root" -All
        }
        
        # Filter files (exclude folders) and apply file filter
        $files = $items | Where-Object { 
            $null -ne $_.File -and 
            $_.Name -like $FileFilter 
        }
        
        Write-Host "Found $($files.Count) file(s) matching criteria" -ForegroundColor Green
        return $files
    }
    catch {
        Write-Error "Failed to retrieve files: $_"
        throw
    }
}

# Function to apply sensitivity label to a file
function Set-FileSensitivityLabel {
    param(
        [object]$Drive,
        [object]$File,
        [string]$LabelId
    )
    
    try {
        $driveId = $Drive.Id
        $fileId = $File.Id
        
        # Prepare the request body
        $body = @{
            "sensitivityLabelId" = $LabelId
        }
        
        # Apply the label using Graph API
        Set-MgDriveItemSensitivityLabel -DriveId $driveId -DriveItemId $fileId -BodyParameter $body
        
        return $true
    }
    catch {
        Write-Warning "Failed to apply label to '$($File.Name)': $_"
        return $false
    }
}

# Main execution
try {
    # Connect to Graph
    Connect-ToGraph
    
    # Get the sensitivity label
    $label = Get-SensitivityLabel -Name $LabelName -Id $LabelId
    $labelId = $label.Id
    
    # Get the SharePoint drive
    $drive = Get-SharePointDrive -SiteUrl $SiteUrl -LibraryName $LibraryName
    
    # Get files
    $files = Get-DriveFiles -Drive $drive -FileFilter $FileFilter -FolderPath $FolderPath
    
    if ($files.Count -eq 0) {
        Write-Warning "No files found matching the criteria"
        exit 0
    }
    
    # Display summary
    Write-Host "`nSummary:" -ForegroundColor Cyan
    Write-Host "  Site: $SiteUrl" -ForegroundColor Gray
    Write-Host "  Library: $LibraryName" -ForegroundColor Gray
    Write-Host "  Label: $($label.Name)" -ForegroundColor Gray
    Write-Host "  Files to process: $($files.Count)" -ForegroundColor Gray
    Write-Host ""
    
    if ($WhatIf) {
        Write-Host "WHAT IF MODE - No changes will be made" -ForegroundColor Yellow
        Write-Host "Files that would be labeled:" -ForegroundColor Yellow
        $files | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }
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
        
        Write-Host "[$processedCount/$($files.Count)] Processing: $($file.Name)" -ForegroundColor Cyan
        
        if (Set-FileSensitivityLabel -Drive $drive -File $file -LabelId $labelId) {
            $successCount++
            Write-Host "  ✓ Label applied successfully" -ForegroundColor Green
        }
        else {
            $failureCount++
            Write-Host "  ✗ Failed to apply label" -ForegroundColor Red
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
finally {
    # Optionally disconnect (commented out to maintain session)
    # Disconnect-MgGraph
}

