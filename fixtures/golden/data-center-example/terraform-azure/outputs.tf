#
# cidrly Network Configuration
# Plan: Data Center Example
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
    web_tier = azurerm_subnet.web_tier.id
    application_tier = azurerm_subnet.application_tier.id
    database_tier = azurerm_subnet.database_tier.id
    storage_network = azurerm_subnet.storage_network.id
    management = azurerm_subnet.management.id
    backup_network = azurerm_subnet.backup_network.id
  }
}

output "nsg_id" {
  description = "Network Security Group ID"
  value       = azurerm_network_security_group.main.id
}
