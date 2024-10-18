variable "boundary_username" {
  type = string
}

variable "boundary_password" {
  type = string
}


variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "eu-west-2"
}
variable "authmethod" {
  type = string
}

variable "scenario4_alias" {
  type        = string
  default = "scenario4.ssh.injected.boundary.demo"
}

variable "aws_account_id" {
  type = string
}

variable "tfc_organization" {
  type = string
}
