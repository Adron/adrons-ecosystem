provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "azurerm_resource_group" "adronsrg" {
  name     = "adrons-rg"
  location = "westus2"
}

resource "azurerm_postgresql_server" "logisticsserver" {
  name = var.server
  location = azurerm_resource_group.adronsrg.location
  resource_group_name = azurerm_resource_group.adronsrg.name
  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.pusername
  administrator_login_password = var.ppassword
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "logisticsdb" {
  name                = var.database
  resource_group_name = azurerm_resource_group.adronsrg.name
  server_name         = azurerm_postgresql_server.logisticsserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

variable "database" {
  type = string
}

variable "server" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}