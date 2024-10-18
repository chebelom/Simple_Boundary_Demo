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
    doormat = {
      source  = "doormat.hashicorp.services/hashicorp-security/doormat"
      version = "~> 0.0.13"
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
  token     = data.tfe_outputs.platform.values.vault_token
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

provider "kubernetes" {
  host                   = data.tfe_outputs.eks.values.cluster_endpoint
  cluster_ca_certificate = base64decode(data.tfe_outputs.eks.values.cluster_certificate_authority_data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.eks.values.cluster_name]
    command     = "aws"
  }
}

# Remote Backend to obtain VPC details 
data "tfe_outputs" "platform" {
  organization = var.tfc_organization
  workspace = "1_Platform"
}

data "tfe_outputs" "eks" {
  organization = var.tfc_organization
  workspace = "7-k8s"
}