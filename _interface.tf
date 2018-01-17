variable "network-workspace" {
  description = "The workspace that defines the network settings our instances will use."
  default     = "gcp-network-a"
}

variable "machine_type" {
  description = "The size of machine to deploy"
  default     = "g1-small"
}
