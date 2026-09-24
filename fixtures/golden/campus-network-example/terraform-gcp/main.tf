#
# cidrly Network Configuration
# Plan: Campus Network Example
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
  plan_name = "campus_network_example"
  labels = {
    managed_by = "cidrly"
    plan_name  = "campus_network_example"
  }
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = "${local.plan_name}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Subnetwork: Student WiFi (VLAN 30)
resource "google_compute_subnetwork" "student_wifi" {
  name          = "student_wifi"
  ip_cidr_range = "10.100.0.0/23"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Engineering Building (VLAN 10)
resource "google_compute_subnetwork" "engineering_building" {
  name          = "engineering_building"
  ip_cidr_range = "10.100.2.0/24"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Science Lab (VLAN 20)
resource "google_compute_subnetwork" "science_lab" {
  name          = "science_lab"
  ip_cidr_range = "10.100.3.0/24"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Guest WiFi (VLAN 50)
resource "google_compute_subnetwork" "guest_wifi" {
  name          = "guest_wifi"
  ip_cidr_range = "10.100.4.0/25"
  region        = var.region
  network       = google_compute_network.main.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Subnetwork: Administration (VLAN 40)
resource "google_compute_subnetwork" "administration" {
  name          = "administration"
  ip_cidr_range = "10.100.4.128/26"
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
    "10.100.0.0/23",
    "10.100.2.0/24",
    "10.100.3.0/24",
    "10.100.4.0/25",
    "10.100.4.128/26"
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
