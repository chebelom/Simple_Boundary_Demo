terraform {
  required_providers {

    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }

  }
}


provider "vault" {
  address = data.tfe_outputs.platform.values.vault_public_url
  # token = var.vault_token
  namespace = "admin" # Set for HCP Vault
}

# Remote Backend to obtain VPC details 
# data "terraform_remote_state" "local_backend" {
#   backend = "local"

#   config = {
#     path = "../../1_Plataforma/terraform.tfstate"
#   }
# }

data "tfe_outputs" "platform" {
  organization = "hashicorp-italy"
  workspace = "1_Platform"
}