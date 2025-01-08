component "networking" {
  source = "./components/networking"
  providers = {
    aws = provider.aws.this
    hcp = provider.hcp.this
  }
  inputs = {
    region         = var.region
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
    hvn_id              = component.networking.hvn_id
    vault_tier          = var.vault_tier
    boundary_tier       = var.boundary_tier
    boundary_username   = var.boundary_username
    boundary_cluster_id = var.boundary_cluster_id
    region              = var.region
    vault_cluster_id    = var.vault_cluster_id
  }
}


component "infra" {
  source = "./components/infra"
  providers = {
    aws       = provider.aws.this
    tls       = provider.tls.this
    time      = provider.time.this
    cloudinit = provider.cloudinit.this
    http = provider.http.this
  }
  inputs = {
    region               = var.region
    boundary_username    = var.boundary_username
    boundary_cluster_id  = var.boundary_cluster_id
    private_sg           = component.networking.private_sg
    private_subnet1      = component.networking.private_subnet1
    public_subnet = component.networking.public_subnet1
    key_pair_name        = var.key_pair_name
    vault_public_url         = component.hcp_clusters.vault_public_url
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

# removed {
#  source = "./components/configs-boundary"
#  from = component.boundary
#   providers = {
#     aws       = provider.aws.this
#     boundary  = provider.boundary.this
#     cloudinit = provider.cloudinit.this
#     null = provider.null.this
#   }
# }

component "boundary" {
  source = "./components/configs-boundary"
  providers = {
    aws       = provider.aws.this
    boundary  = provider.boundary.this
    cloudinit = provider.cloudinit.this
    # null = provider.null.this
  }
  inputs = {
    boundary_address      = component.hcp_clusters.boundary_public_url
    boundary_vault_token_db = component.vault-config.boundary_vault_token_db
    boundary_vault_token_ssh = component.vault-config.boundary_vault_token_ssh
    boundary_vault_token_windows = component.vault-config.boundary_vault_token_windows
    postgres_private_ip   = component.infra.postgres_private_ip
    vault_address         = component.hcp_clusters.vault_public_url
    vault_cluster_id      = var.vault_cluster_id
    aws_ssh_key           = var.key_pair_name
    private_sg            = component.networking.private_sg
    rec_worker_subnet     = component.networking.private_subnet1
    ssh_inject_private_ip = component.infra.ssh_inject_private_ip
    windows_server_private_ip = component.infra.windows_private_ip
  }
}