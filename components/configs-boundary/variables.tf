variable "boundary_address" {
    type = string
}

variable "boundary_vault_token" {
    type = string
    sensitive = true  
}

variable "postgres_private_ip" {
    type = string
}

variable "vault_address" {
    type = string  
}

variable "vault_cluster_id" {
    type = string
}

variable "private_sg" {
    type = string
}

variable "aws_ssh_key" {
  type = string
}

variable "rec_worker_subnet" {
  type = string
}