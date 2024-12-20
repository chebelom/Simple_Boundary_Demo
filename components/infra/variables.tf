variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "key_pair_name" {
  type    = string
  default = "stacks-ec2-key"
}

variable "postgres_password" {
  type    = string
  default = "One1-siu-risotto"
}

variable "private_subnet1" {
  type = string
}

variable "private_sg" {
  type = string
}

variable "boundary_address" {
  type = string
}

variable "boundary_rec_worker_activation_token" {
  type = string
  sensitive = true
}