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
  }
}

# Declare the provider for the AWS resource to be managed by Terraform
provider "aws" {
  region = var.region
}

# Declare the provider for the HashiCorp Boundary resource to be managed by Terraform
provider "boundary" {
  # Use variables to provide values for the provider configuration
  addr                   = ""
  auth_method_id         = var.authmethod
  auth_method_login_name = var.username
  auth_method_password   = var.password
}

provider "vault" {
  # address = data.terraform_remote_state.local_backend.outputs.vault_public_url
  address = data.tfe_outputs.platform.values.vault_public_url
  # token     = var.vault_token
  namespace = "admin" # Set for HCP Vault
}

# Remote Backend to obtain VPC details 
# data "terraform_remote_state" "local_backend" {
#   backend = "local"

#   config = {
#     path = "../1_Plataforma/terraform.tfstate"
#   }
# }

data "tfe_outputs" "platform" {
  organization = "hashicorp-italy"
  workspace = "1_Platform"
}

data "tfe_outputs" "first-target-2" {
  organization = "hashicorp-italy"
  workspace = "2_First_target"
}