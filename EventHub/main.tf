resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = var.ehubns_name
  location            = var.ehub_rg_location
  resource_group_name = var.ehub_rg_name
  sku                 = var.ehubns_sku #"Standard"
  capacity            = var.ehubns_capacity #1
  auto_inflate_enabled = var.ehubns_auto_inf_en  #false
identity {
  type = var.ehubns_identity
}
 
}

resource "azurerm_eventhub" "eventhub" {
  name              = var.ehub_name
  #namespace_id      = azurerm_eventhub_namespace.eventhub_namespace.id
  partition_count   = var.ehub_parti_count  #2
  message_retention = var.ehub_msg_ret #1
  resource_group_name =  var.ehub_rg_name
  namespace_name = azurerm_eventhub_namespace.eventhub_namespace.name

}