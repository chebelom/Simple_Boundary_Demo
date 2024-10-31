output "vault_private_url" {
  value = hcp_vault_cluster.hcp_vault.vault_private_endpoint_url
}

output "vault_public_url" {
  value = hcp_vault_cluster.hcp_vault.vault_public_endpoint_url
}

output "boundary_public_url" {
  value = hcp_boundary_cluster.boundary.cluster_url
}

output "vault_token" {
  value = hcp_vault_cluster_admin_token.token.token
  sensitive = true
}

output "hcp_boundary_cluster_admin_password" {
  value = data.hcp_vault_secrets_secret.boundary_password.secret_value
  sensitive = true
}