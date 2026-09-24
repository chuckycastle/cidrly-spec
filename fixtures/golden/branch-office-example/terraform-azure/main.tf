#
# cidrly Network Configuration
# Plan: Branch Office Example
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
  plan_name = "branch_office_example"
  base_cidr = "192.168.10.0/24"
  tags = {
    ManagedBy = "cidrly"
    PlanName  = "Branch Office Example"
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

# Subnet: Office Workstations (VLAN 10)
resource "azurerm_subnet" "office_workstations" {
  name                 = "office_workstations"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.10.0/26"]
}

# Subnet: VoIP Phones (VLAN 20)
resource "azurerm_subnet" "voip_phones" {
  name                 = "voip_phones"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.10.64/27"]
}

# Subnet: Guest WiFi (VLAN 30)
resource "azurerm_subnet" "guest_wifi" {
  name                 = "guest_wifi"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.10.96/27"]
}

# Subnet: Printers (VLAN 40)
resource "azurerm_subnet" "printers" {
  name                 = "printers"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.10.128/28"]
}

# Subnet: Servers (VLAN 50)
resource "azurerm_subnet" "servers" {
  name                 = "servers"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.10.144/29"]
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

resource "azurerm_subnet_network_security_group_association" "office_workstations" {
  subnet_id                 = azurerm_subnet.office_workstations.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "voip_phones" {
  subnet_id                 = azurerm_subnet.voip_phones.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "guest_wifi" {
  subnet_id                 = azurerm_subnet.guest_wifi.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "printers" {
  subnet_id                 = azurerm_subnet.printers.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "servers" {
  subnet_id                 = azurerm_subnet.servers.id
  network_security_group_id = azurerm_network_security_group.main.id
}
