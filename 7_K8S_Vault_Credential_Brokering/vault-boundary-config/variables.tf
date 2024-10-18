variable "aws_region" {
  description = "AWS region"
  type        = string
}

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

variable "scenario6_alias" {
  type = string
  default = "scenario6.k8s.boundary.demo"
}

variable "aws_account_id" {
  type = string
}

variable "tfc_organization" {
  type = string
}