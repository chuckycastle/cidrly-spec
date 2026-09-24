#
# cidrly Network Configuration
# Plan: Data Center Example
# Provider: GCP
# Generated: <timestamp>
#

output "network_id" {
  description = "VPC Network ID"
  value       = google_compute_network.main.id
}

output "network_name" {
  description = "VPC Network name"
  value       = google_compute_network.main.name
}

output "network_self_link" {
  description = "VPC Network self link"
  value       = google_compute_network.main.self_link
}

output "subnetwork_ids" {
  description = "Map of subnetwork names to IDs"
  value = {
    web_tier = google_compute_subnetwork.web_tier.id
    application_tier = google_compute_subnetwork.application_tier.id
    database_tier = google_compute_subnetwork.database_tier.id
    storage_network = google_compute_subnetwork.storage_network.id
    management = google_compute_subnetwork.management.id
    backup_network = google_compute_subnetwork.backup_network.id
  }
}

output "subnetwork_self_links" {
  description = "Map of subnetwork names to self links"
  value = {
    web_tier = google_compute_subnetwork.web_tier.self_link
    application_tier = google_compute_subnetwork.application_tier.self_link
    database_tier = google_compute_subnetwork.database_tier.self_link
    storage_network = google_compute_subnetwork.storage_network.self_link
    management = google_compute_subnetwork.management.self_link
    backup_network = google_compute_subnetwork.backup_network.self_link
  }
}

output "nat_ip" {
  description = "Cloud NAT external IP (auto-allocated)"
  value       = google_compute_router_nat.main.nat_ips
}
