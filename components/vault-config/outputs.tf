output "boundary_vault_token" {
    value = vault_token.boundary_token_dba.client_token
    sensitive = true
}