resource "azurerm_container_group" "webapp" {
  name                = var.aci_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "webapp-queimadas-pf0807"

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "webapp-queimadas"
    image  = "${azurerm_container_registry.acr.login_server}/webapp-queimadas:${var.webapp_image_tag}"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = {
      SQL_SERVER = azurerm_mysql_flexible_server.mysql.fqdn
      SQL_USER   = var.mysql_admin_user
      SQL_DB     = var.sql_db_name
    }

    secure_environment_variables = {
      SQL_PASS = var.mysql_admin_password
    }
  }

  depends_on = [
    azurerm_mysql_flexible_server_firewall_rule.allow_azure
  ]
}
