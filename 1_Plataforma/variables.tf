variable "boundary_cluster_id" {
  description = "The ID of the HCP Boundary cluster."
  type        = string
  default     = "boundary-cluster"
}

variable "boundary_username" {
  type = string
}

variable "boundary_password" {
  type = string
}

variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
  default     = "hcp-hvn"
}

variable "vault_cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
  default     = "vault-cluster"
}

variable "peering_id" {
  description = "The ID of the HCP peering connection."
  type        = string
  default     = "peering"
}

variable "route_id" {
  description = "The ID of the HCP HVN route."
  type        = string
  default     = "dhvn-route"
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
  default     = "aws"
}

variable "vault_tier" {
  description = "Tier of the HCP Vault cluster. Valid options for tiers."
  type        = string
  default     = "plus_small"
}

variable "boundary_tier" {
  description = "Tier of the HCP Boundary cluster. Valid options for tiers."
  type        = string
  default     = "Plus"
}

# # Remove if not rquired
# variable "datadog_api_key" {
#   type        = string
#   description = "Datadog API KEY"
# }

variable "aws_vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "172.31.0.0/16"
}

variable "aws_account_id" {
  type = string
}
