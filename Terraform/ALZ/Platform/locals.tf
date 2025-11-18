
locals {
  common_tags = {
    created_by  = "terraform"
    project     = "Azure Landing Zones"
    owner       = "Charles Shea"
    EndDate     = "2025-12-31"
    environment = "demo"
  }
  resource_groups = {
    hub_conn = {
      name     = "rg-hub-conn-${var.location}-001"
      location = var.location
    }
    hub_dns = {
      name     = "rg-hub-dns-${var.location}-001"
      location = var.location
    }
    hub_mgmt = {
      name     = "rg-hub-mgmt-${var.location}-001"
      location = var.location
    }
  }
  network_watcher_name                = "NetworkWatcher_${local.resource_groups["hub_mgmt"].location}"
  network_watcher_resource_group_name = "NetworkWatcherRG"
  tags = {
    scenario = "Network Watcher Flow Logs AVM Sample"
  }
  
  # Comment out which private dns zone exclusions you want to use
  private_dns_zones_exclude = [
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",
    "privatelink.cognitiveservices.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.directline.botframework.com",
    "privatelink.token.botframework.com",
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net",
    "privatelink.azuresynapse.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.azurehdinsight.net",
    "privatelink.azuredatabricks.net",
    "privatelink-global.wvd.microsoft.com",
    "privatelink.wvd.microsoft.com",
    "privatelink.azurecr.io",
    "privatelink.database.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.mongo.cosmos.azure.com",
    "privatelink.cassandra.cosmos.azure.com",
    "privatelink.gremlin.cosmos.azure.com",
    "privatelink.table.cosmos.azure.com",
    "privatelink.analytics.cosmos.azure.com",
    "privatelink.postgres.cosmos.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mariadb.database.azure.com",
    "privatelink.redis.cache.windows.net",
    "privatelink.redisenterprise.cache.azure.net",
    "privatelink.his.arc.azure.com",
    "privatelink.guestconfiguration.azure.com",
    "privatelink.dp.kubernetesconfiguration.azure.com",
    "privatelink.eventgrid.azure.net",
    "privatelink.azure-api.net",
    "privatelink.workspace.azurehealthcareapis.com",
    "privatelink.fhir.azurehealthcareapis.com",
    "privatelink.dicom.azurehealthcareapis.com",
    "privatelink.azure-devices.net",
    "privatelink.azure-devices-provisioning.net",
    "privatelink.api.adu.microsoft.com",
    "privatelink.azureiotcentral.com",
    "privatelink.digitaltwins.azure.net",
    "privatelink.media.azure.net",
    #"privatelink.azure-automation.net",
    #"privatelink.siterecovery.windowsazure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.prod.migration.windowsazure.com",
    "privatelink.grafana.azure.com",
    "privatelink.managedhsm.azure.net",
    "privatelink.azconfig.io",
    "privatelink.attest.azure.net",
    #"privatelink.vaultcore.azure.net",
    #"privatelink.blob.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.afs.azure.net",
    "privatelink.search.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.azurewebsites.net",
    "privatelink.service.signalr.net",
    "privatelink.azurestaticapps.net",
    "privatelink.servicebus.windows.net",
    "privatelink.azurehealthcareapis.com",
    "privatelink.analysis.windows.net",
    "privatelink.1.azurestaticapps.net",
    "privatelink.2.azurestaticapps.net",
    "privatelink.3.azurestaticapps.net",
    "privatelink.4.azurestaticapps.net",
    "privatelink.5.azurestaticapps.net",
    "privatelink.batch.azure.com",
    "privatelink.eastus.azmk8s.io",
    "privatelink.eastus.azurecontainerapps.io",
    "privatelink.eastus.kusto.windows.net",
    "privatelink.eus.backup.windowsazure.com",
    "privatelink.monitor.azure.com",
    "privatelink.pbidedicated.windows.net",
    "privatelink.tip1.powerquery.microsoft.com",
    "privatelink.webpubsub.azure.com"
  ]
}

