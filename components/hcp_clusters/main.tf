
## here I use HVS, but this could be set in a varset
data "hcp_vault_secrets_secret" "boundary_password" {
  app_name    = "stacks-boundary"
  secret_name = "boundary_password"
}

# resource "hcp_hvn" "hvn" {
#   hvn_id         = var.hvn_id
#   cloud_provider = var.cloud_provider
#   region         = var.region
# }

# resource "hcp_aws_network_peering" "peer" {
#   hvn_id          = hcp_hvn.hvn.hvn_id
#   peering_id      = var.peering_id
#   peer_vpc_id     = var.peering_id
#   peer_account_id = var.peer_vpc_id
#   peer_vpc_region = var.region
# }

# resource "hcp_hvn_route" "peer_route" {
#   hvn_link         = hcp_hvn.hvn.self_link
#   hvn_route_id     = var.route_id
#   destination_cidr = var.cidr_block
#   target_link      = hcp_aws_network_peering.peer.self_link
# }

resource "hcp_boundary_cluster" "boundary" {
  cluster_id = var.boundary_cluster_id
  username   = var.boundary_username
  password   = data.hcp_vault_secrets_secret.boundary_password.secret_value
  tier       = var.boundary_tier
}

resource "hcp_vault_cluster" "hcp_vault" {
  hvn_id          = var.hvn_id
  cluster_id      = var.vault_cluster_id
  tier            = var.vault_tier
  public_endpoint = true
}

resource "hcp_vault_cluster_admin_token" "token" {
  cluster_id = var.vault_cluster_id
  depends_on = [hcp_vault_cluster.hcp_vault]
}