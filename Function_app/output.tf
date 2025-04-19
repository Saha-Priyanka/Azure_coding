output "fap_name" {
  value = azurerm_windows_function_app.windows_func_app.name
}
output "fap_id" {
  value = azurerm_windows_function_app.windows_func_app.id
}
output "fsp_name" {
  value = azurerm_service_plan.service_plan.name
}
output "fsp_id" {
  value = azurerm_service_plan.service_plan.id
}