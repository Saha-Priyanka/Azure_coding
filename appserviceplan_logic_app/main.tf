resource "azurerm_service_plan" "service_plan" {
  name                = var.lsp_name
  resource_group_name = var.lsp_rg_name
  location            = var.lsp_rg_location
  sku_name            = var.lsp_sku 
  os_type             = var.lsp_os_type 
  
}

