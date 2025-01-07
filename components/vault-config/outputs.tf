output "boundary_vault_token" {
    value = vault_token.boundary_token_dba.client_token
    sensitive = true
}

output "vault_ssh_public_key" {
    value = vault_ssh_secret_backend_ca.boundary.public_key
}