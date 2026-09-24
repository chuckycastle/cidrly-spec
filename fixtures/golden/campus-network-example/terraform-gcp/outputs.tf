#
# cidrly Network Configuration
# Plan: Campus Network Example
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
    student_wifi = google_compute_subnetwork.student_wifi.id
    engineering_building = google_compute_subnetwork.engineering_building.id
    science_lab = google_compute_subnetwork.science_lab.id
    guest_wifi = google_compute_subnetwork.guest_wifi.id
    administration = google_compute_subnetwork.administration.id
  }
}

output "subnetwork_self_links" {
  description = "Map of subnetwork names to self links"
  value = {
    student_wifi = google_compute_subnetwork.student_wifi.self_link
    engineering_building = google_compute_subnetwork.engineering_building.self_link
    science_lab = google_compute_subnetwork.science_lab.self_link
    guest_wifi = google_compute_subnetwork.guest_wifi.self_link
    administration = google_compute_subnetwork.administration.self_link
  }
}

output "nat_ip" {
  description = "Cloud NAT external IP (auto-allocated)"
  value       = google_compute_router_nat.main.nat_ips
}
