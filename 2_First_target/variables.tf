variable "username" {
  type = string
  default = "admin"
}

variable "password" {
  type = string
  default =  "SuperSecret123!"
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "eu-west-2"
}

variable "key_pair_name" {
  type = string
  default = "demo-boundary-keys"
}

# variable "authmethod" {
#   type = string
# }


variable "scenario1_alias" {
  type        = string
  description = "Alias for first target"
}

variable "aws_account_id" {
  type = string
}