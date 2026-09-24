#
# cidrly Network Configuration
# Plan: Campus Network Example
# Provider: Azure
# Generated: <timestamp>
#

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "cidrly-network-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}
