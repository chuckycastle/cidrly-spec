#
# cidrly Network Configuration
# Plan: Campus Network Example
# Provider: GCP
# Generated: <timestamp>
#

variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "my-project"
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}
