# variable "vault_cluster_id" {
#   description = "The ID of the HCP Vault cluster."
#   type        = string
# }


variable "postgres_private_ip" {
  type = string
}

variable "win_password_data" {
  type = string
  sensitive = true
}

variable "ssh_key_private" {
  type = string
  sensitive = true
}