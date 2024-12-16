output "boundary_vault_token" {
    value = vault_token.boundary_token_kv.client_token
    sensitive = true
}