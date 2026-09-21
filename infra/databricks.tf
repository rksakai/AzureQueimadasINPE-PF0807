resource "azurerm_resource_group" "databricks" {
  name     = "${var.prefix}-databricks-rg"
  location = var.region
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "${var.prefix}-databricks-ws"
  resource_group_name         = azurerm_resource_group.databricks.name
  location                    = azurerm_resource_group.databricks.location
  sku                         = "premium" # ou "standard" se não precisar de CMK/compliance
  managed_resource_group_name = "${var.prefix}-databricks-managed-rg"

  tags = {
    Environment = var.environment
  }
}
