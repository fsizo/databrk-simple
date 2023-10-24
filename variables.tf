variable "cidr" {
  type    = string
  default = "10.0.0.0/23"
}

variable "rg_name" {
  type    = string
  default = "rg-databrk-fsi"
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "workspace_prefix" {
  type    = string
  default = "wrksp-databrk-fsi"
}

data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  prefix = "fsi"
  tags = {
    Environment = "Demo"
    Owner       = lookup(data.external.me.result, "name")
  }
}