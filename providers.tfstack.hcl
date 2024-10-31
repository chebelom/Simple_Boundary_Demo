required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.70.0"
    }
    hcp = {
        source  = "hashicorp/hcp"
        version = "~> 0.97.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "~> 4.4.0"
    }
    boundary = {
      source = "hashicorp/boundary"
      version = "~> 1.1.15"
    }
}

provider "aws" "this" {
  config {
    region = var.region
    assume_role_with_web_identity {
      role_arn = var.aws_role_arn
      web_identity_token = var.aws_identity_token
    }
  }
}

provider "hcp" "this" {
  config {
    workload_identity {
      resource_name = var.hcp_workload_identity_provider
      token         = var.hcp_token
    }
  }
}

provider "vault" "this" {
  config {
    address = component.hcp_clusters.vault_public_url
    token = component.hcp_clusters.vault_token
    namespace = "admin"
  }
}

provider "boundary" "this" {
  config {
    addr = component.hcp_clusters.boundary_public_url
    auth_method_login_name = var.boundary_username
    auth_method_password = component.hcp_clusters.hcp_boundary_cluster_admin_password
  }
}