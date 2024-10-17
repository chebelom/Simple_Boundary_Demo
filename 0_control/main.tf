terraform {
  required_providers {
    tfe = {
      version = "~> 0.59.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "tfe" {}


# resource "tfe_project" "project" {
#   organization = var.tfc_organization
#   name = var.tfc_project_name
# }

# variable sets
resource "tfe_variable_set" "boundary-varset" {
  name          = "Simple Boundary Demo Varset"
  description   = "Simple Boundary Demo Varset."
  organization  = var.tfc_organization
}

resource "tfe_project_variable_set" "boundary" {
  project_id    = var.tfc_project_id
  variable_set_id = tfe_variable_set.boundary-varset.id
}

resource "tfe_variable" "username" {
  key             = "username"
  value           = var.boundary_username
  category        = "terraform"
  description     = "Boundary dataplane admin username"
  variable_set_id = tfe_variable_set.boundary-varset.id
}

resource "tfe_variable" "password" {
  key             = "password"
  value           = var.boundary_password
  category        = "terraform"
  description     = "Boundary dataplane admin password"
  variable_set_id = tfe_variable_set.boundary-varset.id
}

resource "tfe_variable" "region" {
  key             = "region"
  value           = "eu-west-3"
  category        = "terraform"
  description     = "AWS region"
  variable_set_id = tfe_variable_set.boundary-varset.id
}

# workspace definitions
resource "tfe_workspace" "platform" {
  name          = "1_platform"
  organization  = var.tfc_organization
  project_id    = var.tfc_project_id

  vcs_repo {
    identifier = var.repo_identifier
    oauth_token_id = var.oauth_token_id
    branch = var.repo_branch
  }

  working_directory = "1_Plataforma"
  queue_all_runs = false
  assessments_enabled = false
  global_remote_state = true
}


# workspace runs
resource "tfe_workspace_run" "platform" {
  workspace_id    = tfe_workspace.platform.id

  apply {
    manual_confirm    = false
    wait_for_run      = true
    retry_attempts    = 5
    retry_backoff_min = 5
  }
  destroy {
    manual_confirm    = false
    wait_for_run      = true
    retry_attempts    = 5
    retry_backoff_min = 5
  }
}

# workspace definitions
resource "tfe_workspace" "first-target" {
  name          = "2_first_target"
  organization  = var.tfc_organization
  project_id    = var.tfc_project_id

  vcs_repo {
    identifier = var.repo_identifier
    oauth_token_id = var.oauth_token_id
    branch = var.repo_branch
  }

  working_directory = "2_First_target"
  queue_all_runs = false
  assessments_enabled = false
  global_remote_state = true
}


# workspace runs
resource "tfe_workspace_run" "first_target" {
  workspace_id    = tfe_workspace.first-target.id

  apply {
    manual_confirm    = false
    wait_for_run      = true
    retry_attempts    = 5
    retry_backoff_min = 5
  }
  destroy {
    manual_confirm    = false
    wait_for_run      = true
    retry_attempts    = 5
    retry_backoff_min = 5
  }
}