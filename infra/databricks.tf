resource "azurerm_resource_group" "databricks" {
  name     = "rg-databricks-${var.sufix}"
  location = var.location
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "ws-databricks-${var.sufix}"
  resource_group_name         = azurerm_resource_group.databricks.name
  location                    = azurerm_resource_group.databricks.location
  sku                         = "premium" # ou "standard" se não precisar de CMK/compliance
  managed_resource_group_name = "rg--databricks-managed-${var.sufix}"

  tags = {
    Environment = var.environment
  }
}
