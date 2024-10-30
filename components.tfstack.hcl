component "networking" {
  source = "./components/networking"
  providers = {
    aws = provider.aws.this
    hcp = provider.hcp  .this
  }
  inputs = {
    region = var.region
    # stack_id = var.stack_id
    aws_vpc_cidr = var.aws_vpc_cidr
    cloud_provider = var.cloud_provider
    hvn_id = var.hvn_id
    peering_id = var.peering_id
    route_id = var.route_id
  }
}


component "hcp_clusters" {
  source = "./components/hcp_clusters"
  providers = {
    hcp = provider.hcp.this
  }
  inputs = {
    # stack_id = var.stack_id
    hvn_id = component.networking.hvn_id
    # peering_id = component.networking.vpc_peer_id
    # peer_vpc_id = component.networking.vpc_peer_owner_id
    vault_tier = var.vault_tier
    boundary_tier = var.boundary_tier
    boundary_username = var.boundary_username
    boundary_cluster_id = var.boundary_cluster_id
    # boundary_password = var.boundary_password
    # cidr_block = var.aws_vpc_cidr
    # cloud_provider = var.cloud_provider
    region = var.region
    # route_id = var.route_id
    vault_cluster_id = var.vault_cluster_id
  }
}