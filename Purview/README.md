# Microsoft Purview Sensitivity Label Management Scripts

This folder contains PowerShell scripts for managing Microsoft Purview sensitivity labels on existing documents, supporting both SharePoint Online/OneDrive and local files/network shares.

## Scripts

### 1. Set-SharePointSensitivityLabel.ps1

Applies or updates sensitivity labels on documents stored in SharePoint Online or OneDrive using the Microsoft Graph PowerShell SDK.

**Use Cases:**
- Bulk labeling of existing documents in SharePoint Document Libraries
- Updating labels on files in OneDrive
- Applying labels to files in specific folders

**Prerequisites:**
```powershell
Install-Module Microsoft.Graph
```

**Required Permissions:**
- `Sites.ReadWrite.All` or `Files.ReadWrite.All`
- `InformationProtectionPolicy.Read.All`

**Example Usage:**
```powershell
# Apply label by name to all files in a library
.\Set-SharePointSensitivityLabel.ps1 `
    -SiteUrl "https://contoso.sharepoint.com/sites/MySite" `
    -LibraryName "Documents" `
    -LabelName "Confidential"

# Apply label by ID to specific file types in a subfolder
.\Set-SharePointSensitivityLabel.ps1 `
    -SiteUrl "https://contoso.sharepoint.com/sites/MySite" `
    -LibraryName "Documents" `
    -LabelId "a1b2c3d4-e5f6-7890-abcd-ef1234567890" `
    -FileFilter "*.docx" `
    -FolderPath "Projects/2024"

# Preview changes without applying (WhatIf)
.\Set-SharePointSensitivityLabel.ps1 `
    -SiteUrl "https://contoso.sharepoint.com/sites/MySite" `
    -LibraryName "Documents" `
    -LabelName "Internal" `
    -WhatIf
```

### 2. Set-LocalFileSensitivityLabel.ps1

Applies or updates sensitivity labels on local files or network shares using the PurviewInformationProtection module (AIP Unified Labeling Client).

**Use Cases:**
- Labeling files before uploading to SharePoint
- Bulk operations on network file shares
- Local file labeling operations

**Prerequisites:**
```powershell
Install-Module PurviewInformationProtection
```

**Note:** The AIP Unified Labeling client may need to be installed separately depending on your environment.

**Example Usage:**
```powershell
# Apply label to a single file
.\Set-LocalFileSensitivityLabel.ps1 `
    -FilePath "C:\Data\Document.docx" `
    -LabelName "Confidential"

# Apply label to all Word documents in a directory (recursive)
.\Set-LocalFileSensitivityLabel.ps1 `
    -FilePath "\\server\share\Documents" `
    -LabelName "Internal" `
    -FileFilter "*.docx" `
    -Recurse

# Preview changes without applying (WhatIf)
.\Set-LocalFileSensitivityLabel.ps1 `
    -FilePath "C:\Data" `
    -LabelName "Public" `
    -WhatIf
```

## Important Considerations

### Label Priority Rules
⚠️ **Warning:** These scripts overwrite existing labels without checking label priority rules. They do not prevent downgrades (applying a less sensitive label over a more sensitive one). If you need to enforce label priority rules, you'll need to add custom validation logic to the scripts.

### Auto-Labeling Policies
Auto-labeling policies in Microsoft Purview are designed for:
- Newly created or edited files
- Specific content sweeps (when configured)
- Files matching sensitive information types or keywords

They do **not** automatically apply to all existing unlabeled files unless those files are modified. For bulk operations on existing files, use these scripts.

### Authentication
- **Graph SDK Script:** Uses `Connect-MgGraph` which supports interactive authentication, device code flow, or certificate-based authentication
- **Local File Script:** Uses the PurviewInformationProtection module which typically uses the signed-in user's credentials

## Getting Label IDs

To find the GUID/ID of a sensitivity label:

**For Graph SDK:**
```powershell
Connect-MgGraph -Scopes "InformationProtectionPolicy.Read.All"
Get-MgInformationProtectionLabel -All | Select-Object Name, Id
```

**For PurviewInformationProtection:**
```powershell
Import-Module PurviewInformationProtection
Get-Label | Select-Object Name, Guid
```

## Troubleshooting

### "Label not found" errors
- Verify the label name is spelled correctly (case-sensitive)
- Ensure you have permissions to read sensitivity labels
- Check that the label is published and available in your tenant

### "Access denied" errors
- Verify you have the required Graph API permissions
- Check that your account has permissions to modify files in the target location
- For SharePoint, ensure you have at least "Edit" permissions on the library

### "Module not found" errors
- Install required modules: `Install-Module Microsoft.Graph` or `Install-Module PurviewInformationProtection`
- Ensure you're running PowerShell 5.1 or later
- Check execution policy: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

## Best Practices

1. **Test First:** Always use `-WhatIf` to preview changes before applying labels
2. **Backup:** Consider backing up files or using versioning before bulk operations
3. **Logging:** Review the script output for any failures
4. **Incremental Processing:** For large datasets, consider processing in batches
5. **Label Validation:** Implement custom logic to prevent unwanted label downgrades if needed

## Related Documentation

- [Microsoft Graph API - Sensitivity Labels](https://learn.microsoft.com/en-us/graph/api/resources/security-sensitivitylabel)
- [Microsoft Purview Information Protection](https://learn.microsoft.com/en-us/microsoft-365/compliance/information-protection)
- [AIP Unified Labeling Client](https://learn.microsoft.com/en-us/azure/information-protection/rms-client/unifiedlabelingclient-version-release-history)

