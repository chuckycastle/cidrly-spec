#
# cidrly Network Configuration
# Plan: Branch Office Example
# Provider: Azure
# Generated: <timestamp>
#

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    office_workstations = azurerm_subnet.office_workstations.id
    voip_phones = azurerm_subnet.voip_phones.id
    guest_wifi = azurerm_subnet.guest_wifi.id
    printers = azurerm_subnet.printers.id
    servers = azurerm_subnet.servers.id
  }
}

output "nsg_id" {
  description = "Network Security Group ID"
  value       = azurerm_network_security_group.main.id
}
