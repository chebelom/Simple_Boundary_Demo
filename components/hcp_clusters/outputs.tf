output "vault_private_url" {
  value = hcp_vault_cluster.hcp_vault.vault_private_endpoint_url
}

output "vault_public_url" {
  value = hcp_vault_cluster.hcp_vault.vault_public_endpoint_url
}

output "boundary_public_url" {
  value = hcp_boundary_cluster.boundary.cluster_url
}

output "peering_id" {
  value = hcp_aws_network_peering.peer.provider_peering_id
}