resource "azurerm_service_plan" "service_plan" {
  name                = var.fsp_name
  resource_group_name = var.fsp_rg_name
  location            = var.fsp_rg_location
  sku_name            = var.fsp_sku # "P1v2" #need to check
  os_type             = var.fsp_os_type #"Windows"
  
}

resource "azurerm_windows_function_app" "windows_func_app" {
  name                       = var.fap_name
  resource_group_name = var.fsp_rg_name
  location            = var.fsp_rg_location
  service_plan_id        = azurerm_service_plan.service_plan.id
  storage_account_name       = var.fsp_stg_name
  storage_account_access_key = var.fsp_stg_access_key
  site_config {
    always_on = var.fsp_always_on #true
    application_stack {
      node_version = var.fsp_ver #"~18"
    }
  }
  identity {
    type = var.fsp_identity #"SystemAssigned"
  }
  app_settings = {
       "WEBSITE_NODE_DEFAULT_VERSION" = var.fsp_web_node_ver #"~18"
  }
}
