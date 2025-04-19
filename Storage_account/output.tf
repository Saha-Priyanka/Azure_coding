output "stg_name" {
  value = azurerm_storage_account.storage_account.name
}
output "stg_id" {
  value = azurerm_storage_account.storage_account.id
}
output "stg_access_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
}