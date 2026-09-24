#
# cidrly Network Configuration
# Plan: Campus Network Example
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
    student_wifi = aws_subnet.student_wifi.id
    engineering_building = aws_subnet.engineering_building.id
    science_lab = aws_subnet.science_lab.id
    guest_wifi = aws_subnet.guest_wifi.id
    administration = aws_subnet.administration.id
  }
}

output "subnet_cidrs" {
  description = "Map of subnet names to CIDR blocks"
  value = {
    student_wifi = aws_subnet.student_wifi.cidr_block
    engineering_building = aws_subnet.engineering_building.cidr_block
    science_lab = aws_subnet.science_lab.cidr_block
    guest_wifi = aws_subnet.guest_wifi.cidr_block
    administration = aws_subnet.administration.cidr_block
  }
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.main.id
}
