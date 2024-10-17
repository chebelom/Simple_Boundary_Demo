resource "hcp_boundary_cluster" "boundary" {
  cluster_id = var.boundary_cluster_id
  username   = var.username
  password   = var.password
  tier       = var.boundary_tier
}