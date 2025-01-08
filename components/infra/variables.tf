variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "key_pair_name" {
  type    = string
}

variable "postgres_password" {
  type    = string
  default = "One1-siu-risotto"
}

variable "private_subnet1" {
  type = string
}

variable "public_subnet" {
  type = string
}

variable "private_sg" {
  type = string
}

variable "vault_public_url" {
    type = string
}
variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {
    Stacks     = "True"
    Component  = "Boundary"
    Environment = "Demo"
  }
}