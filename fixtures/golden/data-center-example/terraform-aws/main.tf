#
# cidrly Network Configuration
# Plan: Data Center Example
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
  plan_name = "data_center_example"
  base_cidr = "172.16.0.0/24"
  tags = {
    ManagedBy = "cidrly"
    PlanName  = "Data Center Example"
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

# Subnet: Web Tier (VLAN 100)
resource "aws_subnet" "web_tier" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.0.0/26"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "web_tier"
    VlanId = "100"
  })
}

# Subnet: Application Tier (VLAN 110)
resource "aws_subnet" "application_tier" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.0.64/26"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "application_tier"
    VlanId = "110"
  })
}

# Subnet: Database Tier (VLAN 120)
resource "aws_subnet" "database_tier" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.0.128/27"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "database_tier"
    VlanId = "120"
  })
}

# Subnet: Storage Network (VLAN 130)
resource "aws_subnet" "storage_network" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.0.160/27"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "storage_network"
    VlanId = "130"
  })
}

# Subnet: Management (VLAN 140)
resource "aws_subnet" "management" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.0.192/27"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "management"
    VlanId = "140"
  })
}

# Subnet: Backup Network (VLAN 150)
resource "aws_subnet" "backup_network" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.0.224/28"
  availability_zone = "${var.aws_region}a"

  tags = merge(local.tags, {
    Name   = "backup_network"
    VlanId = "150"
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

resource "aws_route_table_association" "web_tier" {
  subnet_id      = aws_subnet.web_tier.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "application_tier" {
  subnet_id      = aws_subnet.application_tier.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "database_tier" {
  subnet_id      = aws_subnet.database_tier.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "storage_network" {
  subnet_id      = aws_subnet.storage_network.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "management" {
  subnet_id      = aws_subnet.management.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "backup_network" {
  subnet_id      = aws_subnet.backup_network.id
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
