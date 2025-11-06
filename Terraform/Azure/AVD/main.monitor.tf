module "law" {
  source                                    = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version                                   = "0.4.2"
  name                                      = "avdlaw"
  resource_group_name                       = azurerm_resource_group.this.name
  location                                  = azurerm_resource_group.this.location
  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_retention_in_days = 30
  log_analytics_workspace_identity = {
    type = "SystemAssigned"
  }
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
} 

resource "azurerm_user_assigned_identity" "this" {
  location            = azurerm_resource_group.this.location
  name                = "uai-avd-dcr"
  resource_group_name = azurerm_resource_group.this.name
}

# Creates an association between an Azure Monitor data collection rule and a virtual machine.
resource "azurerm_monitor_data_collection_rule_association" "example" {
  count = var.vm_count

  target_resource_id      = azurerm_windows_virtual_machine.this[count.index].id
  data_collection_rule_id = module.avm_ptn_avd_lza_insights.resource.id
  name                    = "${var.avd_vm_name}-association-${count.index}"
}

# Create resources for Azure Virtual Desktop Insights data collection rules
module "avm_ptn_avd_lza_insights" {
  source  = "Azure/avm-ptn-avd-lza-insights/azurerm"
  version = ">= 0.1.4"

  monitor_data_collection_rule_data_flow = [
    {
      destinations = [module.law.avdlaw.name]
      streams      = ["Microsoft-Perf", "Microsoft-Event"]
    }
  ]
  monitor_data_collection_rule_location            = azurerm_resource_group.this.location
  monitor_data_collection_rule_name                = "microsoft-avdi-eastus"
  monitor_data_collection_rule_resource_group_name = azurerm_resource_group.this.name
  enable_telemetry                                 = var.enable_telemetry
  monitor_data_collection_rule_data_sources = {
    performance_counter = [
      {
        counter_specifiers            = ["\\LogicalDisk(C:)\\Avg. Disk Queue Length", "\\LogicalDisk(C:)\\Current Disk Queue Length", "\\Memory\\Available Mbytes", "\\Memory\\Page Faults/sec", "\\Memory\\Pages/sec", "\\Memory\\% Committed Bytes In Use", "\\PhysicalDisk(*)\\Avg. Disk Queue Length", "\\PhysicalDisk(*)\\Avg. Disk sec/Read", "\\PhysicalDisk(*)\\Avg. Disk sec/Transfer", "\\PhysicalDisk(*)\\Avg. Disk sec/Write", "\\Processor Information(_Total)\\% Processor Time", "\\User Input Delay per Process(*)\\Max Input Delay", "\\User Input Delay per Session(*)\\Max Input Delay", "\\RemoteFX Network(*)\\Current TCP RTT", "\\RemoteFX Network(*)\\Current UDP Bandwidth"]
        name                          = "perfCounterDataSource10"
        sampling_frequency_in_seconds = 30
        streams                       = ["Microsoft-Perf"]
      },
      {
        counter_specifiers            = ["\\LogicalDisk(C:)\\% Free Space", "\\LogicalDisk(C:)\\Avg. Disk sec/Transfer", "\\Terminal Services(*)\\Active Sessions", "\\Terminal Services(*)\\Inactive Sessions", "\\Terminal Services(*)\\Total Sessions"]
        name                          = "perfCounterDataSource30"
        sampling_frequency_in_seconds = 30
        streams                       = ["Microsoft-Perf"]
      }
    ],
    windows_event_log = [
      {
        name           = "eventLogsDataSource"
        streams        = ["Microsoft-Event"]
        x_path_queries = ["Microsoft-Windows-TerminalServices-RemoteConnectionManager/Admin!*[System[(Level=2 or Level=3 or Level=4 or Level=0)]]", "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational!*[System[(Level=2 or Level=3 or Level=4 or Level=0)]]", "System!*", "Microsoft-FSLogix-Apps/Operational!*[System[(Level=2 or Level=3 or Level=4 or Level=0)]]", "Application!*[System[(Level=2 or Level=3)]]", "Microsoft-FSLogix-Apps/Admin!*[System[(Level=2 or Level=3 or Level=4 or Level=0)]]"]
      }
    ]
  }
  monitor_data_collection_rule_destinations = {
    log_analytics = {
      name                  = module.law.resource.name
      workspace_resource_id = module.law.resource.id
    }
  }
  monitor_data_collection_rule_kind = "Windows"
}