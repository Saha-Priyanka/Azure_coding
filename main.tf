locals {
  full_name = "${var.offer_name}-${var.environment_name}"
  full_name1 = "${var.offer_name}${var.environment_name}"
  default_tags={
    offer_name =var.offer_name
    environment_name= var.environment_name
    Description = "Resource terraformed for ${local.full_name}"
    Description1 = "Resource terraformed for ${local.full_name1}"
    Terraform = "true"
  }
}
module "virtual_network" {
  source = "./Virtual_network"
  vnet_address_space =  ["10.0.0.0/16"]
  vnet_name =  "vnet-${local.full_name}-01"
  vnet_rg_location =  data.azurerm_resource_group.resource_group.location
  vnet_rg_name =  data.azurerm_resource_group.resource_group.name
 
}
module "azurerm_subnet" {
  depends_on = [ module.virtual_network ]
  source = "./subnet"
  snet_asp_address_prefix =   ["10.0.2.0/24"]
  snet_asp_name =  "asp-snet-${local.full_name}-02"
  snet_pep_address_prefix =  ["10.0.1.0/24"] 
  snet_pep_name = "pep-snet-${local.full_name}-01"
  vnet_rg_name =  data.azurerm_resource_group.resource_group.name
  vnet_name =  module.virtual_network.vnet_name

}

data "azurerm_resource_group" "resource_group" {
  name = "learn-43fd8e39-93bf-4f81-a4b5-83a27b250a8f"
}

module "azurerm_windows_webapp" {
  depends_on = [ module.azurerm_windows_app_service_plan ]
  source = "./Webapp"
  wap_asp_id = module.azurerm_windows_app_service_plan.asp_id
  wap_name =  "wap-${local.full_name}-01"
  wap_rg_location = data.azurerm_resource_group.resource_group.location
  wap_rg_name = data.azurerm_resource_group.resource_group.name
  wap_identity = "SystemAssigned"
}

module "azurerm_windows_app_service_plan" {
  source = "./appserviceplan"
  asp_name =  "asp-${local.full_name}-01"
  asp_os_type =  "Windows"
  asp_rg_location =  data.azurerm_resource_group.resource_group.location 
  asp_rg_name =  data.azurerm_resource_group.resource_group.name
  asp_sku = "S1"
}

module "azurerm_storage_account" {
  source = "./Storage_account"
  stg_account_replication_type = "GRS"
  stg_account_tier =  "Standard"
  stg_name =  "stg${local.full_name1}01"
  stg_rg_location =  data.azurerm_resource_group.resource_group.location 
  stg_rg_name = data.azurerm_resource_group.resource_group.name
}

module "azurerm_key_vault" {
  source = "./Key_Vault"
  #kv_uami_name = "kv-uami-${local.full_name}-01" -- not allowed in sandbox subscription
  kv_certificate_permissions = ["Get", "Update", "Import", "Create", "List", "Backup", "Recover"]
  kv_enabled_for_disk_encryption =  true
  kv_key_permissions =  ["Get", "Update", "Import", "Create", "List", "Backup", "Recover"]
  kv_name =  "kyv-${local.full_name}-01"
  #kv_purge_protection_enabled =  false --not allowed in sandbox subscription
  kv_rg_location =  data.azurerm_resource_group.resource_group.location
  kv_rg_name =  data.azurerm_resource_group.resource_group.name
  kv_secret_permissions =  ["Get", "List", "Backup", "Recover"]
  kv_sku =  "standard"
  kv_softdel_ret_day =  7

}

module "azurerm_logic_appservice_plan" {
  source = "./appserviceplan_logic_app"
  lsp_name =  "lsp-${local.full_name}-01"
  lsp_os_type =  "Windows"
  lsp_rg_location =  data.azurerm_resource_group.resource_group.location
  lsp_rg_name =  data.azurerm_resource_group.resource_group.name
  lsp_sku = "WS1"
}

module "azurerm_logic_app" {
  depends_on = [ module.azurerm_logic_appservice_plan, module.azurerm_storage_account ]
  source = "./Logic_app"
  lap_always_on =  true
  lap_asp_id =  module.azurerm_logic_appservice_plan.lsp_id
  lap_enabled = true 
  lap_func_runtime =  "node"
  lap_https_only =  true
  lap_name =  "lap-${local.full_name}-01"
  lap_rg_location =  data.azurerm_resource_group.resource_group.location
  lap_rg_name =  data.azurerm_resource_group.resource_group.name
  lap_stg_access_key =  module.azurerm_storage_account.stg_access_key
  lap_stg_name =  module.azurerm_storage_account.stg_name
  lap_stg_share_name =  "lappfileshare"
  lap_ver = "~4" 
  lap_vnet_route_all_enabled = true 
  lap_web_content_over_vnet =  1
  lap_web_node_ver =  "~18"
  lap_web_vnet_route_all = 1
  lap_identity = "SystemAssigned"
}

module "azurerm_windows_function_app" {
  depends_on = [ module.azurerm_storage_account ]
  source = "./Function_app"
  fsp_always_on = true 
  fsp_identity =  "SystemAssigned"
  fsp_name =  "fsp-${local.full_name}-01"
  fsp_os_type =  "Windows"
  fsp_rg_location = data.azurerm_resource_group.resource_group.location 
  fsp_rg_name =  data.azurerm_resource_group.resource_group.name
  fsp_sku =  "S1"
  fsp_stg_access_key =  module.azurerm_storage_account.stg_access_key
  fsp_stg_name =  module.azurerm_storage_account.stg_name
  fsp_ver =  "~18"
  fsp_web_node_ver = "~18"
  fap_name = "fap-${local.full_name}-01"
}
/*
#not allowed in sandbox subscription
module "azurerm_eventhub" {
  source = "./EventHub"
  ehub_msg_ret =  1
  ehub_name =  "ehub-${local.full_name}-01"
  ehub_parti_count =  2
  ehub_rg_location =  data.azurerm_resource_group.resource_group.location 
  ehub_rg_name =  data.azurerm_resource_group.resource_group.name
  ehubns_auto_inf_en =  false
  ehubns_capacity =  1
  ehubns_name = "ehubns-${local.full_name}-01" 
  ehubns_sku = "Standard"
  ehubns_identity = "SystemAssigned"
}*/