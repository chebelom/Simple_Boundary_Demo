# terraform {
#   required_providers {

#     boundary = {
#       source  = "hashicorp/boundary"
#       version = "1.1.15"
#     }

#     vault = {
#       source  = "hashicorp/vault"
#       version = "3.17.0"
#     }
#   }
# }


# # Declare the provider for the HashiCorp Boundary resource to be managed by Terraform
# provider "boundary" {
#   # Use variables to provide values for the provider configuration
#   addr                   = ""
#   auth_method_id         = var.authmethod
#   auth_method_login_name = var.username
#   auth_method_password   = var.password
# }

# provider "vault" {
#   address = data.tfe_outputs.platform.values.vault_public_url
#   # token     = var.vault_token
#   namespace = "admin" # Set for HCP Vault
# }

# provider "aws" {
#   region = var.aws_region
# }

# # Remote Backend to obtain VPC details 
# data "tfe_outputs" "platform" {
#   organization = "hashicorp-italy"
#   workspace = "1_Platform"
# }