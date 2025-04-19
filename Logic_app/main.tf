resource "azurerm_logic_app_standard" "logic_app" {
  name =  var.lap_name
  location =  var.lap_rg_location
  app_service_plan_id = var.lap_asp_id  
  storage_account_name =  var.lap_stg_name
  storage_account_access_key =  var.lap_stg_access_key
  storage_account_share_name = var.lap_stg_share_name 
  resource_group_name = var.lap_rg_name
  version = var.lap_ver #"~4"
  enabled = var.lap_enabled #true
  https_only = var.lap_https_only #true
  site_config {
    always_on = var.lap_always_on #true
    vnet_route_all_enabled = var.lap_vnet_route_all_enabled #true
    
  }
  identity {
    type = var.lap_identity
  }
  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = var.lap_web_node_ver #"~18"
    "FUNCTIONS_WORKER_RUNTIME" = var.lap_func_runtime #"node"
    "WEBSITE_CONTENTOVERVNET" = var.lap_web_content_over_vnet #1
    "WEBSITE_VNET_ROUTE_ALL" = var.lap_web_vnet_route_all #1
  }
}