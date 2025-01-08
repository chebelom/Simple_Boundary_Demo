variable "boundary_address" {
    type = string
}

variable "boundary_vault_token_db" {
    type = string
    sensitive = true  
}

variable "boundary_vault_token_ssh" {
    type = string
    sensitive = true  
}

variable "boundary_vault_token_windows" {
    type = string
    sensitive = true  
}

variable "postgres_private_ip" {
    type = string
}

variable "ssh_inject_private_ip" {
    type = string  
}

variable "windows_server_private_ip" {
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