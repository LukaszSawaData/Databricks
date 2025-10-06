terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name   = "terraform_configs"
    storage_account_name  = "storageforterraformls"
    container_name        = "state"
    key                   = "tfstate/terraform.tfstate"
   use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "first_rg"
  location = "westus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "first_vnet"
  address_space       = ["{vnet_address_space}"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "{subnet_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["{subnet_address_space}"]
}

resource "azurerm_databricks_workspace" "dbw" {
  name                        = "stg-databricks-workspace"
  resource_group_name          = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "standard"
  managed_resource_group_name  = "managed-rg-databricks"
  custom_parameters {
    virtual_network_id = azurerm_virtual_network.vnet.id
    public_subnet_name = azurerm_subnet.subnet.name
  }
}
