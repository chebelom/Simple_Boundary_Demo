variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_name" {
  type    = string
  default = "eks-cluster"
}

variable "boundary_username" {
  type = string
}

variable "boundary_password" {
  type = string
}


variable "aws_account_id" {
  type = string
}

variable "tfc_organization" {
  type = string
}