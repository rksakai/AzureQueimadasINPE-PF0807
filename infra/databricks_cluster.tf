data "databricks_node_type" "smallest" {
  local_disk = true
  depends_on = [azurerm_databricks_workspace.this]
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  depends_on        = [azurerm_databricks_workspace.this]
}

resource "databricks_cluster" "etl" {
  cluster_name            = "${var.prefix}-etl-cluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20

  autoscale {
    min_workers = 1
    max_workers = 2
  }

  spark_conf = {
    "spark.databricks.io.cache.enabled" = "true"
  }

  custom_tags = {
    Project = var.prefix
  }
}

# Driver MySQL Connector/J via Maven (resolve o JDBC_DRIVER_NOT_FOUND)
resource "databricks_library" "mysql_jdbc" {
  cluster_id = databricks_cluster.etl.id
  maven {
    coordinates = "com.mysql:mysql-connector-j:8.4.0"
  }
}
