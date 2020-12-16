terraform {
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
  required_version = ">= 0.13"
}

provider "postgresql" {
  host            = "localhost"
  port            = 5432
  username        = var.username
  password        = var.password
  sslmode         = "disable"
  connect_timeout = 15
}

resource "postgresql_database" "db" {
  name              = var.database
  owner             = "postgres"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
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