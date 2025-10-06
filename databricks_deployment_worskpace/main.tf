terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name  = "terraform_configs"
    storage_account_name = "storageforterraformls" # musi być globalnie unikalne
    container_name       = "state"
    key                  = "tfstate/terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}

# ===== Resource Group =====
resource "azurerm_resource_group" "rg" {
  name     = "first_rg"
  location = "westus"
}

# ===== Networking =====
resource "azurerm_virtual_network" "vnet" {
  name                = "first_vnet"
  address_space       = ["10.0.0.0/16"] # VNet szerszy niż subnety
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# ===== Databricks Workspace (VNet Injection) =====
resource "azurerm_databricks_workspace" "dbw" {
  name                       = "stg-databricks-workspace"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  sku                        = "standard"
  managed_resource_group_id  = null
  managed_resource_group_name = "managed-rg-databricks"

  custom_parameters {
    virtual_network_id  = azurerm_virtual_network.vnet.id
    public_subnet_name  = azurerm_subnet.public_subnet.name
    private_subnet_name = azurerm_subnet.private_subnet.name
    # jeżeli chcesz blokować publiczne IP:
    # no_public_ip = true
  }
}
