# Declare the required providers and their version constraints for this Terraform configuration
terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.15"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "0.97.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "hcp" {
}

provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  provider = doormat
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/tfc-doormat-role_2_firsttarget"
}