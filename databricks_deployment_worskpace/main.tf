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
    storage_account_name = "storageforterraformls"
    container_name       = "state"
    key                  = "tfstate/terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" { features {} }

# ===== RG =====
resource "azurerm_resource_group" "rg" {
  name     = "first_rg"
  location = "westus"
}

# ===== VNet & Subnets =====
resource "azurerm_virtual_network" "vnet" {
  name                = "first_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "databricks-delegation-public"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "databricks-delegation-private"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# ===== NSG =====
resource "azurerm_network_security_group" "public_nsg" {
  name                = "nsg-public-dbx"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private-dbx"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Minimalne reguły (dopasuj do swojej polityki)
resource "azurerm_network_security_rule" "allow_outbound_internet_public" {
  name                        = "allow-outbound-internet"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}

resource "azurerm_network_security_rule" "allow_outbound_internet_private" {
  name                        = "allow-outbound-internet"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.private_nsg.name
}

# ===== NSG Associations (to ID tych zasobów oczekuje Databricks custom_parameters) =====
resource "azurerm_subnet_network_security_group_association" "public_assoc" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "private_assoc" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

# ===== Databricks Workspace (VNet Injection) =====
resource "azurerm_databricks_workspace" "dbw" {
  name                         = "stg-databricks-workspace"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  sku                          = "standard"
  managed_resource_group_name  = "managed-rg-databricks"

  # (opcjonalnie) Bez publicznych IP dla klastrów
  # public_network_access_enabled = false

  custom_parameters {
    virtual_network_id = azurerm_virtual_network.vnet.id

    public_subnet_name  = azurerm_subnet.public_subnet.name
    private_subnet_name = azurerm_subnet.private_subnet.name

    # NOWE – wymagane przez provider:
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public_assoc.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private_assoc.id

    # (opcjonalnie) Wymuś brak publicznych IP na ws/clusterach:
    # no_public_ip = true
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.public_assoc,
    azurerm_subnet_network_security_group_association.private_assoc
  ]
}
