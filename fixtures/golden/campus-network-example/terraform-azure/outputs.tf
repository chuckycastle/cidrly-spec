#
# cidrly Network Configuration
# Plan: Campus Network Example
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
    student_wifi = azurerm_subnet.student_wifi.id
    engineering_building = azurerm_subnet.engineering_building.id
    science_lab = azurerm_subnet.science_lab.id
    guest_wifi = azurerm_subnet.guest_wifi.id
    administration = azurerm_subnet.administration.id
  }
}

output "nsg_id" {
  description = "Network Security Group ID"
  value       = azurerm_network_security_group.main.id
}
