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