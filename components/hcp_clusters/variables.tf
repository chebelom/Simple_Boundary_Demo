variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
}

variable "boundary_cluster_id" {
  description = "The ID of the HCP Boundary cluster."
  type        = string
}

variable "boundary_username" {
  type = string
}


variable "vault_cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
}

variable "vault_tier" {
  description = "Tier of the HCP Vault cluster. Valid options for tiers."
  type        = string
}

variable "boundary_tier" {
  description = "Tier of the HCP Boundary cluster. Valid options for tiers."
  type        = string
}

# variable "cidr_block" {
#   type        = string
#   description = "VPC CIDR"
# }