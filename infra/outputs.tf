output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "function_app_url" {
  value = "https://${azurerm_linux_function_app.func.default_hostname}"
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "webapp_fqdn" {
  value = azurerm_container_group.webapp.fqdn
} 
