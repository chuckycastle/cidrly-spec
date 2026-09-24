#
# cidrly Network Configuration
# Plan: Data Center Example
# Provider: GCP
# Generated: <timestamp>
#

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  plan_name = "data_center_example"
  labels = {
    managed_by = "cidrly"
    plan_name  = "data_center_example"
  }
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = "${local.plan_name}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Subnetwork: Web Tier (VLAN 100)
resource "google_compute_subnetwork" "web_tier" {
  name          = "web_tier"
  ip_cidr_range = "172.16.0.0/26"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Application Tier (VLAN 110)
resource "google_compute_subnetwork" "application_tier" {
  name          = "application_tier"
  ip_cidr_range = "172.16.0.64/26"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Database Tier (VLAN 120)
resource "google_compute_subnetwork" "database_tier" {
  name          = "database_tier"
  ip_cidr_range = "172.16.0.128/27"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Storage Network (VLAN 130)
resource "google_compute_subnetwork" "storage_network" {
  name          = "storage_network"
  ip_cidr_range = "172.16.0.160/27"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Management (VLAN 140)
resource "google_compute_subnetwork" "management" {
  name          = "management"
  ip_cidr_range = "172.16.0.192/27"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Backup Network (VLAN 150)
resource "google_compute_subnetwork" "backup_network" {
  name          = "backup_network"
  ip_cidr_range = "172.16.0.224/28"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Firewall Rules

resource "google_compute_firewall" "allow_internal" {
  name    = "${local.plan_name}-allow-internal"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    "172.16.0.0/26",
    "172.16.0.64/26",
    "172.16.0.128/27",
    "172.16.0.160/27",
    "172.16.0.192/27",
    "172.16.0.224/28"
  ]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${local.plan_name}-allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Restrict to IAP for secure SSH
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-ssh"]
}

# Cloud Router for NAT
resource "google_compute_router" "main" {
  name    = "${local.plan_name}-router"
  region  = var.region
  network = google_compute_network.main.id
}

# Cloud NAT
resource "google_compute_router_nat" "main" {
  name                               = "${local.plan_name}-nat"
  router                             = google_compute_router.main.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
