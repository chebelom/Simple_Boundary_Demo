terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "~> 1.1.15"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "~> 0.97.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72.1"
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
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/tfc-doormat-role_2_first-target"
}

# Declare the provider for the AWS resource to be managed by Terraform
provider "aws" {
  region     = var.region
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
}

data "tfe_outputs" "platform" {
  organization = "hashicorp-italy"
  workspace = "1_Platform"
}

# Declare the provider for the HashiCorp Boundary resource to be managed by Terraform
provider "boundary" {
  addr = data.tfe_outputs.platform.values.boundary_public_url
  # auth_method_id         = var.authmethod
  auth_method_login_name = var.username
  auth_method_password   = var.password

}


