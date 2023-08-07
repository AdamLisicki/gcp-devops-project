variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone for GKE cluster"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes per zone"
}

variable "machine_type" {
  type        = string
  description = "Type of the node compute engines."
}

variable "disk_size_gb" {
  type        = number
  description = "Size of the node's disk."
}

variable "disk_type" {
  type        = string
  description = "Type of the node's disk."
}