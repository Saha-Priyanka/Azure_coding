# resource "azurerm_user_assigned_identity" "uami" {
#   location            = var.kv_rg_location
#   name                = var.kv_uami_name
#   resource_group_name = var.kv_rg_name
# } -- not allowed in sandbox subscription

data "azurerm_client_config" "current" {} 

resource "azurerm_key_vault" "key_vault" {
  name                        = var.kv_name
  location                    = var.kv_rg_location
  resource_group_name         = var.kv_rg_name
  enabled_for_disk_encryption = var.kv_enabled_for_disk_encryption #true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.kv_softdel_ret_day #7
  #purge_protection_enabled    = var.kv_purge_protection_enabled #false -- not allowed in sandbox subscription

  sku_name = var.kv_sku 

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = var.kv_key_permissions 

    secret_permissions = var.kv_secret_permissions 

    certificate_permissions = var.kv_certificate_permissions 
  }
}

