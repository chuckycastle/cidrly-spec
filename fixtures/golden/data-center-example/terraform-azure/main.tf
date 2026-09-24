#
# cidrly Network Configuration
# Plan: Data Center Example
# Provider: Azure
# Generated: <timestamp>
#

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  plan_name = "data_center_example"
  base_cidr = "172.16.0.0/24"
  tags = {
    ManagedBy = "cidrly"
    PlanName  = "Data Center Example"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${local.plan_name}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [local.base_cidr]
  tags                = local.tags
}

# Subnet: Web Tier (VLAN 100)
resource "azurerm_subnet" "web_tier" {
  name                 = "web_tier"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.0/26"]
}

# Subnet: Application Tier (VLAN 110)
resource "azurerm_subnet" "application_tier" {
  name                 = "application_tier"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.64/26"]
}

# Subnet: Database Tier (VLAN 120)
resource "azurerm_subnet" "database_tier" {
  name                 = "database_tier"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.128/27"]
}

# Subnet: Storage Network (VLAN 130)
resource "azurerm_subnet" "storage_network" {
  name                 = "storage_network"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.160/27"]
}

# Subnet: Management (VLAN 140)
resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.192/27"]
}

# Subnet: Backup Network (VLAN 150)
resource "azurerm_subnet" "backup_network" {
  name                 = "backup_network"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.16.0.224/28"]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "${local.plan_name}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Allow SSH from VNet
  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow HTTPS from VNet
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "web_tier" {
  subnet_id                 = azurerm_subnet.web_tier.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "application_tier" {
  subnet_id                 = azurerm_subnet.application_tier.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "database_tier" {
  subnet_id                 = azurerm_subnet.database_tier.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "storage_network" {
  subnet_id                 = azurerm_subnet.storage_network.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "backup_network" {
  subnet_id                 = azurerm_subnet.backup_network.id
  network_security_group_id = azurerm_network_security_group.main.id
}
