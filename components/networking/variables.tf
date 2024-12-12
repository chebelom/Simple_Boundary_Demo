variable "aws_vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
}

variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
}

variable "peering_id" {
  description = "The ID of the HCP peering connection."
  type        = string
}

# variable "peer_vpc_id" {
# }

variable "route_id" {
  description = "The ID of the HCP HVN route."
  type        = string
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "hvn_cidr_block" {
  type        = string
  description = "The CIDR range to create the HCP HVN with"
  default     = "172.25.16.0/20"
}