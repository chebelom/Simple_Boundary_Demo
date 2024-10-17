resource "hcp_boundary_cluster" "boundary" {
  cluster_id = var.boundary_cluster_id
  username   = var.boundary_username
  password   = var.boundary_password
  tier       = var.boundary_tier
}