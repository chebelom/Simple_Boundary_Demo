output "boundary_vault_token_db" {
    value = vault_token.boundary_token_dba.client_token
    sensitive = true
}

output "boundary_vault_token_ssh" {
    value = vault_token.boundary_token_ssh.client_token
    sensitive = true
}

output "boundary_vault_token_windows" {
    value = vault_token.boundary_vault_token_windows.client_token
    sensitive = true
}

output "vault_ssh_public_key" {
    value = vault_ssh_secret_backend_ca.boundary.public_key
}