terraform {
  required_providers {

    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.15"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.11.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0.9.1"
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
  address = ""
  # token     = var.vault_token
  namespace = "admin" # Set for HCP Vault
}

# Remote Backend to obtain Vault Token 
data "tfe_outputs" "vault-config-4" {
  organization = "hashicorp-italy"
  workspace = "4_Vault_SSH_Injection-vault-config"
}

# base64encode("${data.tfe_outputs.vault-config-4.values.vault_ca}")
