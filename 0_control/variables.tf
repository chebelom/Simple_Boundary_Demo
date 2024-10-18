variable "tfc_organization" {
  type = string
}

variable "tfc_project_id" {
  type = string
}

variable "repo_identifier" {
  type = string
}

variable "repo_branch" {
  type = string
}

variable "oauth_token_id" {
  type = string
}

variable "boundary_username" {
  type    = string
  default = "admin"
}

variable "boundary_password" {
  type      = string
  sensitive = true
}

variable "aws_account_id" {
  type = string
}
