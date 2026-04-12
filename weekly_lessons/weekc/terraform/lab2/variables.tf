variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Primary region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Primary zone"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "primary"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "main"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "private"
}

variable "node_machine_type" {
  description = "Machine type for node pools"
  type        = string
  default     = "e2-standard-2"
}

variable "general_node_count" {
  description = "Node count for general pool"
  type        = number
  default     = 1
}
