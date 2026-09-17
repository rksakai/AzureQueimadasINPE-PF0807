variable "location" {
  default = "chilecentral"
}

variable "resource_group_name" {
  default = "rg-monitor-queimadas"
}

variable "mysql_server_name" {
  default = "mysql-server-fiap-pf0807"
}

variable "mysql_admin_user" {
  default = "adminuser"
}

variable "mysql_admin_password" {
  type      = string
  sensitive = true
}

variable "sql_db_name" {
  default = "db_queimadas"
}

variable "function_app_name" {
  default = "func-queimadas-pf0807"
}

variable "storage_account_name" {
  default = "stqueimadasfuncpf0807"
}

variable "acr_name" {
  default = "acrqueimadaspf0807"
}

variable "aci_name" {
  default = "aci-webapp-queimadas"
}

variable "webapp_image_tag" {
  default = "latest"
}

variable "teste" {
  default = "teste"
}
