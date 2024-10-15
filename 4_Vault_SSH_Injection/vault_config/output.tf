
output "boundary_token" {
  value     = vault_token.boundary_token.client_token
  sensitive = true
}

output "vault_ca" {
  value = vault_ssh_secret_backend_ca.public_key
}