#
# cidrly Network Configuration
# Plan: Data Center Example
# Provider: AWS
# Generated: <timestamp>
#

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    web_tier = aws_subnet.web_tier.id
    application_tier = aws_subnet.application_tier.id
    database_tier = aws_subnet.database_tier.id
    storage_network = aws_subnet.storage_network.id
    management = aws_subnet.management.id
    backup_network = aws_subnet.backup_network.id
  }
}

output "subnet_cidrs" {
  description = "Map of subnet names to CIDR blocks"
  value = {
    web_tier = aws_subnet.web_tier.cidr_block
    application_tier = aws_subnet.application_tier.cidr_block
    database_tier = aws_subnet.database_tier.cidr_block
    storage_network = aws_subnet.storage_network.cidr_block
    management = aws_subnet.management.cidr_block
    backup_network = aws_subnet.backup_network.cidr_block
  }
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.main.id
}
