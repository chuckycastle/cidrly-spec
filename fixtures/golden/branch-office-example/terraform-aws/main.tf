#
# cidrly Network Configuration
# Plan: Branch Office Example
# Provider: AWS
# Generated: <timestamp>
#

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  plan_name = "branch_office_example"
  base_cidr = "192.168.10.0/24"
  tags = {
    ManagedBy = "cidrly"
    PlanName  = "Branch Office Example"
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = local.base_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.tags, {
    Name = "${local.plan_name}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.tags, {
    Name = "${local.plan_name}-igw"
  })
}

# Subnet: Office Workstations (VLAN 10)
resource "aws_subnet" "office_workstations" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.10.0/26"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "office_workstations"
    VlanId = "10"
  })
}

# Subnet: VoIP Phones (VLAN 20)
resource "aws_subnet" "voip_phones" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.10.64/27"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "voip_phones"
    VlanId = "20"
  })
}

# Subnet: Guest WiFi (VLAN 30)
resource "aws_subnet" "guest_wifi" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.10.96/27"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "guest_wifi"
    VlanId = "30"
  })
}

# Subnet: Printers (VLAN 40)
resource "aws_subnet" "printers" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.10.128/28"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "printers"
    VlanId = "40"
  })
}

# Subnet: Servers (VLAN 50)
resource "aws_subnet" "servers" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.10.144/29"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "servers"
    VlanId = "50"
  })
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.tags, {
    Name = "${local.plan_name}-rt"
  })
}

resource "aws_route_table_association" "office_workstations" {
  subnet_id      = aws_subnet.office_workstations.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "voip_phones" {
  subnet_id      = aws_subnet.voip_phones.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "guest_wifi" {
  subnet_id      = aws_subnet.guest_wifi.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "printers" {
  subnet_id      = aws_subnet.printers.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "servers" {
  subnet_id      = aws_subnet.servers.id
  route_table_id = aws_route_table.main.id
}

# Security Group
resource "aws_security_group" "main" {
  name        = "${local.plan_name}-sg"
  description = "Security group for ${local.plan_name}"
  vpc_id      = aws_vpc.main.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.base_cidr]
  }

  # Allow HTTPS from VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.base_cidr]
  }

  tags = merge(local.tags, {
    Name = "${local.plan_name}-sg"
  })
}
