#
# cidrly Network Configuration
# Plan: Branch Office Example
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
    office_workstations = google_compute_subnetwork.office_workstations.id
    voip_phones = google_compute_subnetwork.voip_phones.id
    guest_wifi = google_compute_subnetwork.guest_wifi.id
    printers = google_compute_subnetwork.printers.id
    servers = google_compute_subnetwork.servers.id
  }
}

output "subnetwork_self_links" {
  description = "Map of subnetwork names to self links"
  value = {
    office_workstations = google_compute_subnetwork.office_workstations.self_link
    voip_phones = google_compute_subnetwork.voip_phones.self_link
    guest_wifi = google_compute_subnetwork.guest_wifi.self_link
    printers = google_compute_subnetwork.printers.self_link
    servers = google_compute_subnetwork.servers.self_link
  }
}

output "nat_ip" {
  description = "Cloud NAT external IP (auto-allocated)"
  value       = google_compute_router_nat.main.nat_ips
}
