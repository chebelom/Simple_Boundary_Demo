terraform {
  required_providers {

    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.15"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }
  }
}


# Declare the provider for the HashiCorp Boundary resource to be managed by Terraform
provider "boundary" {
  # Use variables to provide values for the provider configuration
  addr                   = data.tfe_outputs.platform.values.boundary_public_url
  auth_method_login_name = var.boundary_username
  auth_method_password   = var.boundary_password
}

provider "vault" {
  address = data.tfe_outputs.platform.values.vault_public_url
  # token     = var.vault_token
  namespace = "admin" # Set for HCP Vault
}

# Declare the provider for the AWS resource to be managed by Terraform
provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  provider = doormat
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/tfc-doormat-role_7-k8s-config"
}

# Declare the provider for the AWS resource to be managed by Terraform
provider "aws" {
  region     = var.region
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
}

# Remote Backend to obtain VPC details 
data "tfe_outputs" "platform" {
  organization = var.tfc_organization
  workspace = "1_Platform"
}