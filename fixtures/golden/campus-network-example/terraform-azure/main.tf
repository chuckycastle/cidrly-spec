#
# cidrly Network Configuration
# Plan: Campus Network Example
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
  plan_name = "campus_network_example"
  base_cidr = "10.100.0.0/21"
  tags = {
    ManagedBy = "cidrly"
    PlanName  = "Campus Network Example"
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

# Subnet: Student WiFi (VLAN 30)
resource "azurerm_subnet" "student_wifi" {
  name                 = "student_wifi"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.100.0.0/23"]
}

# Subnet: Engineering Building (VLAN 10)
resource "azurerm_subnet" "engineering_building" {
  name                 = "engineering_building"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.100.2.0/24"]
}

# Subnet: Science Lab (VLAN 20)
resource "azurerm_subnet" "science_lab" {
  name                 = "science_lab"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.100.3.0/24"]
}

# Subnet: Guest WiFi (VLAN 50)
resource "azurerm_subnet" "guest_wifi" {
  name                 = "guest_wifi"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.100.4.0/25"]
}

# Subnet: Administration (VLAN 40)
resource "azurerm_subnet" "administration" {
  name                 = "administration"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.100.4.128/26"]
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

resource "azurerm_subnet_network_security_group_association" "student_wifi" {
  subnet_id                 = azurerm_subnet.student_wifi.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "engineering_building" {
  subnet_id                 = azurerm_subnet.engineering_building.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "science_lab" {
  subnet_id                 = azurerm_subnet.science_lab.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "guest_wifi" {
  subnet_id                 = azurerm_subnet.guest_wifi.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "administration" {
  subnet_id                 = azurerm_subnet.administration.id
  network_security_group_id = azurerm_network_security_group.main.id
}
