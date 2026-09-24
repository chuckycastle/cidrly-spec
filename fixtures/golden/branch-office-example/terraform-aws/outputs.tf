#
# cidrly Network Configuration
# Plan: Branch Office Example
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
    office_workstations = aws_subnet.office_workstations.id
    voip_phones = aws_subnet.voip_phones.id
    guest_wifi = aws_subnet.guest_wifi.id
    printers = aws_subnet.printers.id
    servers = aws_subnet.servers.id
  }
}

output "subnet_cidrs" {
  description = "Map of subnet names to CIDR blocks"
  value = {
    office_workstations = aws_subnet.office_workstations.cidr_block
    voip_phones = aws_subnet.voip_phones.cidr_block
    guest_wifi = aws_subnet.guest_wifi.cidr_block
    printers = aws_subnet.printers.cidr_block
    servers = aws_subnet.servers.cidr_block
  }
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.main.id
}
