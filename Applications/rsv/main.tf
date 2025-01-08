resource "azurerm_resource_group" "rg" {
  name     = "rg-rsvTest"
  location = "West US"
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "testVault"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  public_network_access_enabled = false
  soft_delete_enabled = true

  storage_mode_type = "LocallyRedundant"
}

resource "azurerm_site_recovery_replication_policy" "ReplicationPolicy" {
  name                                                 = "myReplicationPolicy"
  resource_group_name                                  = azurerm_resource_group.rg.name
  recovery_vault_name                                  = azurerm_recovery_services_vault.vault.name
  recovery_point_retention_in_minutes                  = 1440
  application_consistent_snapshot_frequency_in_minutes = 60
}

resource "azurerm_backup_policy_vm" "backupPolicy" {
  name                = "myBackupPolicy"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  policy_type = "V2"
  instant_restore_retention_days = 5

  timezone = "UTC"

  backup {
    frequency = "Weekly"
    time      = "21:00"
    weekdays = ["Sunday"]
  }
/*
  retention_daily {
    count = 14
  }
  */


  retention_weekly {
    count    = 42
    weekdays = ["Sunday"]
  }
/*
  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
  */
}
