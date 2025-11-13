# Azure Dependency Mapping Script
# Maps comprehensive dependencies between VMs, App Services, Functions, Databases, Storage, Logic Apps, API Connections, and APIs
# Captures: Disks, NICs, Private Endpoints, Subnets, VNets, NSGs, KeyVaults, Load Balancers, SQL Servers, Service Bus, Event Hub, Cosmos DB
# Includes: VM Extensions, Backup Vaults, TDE Keys, Failover Groups, Managed Identities, Front Door, Traffic Manager, Hybrid Connections
# Supports filtering by resource group and multiple output formats (JSON/CSV/both)

param(
    [string]$SubscriptionId,
    [string]$ResourceGroupFilter = $null,
    [string]$OutputPath = "./Dependency Mapping/dependency-report",
    [ValidateSet("json", "csv", "both")]
    [string]$OutputFormat = "both"
)

# Install required modules
$requiredModules = @(
    "Az.Resources", 
    "Az.Compute", 
    "Az.Network", 
    "Az.Sql", 
    "Az.KeyVault", 
    "Az.Storage", 
    "Az.Websites", 
    "Az.ApplicationInsights",
    "Az.ServiceBus",
    "Az.CosmosDB",
    "Az.EventHub",
    "Az.FrontDoor",
    "Az.TrafficManager",
    "Az.RecoveryServices"
)
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing $module..."
        Install-Module -Name $module -Force -AllowClobber
    }
    Import-Module -Name $module -Force -WarningAction SilentlyContinue | Out-Null
}

# Authenticate to Azure
Connect-AzAccount -SubscriptionId $SubscriptionId

$resources = @()
$dependencyList = @()

# Define resource types
$resourceTypes = @(
    "Microsoft.Compute/virtualMachines",
    "Microsoft.Web/sites",
    "Microsoft.Sql/servers",
    "Microsoft.Sql/servers/databases",
    "Microsoft.Sql/servers/elasticPools",
    "Microsoft.Sql/managedInstances",
    "Microsoft.Sql/managedInstances/databases",
    "Microsoft.DBforMySQL/servers",
    "Microsoft.DBforMySQL/flexibleServers",
    "Microsoft.DBforPostgreSQL/servers",
    "Microsoft.DBforPostgreSQL/flexibleServers",
    "Microsoft.Cache/redis",
    "Microsoft.ContainerInstance/containerGroups",
    "Microsoft.ContainerRegistry/registries",
    "Microsoft.Kusto/clusters",
    "Microsoft.DataFactory/factories",
    "Microsoft.Synapse/workspaces",
    "Microsoft.Synapse/workspaces/sqlPools",
    "Microsoft.Storage/storageAccounts",
    "Microsoft.Logic/workflows",
    "Microsoft.ApiManagement/service",
    "Microsoft.KeyVault/vaults",
    "Microsoft.ServiceBus/namespaces",
    "Microsoft.DocumentDB/databaseAccounts",
    "Microsoft.EventHub/namespaces",
    "Microsoft.Web/connections"
)

Write-Host "Discovering resources..."

# Get resources with optional resource group filter
$query = { Get-AzResource -WarningAction SilentlyContinue | Where-Object { $_.Type -in $resourceTypes } }
$allResources = if ($ResourceGroupFilter) {
    & $query | Where-Object { $_.ResourceGroupName -like $ResourceGroupFilter }
} else {
    & $query
}

Write-Host "Found $($allResources.Count) resources. Analyzing dependencies..."

foreach ($resource in $allResources) {
    $resourceDetail = @{
        ResourceName = $resource.Name
        ResourceType = $resource.Type
        ResourceGroup = $resource.ResourceGroupName
        Location = $resource.Location
        ResourceId = $resource.Id
    }
    
    $resourceDeps = @()
    
    # Get resource configuration
    try {
        $config = Get-AzResource -ResourceId $resource.Id -ExpandProperties -ErrorAction SilentlyContinue
        
        # Extract dependencies based on resource type
        switch ($resource.Type) {
            "Microsoft.Web/sites" {
                $webApp = Get-AzWebApp -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                
                if ($webApp) {
                    # Connection strings
                    if ($webApp.SiteConfig.ConnectionStrings) {
                        foreach ($connStr in $webApp.SiteConfig.ConnectionStrings) {
                            $resourceDeps += @{
                                DependencyName = $connStr.Name
                                DependencyType = "Connection String"
                                DependencyTarget = "Database/Storage"
                            }
                        }
                    }
                    
                    # App settings that reference storage or resources
                    if ($webApp.SiteConfig.AppSettings) {
                        # Check for specific service connections
                        $appSettings = $webApp.SiteConfig.AppSettings
                        
                        # Generic resource references
                        $resourceDeps += $appSettings | Where-Object { $_.Name -match "storage|database|connection|keyvault|vault|redis|cosmos|insights|servicebus|eventhub" } | ForEach-Object {
                            @{
                                DependencyName = $_.Name
                                DependencyType = "App Setting"
                                DependencyTarget = "Configuration Reference"
                            }
                        }
                        
                        # Service Bus connections
                        $serviceBusSettings = $appSettings | Where-Object { $_.Value -match "servicebus\.windows\.net" }
                        foreach ($sbSetting in $serviceBusSettings) {
                            if ($sbSetting.Value -match "([a-zA-Z0-9\-]+)\.servicebus\.windows\.net") {
                                $resourceDeps += @{
                                    DependencyName = $matches[1]
                                    DependencyType = "Service Bus Connection"
                                    DependencyTarget = $sbSetting.Name
                                }
                            }
                        }
                        
                        # Cosmos DB connections
                        $cosmosSettings = $appSettings | Where-Object { $_.Value -match "cosmos\.azure\.com|documents\.azure\.com" }
                        foreach ($cosmosSetting in $cosmosSettings) {
                            if ($cosmosSetting.Value -match "([a-zA-Z0-9\-]+)\.documents\.azure\.com") {
                                $resourceDeps += @{
                                    DependencyName = $matches[1]
                                    DependencyType = "Cosmos DB Connection"
                                    DependencyTarget = $cosmosSetting.Name
                                }
                            }
                        }
                        
                        # Event Hub connections
                        $eventHubSettings = $appSettings | Where-Object { $_.Value -match "eventhub\.windows\.net" }
                        foreach ($ehSetting in $eventHubSettings) {
                            if ($ehSetting.Value -match "([a-zA-Z0-9\-]+)\.eventhub\.windows\.net") {
                                $resourceDeps += @{
                                    DependencyName = $matches[1]
                                    DependencyType = "Event Hub Connection"
                                    DependencyTarget = $ehSetting.Name
                                }
                            }
                        }
                    }
                    
                    # Service Plan (Hosting Plan)
                    if ($webApp.AppServicePlanId) {
                        $appServicePlanName = ($webApp.AppServicePlanId -split '/')[-1]
                        $resourceDeps += @{
                            DependencyName = $appServicePlanName
                            DependencyType = "App Service Plan"
                            DependencyTarget = $webApp.AppServicePlanId
                        }
                    }
                    
                    # Virtual Network integration
                    if ($webApp.VirtualNetworkProfile) {
                        $vnetId = $webApp.VirtualNetworkProfile.Id
                        $vnetName = ($vnetId -split '/')[-1]
                        $resourceDeps += @{
                            DependencyName = $vnetName
                            DependencyType = "Virtual Network Integration"
                            DependencyTarget = $vnetId
                        }
                    }
                    
                    # SSL Certificates
                    try {
                        $certs = Get-AzWebAppCertificate -ResourceGroupName $resource.ResourceGroupName -WarningAction SilentlyContinue
                        foreach ($cert in $certs) {
                            $resourceDeps += @{
                                DependencyName = $cert.Name
                                DependencyType = "SSL Certificate"
                                DependencyTarget = $cert.Id
                            }
                        }
                    } catch { }
                    
                    # Custom Domains
                    if ($webApp.HostNames) {
                        foreach ($hostname in $webApp.HostNames) {
                            if ($hostname -notlike "*.azurewebsites.net") {
                                $resourceDeps += @{
                                    DependencyName = $hostname
                                    DependencyType = "Custom Domain"
                                    DependencyTarget = $hostname
                                }
                            }
                        }
                    }
                    
                    # Deployment Slots
                    try {
                        $slots = Get-AzWebAppSlot -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                        foreach ($slot in $slots) {
                            $resourceDeps += @{
                                DependencyName = $slot.Name
                                DependencyType = "Deployment Slot"
                                DependencyTarget = $slot.Id
                            }
                        }
                    } catch { }
                    
                    # Application Insights
                    try {
                        $appInsights = $webApp.SiteConfig.AppSettings | Where-Object { $_.Name -eq "APPINSIGHTS_INSTRUMENTATIONKEY" -or $_.Name -eq "ApplicationInsightsAgent_EXTENSION_VERSION" }
                        if ($appInsights) {
                            $resourceDeps += @{
                                DependencyName = "Application Insights"
                                DependencyType = "Monitoring"
                                DependencyTarget = "Application Insights Instance"
                            }
                        }
                    } catch { }
                    
                    # Backup configuration
                    try {
                        $backupConfig = Get-AzWebAppBackupConfiguration -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                        if ($backupConfig) {
                            $resourceDeps += @{
                                DependencyName = "Backup Vault"
                                DependencyType = "Backup Configuration"
                                DependencyTarget = $backupConfig.StorageAccountUrl
                            }
                        }
                    } catch { }
                    
                    # Managed Identity references
                    if ($webApp.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $webApp.Identity.PrincipalId
                        }
                    }
                    
                    # Check for Application Gateway backend pools
                    try {
                        $allAppGateways = Get-AzApplicationGateway -WarningAction SilentlyContinue
                        foreach ($appGw in $allAppGateways) {
                            foreach ($backendPool in $appGw.BackendAddressPools) {
                                if ($backendPool.BackendHttpSettingsCollection.TargetId -match $resource.Name) {
                                    $resourceDeps += @{
                                        DependencyName = $appGw.Name
                                        DependencyType = "Application Gateway"
                                        DependencyTarget = $appGw.Id
                                    }
                                    break
                                }
                            }
                        }
                    } catch { }
                    
                    # Check for Load Balancer associations
                    try {
                        $allLoadBalancers = Get-AzLoadBalancer -WarningAction SilentlyContinue
                        foreach ($lb in $allLoadBalancers) {
                            foreach ($backendPool in $lb.BackendAddressPools) {
                                # Check if this web app is referenced in backend pool
                                if ($backendPool.Id -match $resource.Name) {
                                    $resourceDeps += @{
                                        DependencyName = $lb.Name
                                        DependencyType = "Load Balancer"
                                        DependencyTarget = $lb.Id
                                    }
                                    break
                                }
                            }
                        }
                    } catch { }
                    
                    # Hybrid Connections
                    try {
                        $hybridConnections = Get-AzWebAppHybridConnection -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                        foreach ($hc in $hybridConnections) {
                            $resourceDeps += @{
                                DependencyName = $hc.Name
                                DependencyType = "Hybrid Connection"
                                DependencyTarget = $hc.RelayArmUri
                            }
                        }
                    } catch { }
                    
                    # Azure Front Door (check if app is a backend)
                    try {
                        $frontDoors = Get-AzFrontDoor -ErrorAction SilentlyContinue
                        foreach ($fd in $frontDoors) {
                            foreach ($backend in $fd.BackendPools.Backends) {
                                if ($backend.Address -match $resource.Name -or $backend.Address -match $webApp.DefaultHostName) {
                                    $resourceDeps += @{
                                        DependencyName = $fd.Name
                                        DependencyType = "Azure Front Door"
                                        DependencyTarget = $fd.Id
                                    }
                                    break
                                }
                            }
                        }
                    } catch { }
                    
                    # Traffic Manager (check if app is an endpoint)
                    try {
                        $tmProfiles = Get-AzTrafficManagerProfile -ErrorAction SilentlyContinue
                        foreach ($tm in $tmProfiles) {
                            $endpoints = Get-AzTrafficManagerEndpoint -ProfileName $tm.Name -ResourceGroupName $tm.ResourceGroupName -ErrorAction SilentlyContinue
                            foreach ($endpoint in $endpoints) {
                                if ($endpoint.Target -match $resource.Name -or $endpoint.TargetResourceId -eq $resource.Id) {
                                    $resourceDeps += @{
                                        DependencyName = $tm.Name
                                        DependencyType = "Traffic Manager"
                                        DependencyTarget = $tm.Id
                                    }
                                    break
                                }
                            }
                        }
                    } catch { }
                }
            }
            
            "Microsoft.Logic/workflows" {
                if ($config.Properties.definition) {
                    $definition = $config.Properties.definition
                    
                    # API connections
                    if ($definition.actions) {
                        foreach ($action in $definition.actions.PSObject.Properties) {
                            if ($action.Value.inputs.host.connection) {
                                $resourceDeps += @{
                                    DependencyName = $action.Name
                                    DependencyType = "API Connection"
                                    DependencyTarget = $action.Value.inputs.host.connection.name
                                }
                            }
                        }
                    }
                    
                    # Keyvault references
                    if ($definition.parameters) {
                        foreach ($param in $definition.parameters.PSObject.Properties) {
                            if ($param.Value -match "keyvault|vault") {
                                $resourceDeps += @{
                                    DependencyName = $param.Name
                                    DependencyType = "Keyvault Reference"
                                    DependencyTarget = $param.Value
                                }
                            }
                        }
                    }
                }
            }
            
            "Microsoft.Compute/virtualMachines" {
                $vm = Get-AzVM -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                
                if ($vm) {
                    # Network interfaces and subnets
                    if ($vm.NetworkProfile.NetworkInterfaces) {
                        foreach ($nic in $vm.NetworkProfile.NetworkInterfaces) {
                            $nicId = $nic.Id
                            $nicName = ($nicId -split '/')[-1]
                            $resourceDeps += @{
                                DependencyName = $nicName
                                DependencyType = "Network Interface"
                                DependencyTarget = $nicId
                            }
                            
                            # Get subnet info from NIC
                            try {
                                $nicResource = Get-AzNetworkInterface -ResourceId $nicId -ErrorAction SilentlyContinue
                                if ($nicResource.IpConfigurations) {
                                    foreach ($ipConfig in $nicResource.IpConfigurations) {
                                        if ($ipConfig.Subnet) {
                                            $subnetId = $ipConfig.Subnet.Id
                                            $subnetName = ($subnetId -split '/')[-1]
                                            $vnetName = ($subnetId -split '/')[-3]
                                            $resourceDeps += @{
                                                DependencyName = "$vnetName/$subnetName"
                                                DependencyType = "Subnet"
                                                DependencyTarget = $subnetId
                                            }
                                            
                                            # Get NSG info if attached to subnet
                                            try {
                                                # Extract resource group from subnet ID properly
                                                $subnetParts = $subnetId -split '/'
                                                $subnetRgIdx = [System.Array]::IndexOf($subnetParts, 'resourceGroups') + 1
                                                $resourceGroupName = if ($subnetRgIdx -gt 0) { $subnetParts[$subnetRgIdx] } else { $resource.ResourceGroupName }
                                                
                                                $subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork (Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName) -ErrorAction SilentlyContinue
                                                if ($subnet.NetworkSecurityGroup) {
                                                    $nsgId = $subnet.NetworkSecurityGroup.Id
                                                    $nsgName = ($nsgId -split '/')[-1]
                                                    $resourceDeps += @{
                                                        DependencyName = $nsgName
                                                        DependencyType = "Network Security Group (Subnet)"
                                                        DependencyTarget = $nsgId
                                                    }
                                                }
                                            } catch { }
                                        }
                                    }
                                }
                                
                                # NSG on NIC level
                                if ($nicResource.NetworkSecurityGroup) {
                                    $nsgId = $nicResource.NetworkSecurityGroup.Id
                                    $nsgName = ($nsgId -split '/')[-1]
                                    $resourceDeps += @{
                                        DependencyName = $nsgName
                                        DependencyType = "Network Security Group (NIC)"
                                        DependencyTarget = $nsgId
                                    }
                                }
                            } catch { }
                        }
                    }
                    
                    # OS disk (Managed or unmanaged)
                    if ($vm.StorageProfile.OsDisk) {
                        if ($vm.StorageProfile.OsDisk.ManagedDisk) {
                            $diskId = $vm.StorageProfile.OsDisk.ManagedDisk.Id
                            $diskName = ($diskId -split '/')[-1]
                            $resourceDeps += @{
                                DependencyName = $diskName
                                DependencyType = "OS Disk (Managed)"
                                DependencyTarget = $diskId
                            }
                        } elseif ($vm.StorageProfile.OsDisk.Vhd) {
                            $resourceDeps += @{
                                DependencyName = "OS Disk"
                                DependencyType = "Storage Account (Unmanaged)"
                                DependencyTarget = $vm.StorageProfile.OsDisk.Vhd.Uri
                            }
                        }
                    }
                    
                    # Data disks (Managed)
                    if ($vm.StorageProfile.DataDisks) {
                        foreach ($dataDisk in $vm.StorageProfile.DataDisks) {
                            if ($dataDisk.ManagedDisk) {
                                $diskId = $dataDisk.ManagedDisk.Id
                                $diskName = ($diskId -split '/')[-1]
                                $resourceDeps += @{
                                    DependencyName = $diskName
                                    DependencyType = "Data Disk (Managed)"
                                    DependencyTarget = $diskId
                                }
                            }
                        }
                    }
                    
                    # Managed Identity
                    if ($vm.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $vm.Identity.PrincipalId
                        }
                    }
                    
                    # Proximity Placement Group
                    if ($vm.ProximityPlacementGroup) {
                        $ppgId = $vm.ProximityPlacementGroup.Id
                        $ppgName = ($ppgId -split '/')[-1]
                        $resourceDeps += @{
                            DependencyName = $ppgName
                            DependencyType = "Proximity Placement Group"
                            DependencyTarget = $ppgId
                        }
                    }
                    
                    # Availability Set
                    if ($vm.AvailabilitySetReference) {
                        $avSetId = $vm.AvailabilitySetReference.Id
                        $avSetName = ($avSetId -split '/')[-1]
                        $resourceDeps += @{
                            DependencyName = $avSetName
                            DependencyType = "Availability Set"
                            DependencyTarget = $avSetId
                        }
                    }
                    
                    # Boot Diagnostics Storage Account
                    if ($vm.DiagnosticsProfile.BootDiagnostics.Enabled -and $vm.DiagnosticsProfile.BootDiagnostics.StorageUri) {
                        $storageUri = $vm.DiagnosticsProfile.BootDiagnostics.StorageUri
                        $storageAccountName = ($storageUri -split '//')[1] -split '\.' | Select-Object -First 1
                        $resourceDeps += @{
                            DependencyName = $storageAccountName
                            DependencyType = "Boot Diagnostics Storage"
                            DependencyTarget = $storageUri
                        }
                    }
                    
                    # VM Extensions
                    try {
                        $extensions = Get-AzVMExtension -ResourceGroupName $resource.ResourceGroupName -VMName $resource.Name -ErrorAction SilentlyContinue
                        foreach ($ext in $extensions) {
                            $resourceDeps += @{
                                DependencyName = $ext.Name
                                DependencyType = "VM Extension"
                                DependencyTarget = $ext.Publisher + "/" + $ext.ExtensionType
                            }
                        }
                    } catch { }
                    
                    # Azure Backup (Recovery Services Vault)
                    try {
                        $backupItem = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM -WarningAction SilentlyContinue | Where-Object { $_.VirtualMachineId -eq $resource.Id }
                        if ($backupItem) {
                            $vaultId = $backupItem.ContainerName
                            $resourceDeps += @{
                                DependencyName = $backupItem.ContainerName
                                DependencyType = "Backup Vault"
                                DependencyTarget = "Recovery Services Vault"
                            }
                        }
                    } catch { }
                }
            }
            
            "Microsoft.Storage/storageAccounts" {
                $storageAccount = Get-AzStorageAccount -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                
                if ($storageAccount) {
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Storage Account"
                        DependencyTarget = "Data Repository"
                    }
                    
                    # Customer-Managed Encryption Keys (KeyVault)
                    if ($storageAccount.Encryption.KeyVaultProperties) {
                        $keyVaultUri = $storageAccount.Encryption.KeyVaultProperties.KeyVaultUri
                        $keyName = $storageAccount.Encryption.KeyVaultProperties.KeyName
                        $resourceDeps += @{
                            DependencyName = $keyName
                            DependencyType = "Customer-Managed Key (KeyVault)"
                            DependencyTarget = $keyVaultUri
                        }
                    }
                    
                    # File Shares
                    try {
                        $ctx = $storageAccount.Context
                        $shares = Get-AzStorageShare -Context $ctx -ErrorAction SilentlyContinue
                        foreach ($share in $shares) {
                            $resourceDeps += @{
                                DependencyName = $share.Name
                                DependencyType = "File Share"
                                DependencyTarget = $share.Uri
                            }
                        }
                    } catch { }
                    
                    # Blob Containers
                    try {
                        $ctx = $storageAccount.Context
                        $containers = Get-AzStorageContainer -Context $ctx -ErrorAction SilentlyContinue
                        foreach ($container in $containers) {
                            $resourceDeps += @{
                                DependencyName = $container.Name
                                DependencyType = "Blob Container"
                                DependencyTarget = $container.CloudBlobContainer.Uri
                            }
                        }
                    } catch { }
                    
                    # Static Website Hosting
                    try {
                        $staticWebsite = Get-AzStorageServiceProperty -ServiceType Blob -Context $storageAccount.Context -ErrorAction SilentlyContinue
                        if ($staticWebsite.StaticWebsite.Enabled) {
                            $resourceDeps += @{
                                DependencyName = "Static Website"
                                DependencyType = "Static Website Hosting"
                                DependencyTarget = "IndexDocument: " + $staticWebsite.StaticWebsite.IndexDocument
                            }
                        }
                    } catch { }
                    
                    # Managed Identity
                    if ($storageAccount.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $storageAccount.Identity.PrincipalId
                        }
                    }
                }
            }
            
            "Microsoft.Sql/servers/databases" {
                $resourceDeps += @{
                    DependencyName = $resource.Name
                    DependencyType = "SQL Database"
                    DependencyTarget = "Data Repository"
                }
                
                # Extract SQL Server from resource ID
                $parts = $resource.Id -split '/'
                $serverIdx = [System.Array]::IndexOf($parts, 'servers') + 1
                if ($serverIdx -gt 0 -and $serverIdx -lt $parts.Count) {
                    $serverName = $parts[$serverIdx]
                    $serverResourceId = ($parts[0..$serverIdx] -join '/')
                    $resourceDeps += @{
                        DependencyName = $serverName
                        DependencyType = "SQL Server (Parent)"
                        DependencyTarget = $serverResourceId
                    }
                }
            }
            
            "Microsoft.Sql/servers" {
                try {
                    $sqlServer = Get-AzSqlServer -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.Name -ErrorAction SilentlyContinue
                    
                    # Managed Identity
                    if ($sqlServer.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $sqlServer.Identity.PrincipalId
                        }
                    }
                    
                    # Virtual Network Rules
                    $vnetRules = Get-AzSqlServerVirtualNetworkRule -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.Name -ErrorAction SilentlyContinue
                    foreach ($rule in $vnetRules) {
                        $subnetId = $rule.VirtualNetworkSubnetId
                        $subnetName = ($subnetId -split '/')[-1]
                        $vnetName = ($subnetId -split '/')[-3]
                        $resourceDeps += @{
                            DependencyName = "$vnetName/$subnetName"
                            DependencyType = "Virtual Network Rule"
                            DependencyTarget = $subnetId
                        }
                    }
                    
                    # Firewall Rules (track if public access is configured)
                    $firewallRules = Get-AzSqlServerFirewallRule -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.Name -ErrorAction SilentlyContinue
                    if ($firewallRules) {
                        $resourceDeps += @{
                            DependencyName = "Firewall Rules Configured"
                            DependencyType = "Network Security"
                            DependencyTarget = "$($firewallRules.Count) rule(s)"
                        }
                    }
                    
                    # Transparent Data Encryption (TDE) with KeyVault
                    try {
                        $encryptionProtector = Get-AzSqlServerTransparentDataEncryptionProtector -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.Name -ErrorAction SilentlyContinue
                        if ($encryptionProtector.Type -eq "AzureKeyVault") {
                            $keyVaultKeyId = $encryptionProtector.ServerKeyVaultKeyName
                            $resourceDeps += @{
                                DependencyName = $keyVaultKeyId
                                DependencyType = "TDE KeyVault Key"
                                DependencyTarget = $encryptionProtector.Uri
                            }
                        }
                    } catch { }
                    
                    # Auditing (storage account)
                    try {
                        $auditPolicy = Get-AzSqlServerAudit -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.Name -ErrorAction SilentlyContinue
                        if ($auditPolicy.StorageAccountResourceId) {
                            $storageAccountName = ($auditPolicy.StorageAccountResourceId -split '/')[-1]
                            $resourceDeps += @{
                                DependencyName = $storageAccountName
                                DependencyType = "Auditing Storage Account"
                                DependencyTarget = $auditPolicy.StorageAccountResourceId
                            }
                        }
                    } catch { }
                    
                    # Failover Groups
                    try {
                        $failoverGroups = Get-AzSqlDatabaseFailoverGroup -ResourceGroupName $resource.ResourceGroupName -ServerName $resource.Name -ErrorAction SilentlyContinue
                        foreach ($fg in $failoverGroups) {
                            $resourceDeps += @{
                                DependencyName = $fg.FailoverGroupName
                                DependencyType = "Failover Group"
                                DependencyTarget = $fg.PartnerServers -join ", "
                            }
                        }
                    } catch { }
                } catch { }
            }
            
            "Microsoft.Sql/managedInstances" {
                $resourceDeps += @{
                    DependencyName = $resource.Name
                    DependencyType = "SQL Managed Instance"
                    DependencyTarget = "Managed Database Platform"
                }
            }
            
            "Microsoft.Sql/managedInstances/databases" {
                $resourceDeps += @{
                    DependencyName = $resource.Name
                    DependencyType = "SQL MI Database"
                    DependencyTarget = "Data Repository"
                }
                
                # Extract parent managed instance
                $parts = $resource.Id -split '/'
                $miIdx = [System.Array]::IndexOf($parts, 'managedInstances') + 1
                if ($miIdx -gt 0 -and $miIdx -lt $parts.Count) {
                    $miName = $parts[$miIdx]
                    $resourceDeps += @{
                        DependencyName = $miName
                        DependencyType = "SQL Managed Instance (Parent)"
                        DependencyTarget = ($parts[0..$miIdx] -join '/')
                    }
                }
            }
            
            { $_ -in @("Microsoft.DBforMySQL/servers", "Microsoft.DBforMySQL/flexibleServers") } {
                try {
                    $dbType = if ($resource.Type -like "*flexible*") { "MySQL Flexible Server" } else { "MySQL Server" }
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = $dbType
                        DependencyTarget = "Data Repository"
                    }
                    
                    # Virtual Network Rules (for flexible servers)
                    if ($resource.Type -like "*flexible*") {
                        $mysqlServer = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                        if ($mysqlServer.Properties.network.delegatedSubnetResourceId) {
                            $subnetId = $mysqlServer.Properties.network.delegatedSubnetResourceId
                            $subnetName = ($subnetId -split '/')[-1]
                            $vnetName = ($subnetId -split '/')[-3]
                            $resourceDeps += @{
                                DependencyName = "$vnetName/$subnetName"
                                DependencyType = "Delegated Subnet"
                                DependencyTarget = $subnetId
                            }
                        }
                    }
                } catch { }
            }
            
            { $_ -in @("Microsoft.DBforPostgreSQL/servers", "Microsoft.DBforPostgreSQL/flexibleServers") } {
                try {
                    $dbType = if ($resource.Type -like "*flexible*") { "PostgreSQL Flexible Server" } else { "PostgreSQL Server" }
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = $dbType
                        DependencyTarget = "Data Repository"
                    }
                    
                    # Virtual Network Rules (for flexible servers)
                    if ($resource.Type -like "*flexible*") {
                        $pgServer = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                        if ($pgServer.Properties.network.delegatedSubnetResourceId) {
                            $subnetId = $pgServer.Properties.network.delegatedSubnetResourceId
                            $subnetName = ($subnetId -split '/')[-1]
                            $vnetName = ($subnetId -split '/')[-3]
                            $resourceDeps += @{
                                DependencyName = "$vnetName/$subnetName"
                                DependencyType = "Delegated Subnet"
                                DependencyTarget = $subnetId
                            }
                        }
                    }
                } catch { }
            }
            
            "Microsoft.Sql/servers/elasticPools" {
                $resourceDeps += @{
                    DependencyName = $resource.Name
                    DependencyType = "SQL Elastic Pool"
                    DependencyTarget = "Database Scaling Resource"
                }
                
                # Extract parent SQL Server
                $parts = $resource.Id -split '/'
                $serverIdx = [System.Array]::IndexOf($parts, 'servers') + 1
                if ($serverIdx -gt 0 -and $serverIdx -lt $parts.Count) {
                    $serverName = $parts[$serverIdx]
                    $resourceDeps += @{
                        DependencyName = $serverName
                        DependencyType = "SQL Server (Parent)"
                        DependencyTarget = ($parts[0..$serverIdx] -join '/')
                    }
                }
            }
            
            "Microsoft.Cache/redis" {
                try {
                    $redisCache = Get-AzRedisCache -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Redis Cache"
                        DependencyTarget = "Caching Service"
                    }
                    
                    # Subnet (if VNet injected)
                    if ($redisCache.SubnetId) {
                        $subnetId = $redisCache.SubnetId
                        $subnetName = ($subnetId -split '/')[-1]
                        $vnetName = ($subnetId -split '/')[-3]
                        $resourceDeps += @{
                            DependencyName = "$vnetName/$subnetName"
                            DependencyType = "VNet Integration"
                            DependencyTarget = $subnetId
                        }
                    }
                    
                    # Managed Identity
                    if ($redisCache.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $redisCache.Identity.PrincipalId
                        }
                    }
                } catch { }
            }
            
            "Microsoft.ContainerInstance/containerGroups" {
                try {
                    $containerGroup = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Container Instance"
                        DependencyTarget = "Container Runtime"
                    }
                    
                    # Image registry
                    if ($containerGroup.Properties.imageRegistryCredentials) {
                        foreach ($registry in $containerGroup.Properties.imageRegistryCredentials) {
                            $resourceDeps += @{
                                DependencyName = $registry.server
                                DependencyType = "Container Registry"
                                DependencyTarget = $registry.server
                            }
                        }
                    }
                    
                    # Subnet (if VNet integrated)
                    if ($containerGroup.Properties.subnetIds) {
                        foreach ($subnetId in $containerGroup.Properties.subnetIds) {
                            $subnetName = ($subnetId.id -split '/')[-1]
                            $vnetName = ($subnetId.id -split '/')[-3]
                            $resourceDeps += @{
                                DependencyName = "$vnetName/$subnetName"
                                DependencyType = "VNet Integration"
                                DependencyTarget = $subnetId.id
                            }
                        }
                    }
                    
                    # Volumes (file shares, secrets, etc.)
                    if ($containerGroup.Properties.volumes) {
                        foreach ($volume in $containerGroup.Properties.volumes) {
                            if ($volume.azureFile) {
                                $resourceDeps += @{
                                    DependencyName = $volume.azureFile.shareName
                                    DependencyType = "Azure File Share"
                                    DependencyTarget = $volume.azureFile.storageAccountName
                                }
                            }
                        }
                    }
                } catch { }
            }
            
            "Microsoft.ContainerRegistry/registries" {
                try {
                    $acr = Get-AzContainerRegistry -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Container Registry"
                        DependencyTarget = "Container Image Repository"
                    }
                    
                    # Managed Identity
                    if ($acr.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $acr.Identity.PrincipalId
                        }
                    }
                    
                    # Network Rules / VNet
                    if ($acr.NetworkRuleSet) {
                        $resourceDeps += @{
                            DependencyName = "Network Rules Configured"
                            DependencyType = "Network Security"
                            DependencyTarget = "ACR Network Rules"
                        }
                    }
                } catch { }
            }
            
            "Microsoft.Kusto/clusters" {
                try {
                    $adxCluster = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Data Explorer Cluster"
                        DependencyTarget = "Analytics Platform"
                    }
                    
                    # Virtual Network Configuration
                    if ($adxCluster.Properties.virtualNetworkConfiguration) {
                        $subnetId = $adxCluster.Properties.virtualNetworkConfiguration.subnetId
                        $subnetName = ($subnetId -split '/')[-1]
                        $vnetName = ($subnetId -split '/')[-3]
                        $resourceDeps += @{
                            DependencyName = "$vnetName/$subnetName"
                            DependencyType = "VNet Integration"
                            DependencyTarget = $subnetId
                        }
                    }
                    
                    # Managed Identity
                    if ($adxCluster.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $adxCluster.Identity.PrincipalId
                        }
                    }
                } catch { }
            }
            
            "Microsoft.DataFactory/factories" {
                try {
                    $adf = Get-AzDataFactoryV2 -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Data Factory"
                        DependencyTarget = "Data Integration Service"
                    }
                    
                    # Managed Identity
                    if ($adf.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $adf.Identity.PrincipalId
                        }
                    }
                    
                    # Linked Services (connections to data sources)
                    try {
                        $linkedServices = Get-AzDataFactoryV2LinkedService -ResourceGroupName $resource.ResourceGroupName -DataFactoryName $resource.Name -ErrorAction SilentlyContinue
                        foreach ($ls in $linkedServices) {
                            $resourceDeps += @{
                                DependencyName = $ls.Name
                                DependencyType = "Linked Service"
                                DependencyTarget = $ls.Properties.Type
                            }
                        }
                    } catch { }
                    
                    # Integration Runtimes
                    try {
                        $integrationRuntimes = Get-AzDataFactoryV2IntegrationRuntime -ResourceGroupName $resource.ResourceGroupName -DataFactoryName $resource.Name -ErrorAction SilentlyContinue
                        foreach ($ir in $integrationRuntimes) {
                            $resourceDeps += @{
                                DependencyName = $ir.Name
                                DependencyType = "Integration Runtime"
                                DependencyTarget = $ir.Type
                            }
                        }
                    } catch { }
                    
                    # VNet Integration (for managed VNet)
                    if ($adf.ManagedVirtualNetwork) {
                        $resourceDeps += @{
                            DependencyName = "Managed Virtual Network"
                            DependencyType = "VNet Integration"
                            DependencyTarget = "Data Factory Managed VNet"
                        }
                    }
                } catch { }
            }
            
            "Microsoft.Synapse/workspaces" {
                try {
                    $synapse = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Synapse Workspace"
                        DependencyTarget = "Analytics Platform"
                    }
                    
                    # Default Storage Account (ADLS Gen2)
                    if ($synapse.Properties.defaultDataLakeStorage) {
                        $storageAccount = $synapse.Properties.defaultDataLakeStorage.accountUrl
                        $resourceDeps += @{
                            DependencyName = $storageAccount
                            DependencyType = "Default Data Lake Storage"
                            DependencyTarget = $storageAccount
                        }
                    }
                    
                    # Managed Identity
                    if ($synapse.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $synapse.Identity.PrincipalId
                        }
                    }
                    
                    # Managed Virtual Network
                    if ($synapse.Properties.managedVirtualNetwork) {
                        $resourceDeps += @{
                            DependencyName = "Managed Virtual Network"
                            DependencyType = "VNet Integration"
                            DependencyTarget = "Synapse Managed VNet"
                        }
                    }
                } catch { }
            }
            
            "Microsoft.Synapse/workspaces/sqlPools" {
                try {
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Dedicated SQL Pool"
                        DependencyTarget = "Data Warehouse"
                    }
                    
                    # Extract parent Synapse workspace
                    $parts = $resource.Id -split '/'
                    $workspaceIdx = [System.Array]::IndexOf($parts, 'workspaces') + 1
                    if ($workspaceIdx -gt 0 -and $workspaceIdx -lt $parts.Count) {
                        $workspaceName = $parts[$workspaceIdx]
                        $resourceDeps += @{
                            DependencyName = $workspaceName
                            DependencyType = "Synapse Workspace (Parent)"
                            DependencyTarget = ($parts[0..$workspaceIdx] -join '/')
                        }
                    }
                } catch { }
            }
            
            "Microsoft.ApiManagement/service" {
                $resourceDeps += @{
                    DependencyName = $resource.Name
                    DependencyType = "API Management"
                    DependencyTarget = "API Gateway"
                }
                
                # Managed Identity
                try {
                    $apim = Get-AzApiManagement -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                    if ($apim.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $apim.Identity.PrincipalId
                        }
                    }
                } catch { }
            }
            
            "Microsoft.KeyVault/vaults" {
                try {
                    $keyVault = Get-AzKeyVault -ResourceGroupName $resource.ResourceGroupName -VaultName $resource.Name -ErrorAction SilentlyContinue
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Key Vault"
                        DependencyTarget = "Secret/Key/Certificate Store"
                    }
                    
                    # Network Rules / VNet Integration
                    if ($keyVault.NetworkAcls) {
                        foreach ($vnetRule in $keyVault.NetworkAcls.VirtualNetworkResourceIds) {
                            $subnetId = $vnetRule
                            $subnetName = ($subnetId -split '/')[-1]
                            $vnetName = ($subnetId -split '/')[-3]
                            $resourceDeps += @{
                                DependencyName = "$vnetName/$subnetName"
                                DependencyType = "Virtual Network Rule"
                                DependencyTarget = $subnetId
                            }
                        }
                    }
                    
                    # Diagnostic Settings (Log Analytics)
                    try {
                        $diagnosticSettings = Get-AzDiagnosticSetting -ResourceId $resource.Id -ErrorAction SilentlyContinue
                        foreach ($setting in $diagnosticSettings) {
                            if ($setting.WorkspaceId) {
                                $workspaceName = ($setting.WorkspaceId -split '/')[-1]
                                $resourceDeps += @{
                                    DependencyName = $workspaceName
                                    DependencyType = "Log Analytics Workspace"
                                    DependencyTarget = $setting.WorkspaceId
                                }
                            }
                            if ($setting.StorageAccountId) {
                                $storageName = ($setting.StorageAccountId -split '/')[-1]
                                $resourceDeps += @{
                                    DependencyName = $storageName
                                    DependencyType = "Diagnostic Storage Account"
                                    DependencyTarget = $setting.StorageAccountId
                                }
                            }
                        }
                    } catch { }
                } catch { }
            }
            
            "Microsoft.ServiceBus/namespaces" {
                try {
                    $serviceBus = Get-AzServiceBusNamespace -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Service Bus Namespace"
                        DependencyTarget = "Messaging Service"
                    }
                    
                    # Managed Identity
                    if ($serviceBus.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $serviceBus.Identity.PrincipalId
                        }
                    }
                    
                    # Network Rules / VNet Integration
                    try {
                        $sbResource = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                        if ($sbResource.Properties.networkRuleSets) {
                            foreach ($vnetRule in $sbResource.Properties.networkRuleSets.virtualNetworkRules) {
                                $subnetId = $vnetRule.subnet.id
                                $subnetName = ($subnetId -split '/')[-1]
                                $vnetName = ($subnetId -split '/')[-3]
                                $resourceDeps += @{
                                    DependencyName = "$vnetName/$subnetName"
                                    DependencyType = "Virtual Network Rule"
                                    DependencyTarget = $subnetId
                                }
                            }
                        }
                    } catch { }
                    
                    # Queues and Topics
                    try {
                        $queues = Get-AzServiceBusQueue -ResourceGroupName $resource.ResourceGroupName -NamespaceName $resource.Name -ErrorAction SilentlyContinue
                        foreach ($queue in $queues) {
                            $resourceDeps += @{
                                DependencyName = $queue.Name
                                DependencyType = "Service Bus Queue"
                                DependencyTarget = $queue.Id
                            }
                        }
                        
                        $topics = Get-AzServiceBusTopic -ResourceGroupName $resource.ResourceGroupName -NamespaceName $resource.Name -ErrorAction SilentlyContinue
                        foreach ($topic in $topics) {
                            $resourceDeps += @{
                                DependencyName = $topic.Name
                                DependencyType = "Service Bus Topic"
                                DependencyTarget = $topic.Id
                            }
                        }
                    } catch { }
                } catch { }
            }
            
            "Microsoft.DocumentDB/databaseAccounts" {
                try {
                    $cosmosDb = Get-AzCosmosDBAccount -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Cosmos DB Account"
                        DependencyTarget = "NoSQL Database"
                    }
                    
                    # Managed Identity
                    if ($cosmosDb.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $cosmosDb.Identity.PrincipalId
                        }
                    }
                    
                    # Virtual Network Rules
                    if ($cosmosDb.VirtualNetworkRules) {
                        foreach ($vnetRule in $cosmosDb.VirtualNetworkRules) {
                            $subnetId = $vnetRule.Id
                            $subnetName = ($subnetId -split '/')[-1]
                            $vnetName = ($subnetId -split '/')[-3]
                            $resourceDeps += @{
                                DependencyName = "$vnetName/$subnetName"
                                DependencyType = "Virtual Network Rule"
                                DependencyTarget = $subnetId
                            }
                        }
                    }
                    
                    # Backup Storage Account (for periodic backups)
                    try {
                        $cosmosResource = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                        if ($cosmosResource.Properties.backupPolicy.type -eq "Periodic") {
                            $resourceDeps += @{
                                DependencyName = "Periodic Backup"
                                DependencyType = "Backup Configuration"
                                DependencyTarget = "Cosmos DB Managed Backup"
                            }
                        }
                    } catch { }
                } catch { }
            }
            
            "Microsoft.EventHub/namespaces" {
                try {
                    $eventHub = Get-AzEventHubNamespace -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name -ErrorAction SilentlyContinue
                    
                    $resourceDeps += @{
                        DependencyName = $resource.Name
                        DependencyType = "Event Hub Namespace"
                        DependencyTarget = "Event Streaming Service"
                    }
                    
                    # Managed Identity
                    if ($eventHub.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $eventHub.Identity.PrincipalId
                        }
                    }
                    
                    # Network Rules / VNet Integration
                    try {
                        $ehResource = Get-AzResource -ResourceId $resource.Id -ExpandProperties
                        if ($ehResource.Properties.networkRuleSets) {
                            foreach ($vnetRule in $ehResource.Properties.networkRuleSets.virtualNetworkRules) {
                                $subnetId = $vnetRule.subnet.id
                                $subnetName = ($subnetId -split '/')[-1]
                                $vnetName = ($subnetId -split '/')[-3]
                                $resourceDeps += @{
                                    DependencyName = "$vnetName/$subnetName"
                                    DependencyType = "Virtual Network Rule"
                                    DependencyTarget = $subnetId
                                }
                            }
                        }
                    } catch { }
                    
                    # Event Hubs
                    try {
                        $eventHubs = Get-AzEventHub -ResourceGroupName $resource.ResourceGroupName -NamespaceName $resource.Name -ErrorAction SilentlyContinue
                        foreach ($eh in $eventHubs) {
                            $resourceDeps += @{
                                DependencyName = $eh.Name
                                DependencyType = "Event Hub"
                                DependencyTarget = $eh.Id
                            }
                        }
                    } catch { }
                } catch { }
            }
            
            "Microsoft.Web/connections" {
                try {
                    $apiConnection = Get-AzResource -ResourceId $resource.Id -ExpandProperties -ErrorAction SilentlyContinue
                    
                    # API Type
                    if ($apiConnection.Properties.api) {
                        $apiType = ($apiConnection.Properties.api.id -split '/')[-1]
                        $resourceDeps += @{
                            DependencyName = $apiType
                            DependencyType = "API Connection Type"
                            DependencyTarget = $apiConnection.Properties.api.id
                        }
                    }
                    
                    # Managed Identity
                    if ($apiConnection.Identity) {
                        $resourceDeps += @{
                            DependencyName = "Managed Identity"
                            DependencyType = "System/User Assigned Identity"
                            DependencyTarget = $apiConnection.Identity.PrincipalId
                        }
                    }
                    
                    # Target Service Connection (Storage Account, Service Bus, SQL, etc.)
                    if ($apiConnection.Properties.parameterValues) {
                        # Storage Account connections
                        if ($apiConnection.Properties.parameterValues.accountName) {
                            $storageAccountName = $apiConnection.Properties.parameterValues.accountName
                            try {
                                $storageAccount = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $storageAccountName } | Select-Object -First 1
                                if ($storageAccount) {
                                    $resourceDeps += @{
                                        DependencyName = $storageAccountName
                                        DependencyType = "Storage Account"
                                        DependencyTarget = $storageAccount.Id
                                    }
                                }
                            } catch { }
                        }
                        
                        # Service Bus connections
                        if ($apiConnection.Properties.parameterValues.connectionString -match "Endpoint=sb://([^.]+)") {
                            $serviceBusName = $Matches[1]
                            try {
                                $serviceBus = Get-AzServiceBusNamespace | Where-Object { $_.Name -eq $serviceBusName } | Select-Object -First 1
                                if ($serviceBus) {
                                    $resourceDeps += @{
                                        DependencyName = $serviceBusName
                                        DependencyType = "Service Bus Namespace"
                                        DependencyTarget = $serviceBus.Id
                                    }
                                }
                            } catch { }
                        }
                        
                        # SQL Server connections
                        if ($apiConnection.Properties.parameterValues.server -or $apiConnection.Properties.parameterValues.sqlConnectionString) {
                            $sqlServerName = $null
                            if ($apiConnection.Properties.parameterValues.server) {
                                $sqlServerName = $apiConnection.Properties.parameterValues.server -replace '\.database\.windows\.net$', ''
                            } elseif ($apiConnection.Properties.parameterValues.sqlConnectionString -match "Server=([^;,]+)") {
                                $sqlServerName = $Matches[1] -replace '\.database\.windows\.net$', ''
                            }
                            
                            if ($sqlServerName) {
                                try {
                                    $sqlServer = Get-AzSqlServer | Where-Object { $_.ServerName -eq $sqlServerName } | Select-Object -First 1
                                    if ($sqlServer) {
                                        $resourceDeps += @{
                                            DependencyName = $sqlServerName
                                            DependencyType = "SQL Server"
                                            DependencyTarget = $sqlServer.ResourceId
                                        }
                                    }
                                } catch { }
                            }
                        }
                        
                        # Event Hub connections
                        if ($apiConnection.Properties.parameterValues.connectionString -match "Endpoint=sb://([^.]+)\.servicebus") {
                            $eventHubName = $Matches[1]
                            try {
                                $eventHub = Get-AzEventHubNamespace | Where-Object { $_.Name -eq $eventHubName } | Select-Object -First 1
                                if ($eventHub) {
                                    $resourceDeps += @{
                                        DependencyName = $eventHubName
                                        DependencyType = "Event Hub Namespace"
                                        DependencyTarget = $eventHub.Id
                                    }
                                }
                            } catch { }
                        }
                        
                        # Cosmos DB connections
                        if ($apiConnection.Properties.parameterValues.databaseAccount) {
                            $cosmosAccountName = $apiConnection.Properties.parameterValues.databaseAccount
                            try {
                                $cosmosAccount = Get-AzCosmosDBAccount | Where-Object { $_.Name -eq $cosmosAccountName } | Select-Object -First 1
                                if ($cosmosAccount) {
                                    $resourceDeps += @{
                                        DependencyName = $cosmosAccountName
                                        DependencyType = "Cosmos DB Account"
                                        DependencyTarget = $cosmosAccount.Id
                                    }
                                }
                            } catch { }
                        }
                    }
                    
                    # Find Logic Apps that reference this API Connection
                    try {
                        $logicApps = Get-AzResource -ResourceType "Microsoft.Logic/workflows" -ErrorAction SilentlyContinue
                        foreach ($la in $logicApps) {
                            $laResource = Get-AzResource -ResourceId $la.Id -ExpandProperties -ErrorAction SilentlyContinue
                            if ($laResource.Properties.parameters.'$connections'.value) {
                                $connections = $laResource.Properties.parameters.'$connections'.value
                                foreach ($conn in $connections.PSObject.Properties) {
                                    if ($conn.Value.connectionId -eq $resource.Id) {
                                        $resourceDeps += @{
                                            DependencyName = $la.Name
                                            DependencyType = "Logic App"
                                            DependencyTarget = $la.Id
                                        }
                                        break
                                    }
                                }
                            }
                        }
                    } catch { }
                } catch { }
            }
        }
        
        # Check for private endpoints on all resources
        try {
            $privateEndpoints = Get-AzPrivateEndpoint -WarningAction SilentlyContinue | Where-Object { 
                $_.PrivateLinkServiceConnections.PrivateLinkServiceId -like "*$($resource.Id)*" 
            }
            foreach ($pe in $privateEndpoints) {
                $resourceDeps += @{
                    DependencyName = $pe.Name
                    DependencyType = "Private Endpoint"
                    DependencyTarget = $pe.Id
                }
            }
        } catch { }
    } catch {
        Write-Warning "Error processing $($resource.Name): $_"
    }
    
    $resources += $resourceDetail
    
    # Add dependencies to list
    foreach ($dep in $resourceDeps) {
        # Extract dependency resource group from target ID
        $depResourceGroup = ""
        if ($dep.DependencyTarget -like "/subscriptions/*") {
            $parts = $dep.DependencyTarget -split '/'
            $rgIdx = [System.Array]::IndexOf($parts, 'resourceGroups') + 1
            if ($rgIdx -gt 0 -and $rgIdx -lt $parts.Count) {
                $depResourceGroup = $parts[$rgIdx]
            }
        }
        
        $dependencyList += @{
            SourceResourceType = $resource.Type
            SourceResourceName = $resource.Name
            SourceResourceGroup = $resource.ResourceGroupName
            DependencyType = $dep.DependencyType
            DependencyName = $dep.DependencyName
            DependencyResourceGroup = $depResourceGroup
            DependencyTarget = $dep.DependencyTarget
        }
    }
}

# Generate outputs
if ($OutputFormat -in @("json", "both")) {
    $jsonReport = @{
        GeneratedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Subscription = $SubscriptionId
        ResourceGroupFilter = $ResourceGroupFilter
        TotalResources = $resources.Count
        TotalDependencies = $dependencyList.Count
        Resources = $resources
        Dependencies = $dependencyList
    }
    
    $jsonPath = "$OutputPath.json"
    $jsonReport | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8
    Write-Host "✓ JSON report saved to: $jsonPath"
}

if ($OutputFormat -in @("csv", "both")) {
    $csvPath = "$OutputPath.csv"
    # Reorder columns for better readability
    $dependencyListReordered = $dependencyList | Select-Object -Property `
        SourceResourceType, SourceResourceName, SourceResourceGroup, `
        DependencyName, DependencyType, DependencyResourceGroup, DependencyTarget
    $dependencyListReordered | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
    Write-Host "✓ CSV report saved to: $csvPath"
}

# Display summary
Write-Host "`n=== Dependency Mapping Summary ==="
Write-Host "Total Resources: $($resources.Count)"
Write-Host "Total Dependencies: $($dependencyList.Count)"
Write-Host "`nResources with Dependencies:"
$dependencyList | Group-Object -Property SourceResourceName | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count) dependency(ies)"
}
