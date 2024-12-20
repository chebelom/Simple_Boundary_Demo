component "networking" {
  source = "./components/networking"
  providers = {
    aws = provider.aws.this
    hcp = provider.hcp.this
  }
  inputs = {
    region = var.region
    aws_vpc_cidr   = var.aws_vpc_cidr
    cloud_provider = var.cloud_provider
    hvn_id         = var.hvn_id
    peering_id     = var.peering_id
    route_id       = var.route_id
  }
}


component "hcp_clusters" {
  source = "./components/hcp_clusters"
  providers = {
    hcp = provider.hcp.this
  }
  inputs = {
    hvn_id = component.networking.hvn_id
    vault_tier          = var.vault_tier
    boundary_tier       = var.boundary_tier
    boundary_username   = var.boundary_username
    boundary_cluster_id = var.boundary_cluster_id
    region = var.region
    vault_cluster_id = var.vault_cluster_id
  }
}
component "infra" {
  source = "./components/infra"
  providers = {
    aws       = provider.aws.this
    tls       = provider.tls.this
    time      = provider.time.this
    cloudinit = provider.cloudinit.this
  }
  inputs = {
    region              = var.region
    boundary_username   = var.boundary_username
    boundary_cluster_id = var.boundary_cluster_id
    boundary_address =  component.hcp_clusters.boundary_public_url
    boundary_rec_worker_activation_token = component.boundary.boundary_rec_worker_activation_token
    private_sg          = component.networking.private_sg
    private_subnet1     = component.networking.private_subnet1
  }
}

component "vault-config" {
  source = "./components/vault-config"
  providers = {
    vault = provider.vault.this
  }
  inputs = {
    ssh_key_private     = component.infra.ssh_key_private
    win_password_data   = component.infra.win_password_data
    postgres_private_ip = component.infra.postgres_private_ip
  }
}

component "boundary"  {
  source = "./components/configs-boundary"
    providers = {
      boundary = provider.boundary.this
  }
  inputs = {
    boundary_address = component.hcp_clusters.boundary_public_url
    boundary_vault_token = component.vault-config.boundary_vault_token
    postgres_private_ip = component.infra.postgres_private_ip
    vault_address = component.hcp_clusters.vault_public_url
    vault_cluster_id = var.vault_cluster_id
  }
}