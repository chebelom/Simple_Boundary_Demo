component "networking" {
  source = "./components/networking"
  providers = {
    aws = provider.aws.this
    # hcp = provider.hcp.this
  }
  inputs = {
    region = var.region
    # stack_id = var.stack_id
    aws_vpc_cidr = var.aws_vpc_cidr
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
    vault_cluster_tier = var.vault_tier
    boundary_cluster_tier = var.boundary_tier
    boundary_username = var.boundary_username
  }
}