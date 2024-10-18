variable "boundary_username" {
  type = string
}

variable "boundary_password" {
  type = string
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "authmethod" {
  type = string
}

variable "scenario3_alias" {
  type        = string
  description = "Alias for first target"
  default = "scenario3.ssh.injected.boundary.demo"
}

variable "aws_account_id" {
  type = string
}

variable "tfc_organization" {
  type = string
}
