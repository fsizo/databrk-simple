terraform {
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.4.8"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.43.0"
    }
  }
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.this.id
  azure_client_id             = "3193c0e0-e0a4-4448-8c38-df9162661dc2"
  azure_client_secret         = "2hG8Q~rATfBO8X9AwR9wfNp0gEjngQ-QW7EkzcQC"
  azure_tenant_id             = "b1bd5078-1566-4c5a-ba38-32a2294374aa"
}
provider "azurerm" {
  subscription_id = "e5155bb0-da77-40cb-9202-7a1c541490ef"
  client_id       = "3193c0e0-e0a4-4448-8c38-df9162661dc2"
  client_secret   = "2hG8Q~rATfBO8X9AwR9wfNp0gEjngQ-QW7EkzcQC"
  tenant_id       = "b1bd5078-1566-4c5a-ba38-32a2294374aa"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

  }
}