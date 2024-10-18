terraform {
  required_providers {

    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.15"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.2"
    }
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.13"
    }
  }
}

provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  provider = doormat
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/tfc-doormat-role_3-creds-brokering"
}

# Declare the provider for the AWS resource to be managed by Terraform
provider "aws" {
  region     = var.region
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
}

# Declare the provider for the HashiCorp Boundary resource to be managed by Terraform
provider "boundary" {
  addr                   = data.tfe_outputs.platform.values.boundary_public_url
  auth_method_login_name = var.username
  auth_method_password   = var.password
}

resource "hcp_vault_cluster_admin_token" "root_token" {
  cluster_id = data.tfe_outputs.platform.values.vault_cluster_id
}

provider "vault" {
  address = data.tfe_outputs.platform.values.vault_public_url
  namespace = "admin" # Set for HCP Vault
  token = hcp_vault_cluster_admin_token.root_token.token
}

data "tfe_outputs" "platform" {
  organization = vat.tfc_organization
  workspace = "1_Platform"
}

data "tfe_outputs" "first-target-2" {
  organization = var.tfc_organization
  workspace = "2_first-target"
}