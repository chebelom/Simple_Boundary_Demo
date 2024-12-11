## AUTH VARS

variable "aws_role_arn" {
  type = string
}

variable "aws_identity_token" {
  type      = string
  ephemeral = true
}

# variable "hcp_project_id" {
#     type = string
# }

# variable "hcp_sp_name" {
#     type = string 
# }

# variable "hcp_wif_name" {
#     type = string
# }

variable "hcp_token" {
  type      = string
  ephemeral = true
}

variable "hcp_workload_identity_provider" {
  type = string
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "eu-west-1"
}

## HCP VARS
variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
  default     = "aws"
}

variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
  default     = "stacks-hcp-hvn"
}

variable "peering_id" {
  description = "The ID of the HCP peering connection."
  type        = string
  default     = "stacks-peering"
}
# variable "peer_vpc_id" {
#   type = string
# }

variable "route_id" {
  description = "The ID of the HCP HVN route."
  type        = string
  default     = "stacks-dhvn-route"
}

variable "boundary_cluster_id" {
  description = "The ID of the HCP Boundary cluster."
  type        = string
  default     = "stacks-boundary-cluster"
}

variable "boundary_username" {
  type    = string
  default = "admin"
}

# variable "boundary_password" {
#   type = string
# }

variable "vault_cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
  default     = "stacks-vault-cluster"
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

## AWS VARS

variable "aws_vpc_cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "172.31.0.0/16"
}