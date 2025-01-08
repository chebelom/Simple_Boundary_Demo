variable "boundary_address" {
    type = string
}

variable "boundary_vault_token_db" {
    type = string
    sensitive = true  
}

variable "boundary_vault_token_ssh" {
    type = string
    sensitive = true  
}

variable "boundary_vault_token_windows" {
    type = string
    sensitive = true  
}

variable "postgres_private_ip" {
    type = string
}

variable "ssh_inject_private_ip" {
    type = string  
}

variable "windows_server_private_ip" {
  type = string
}

variable "vault_address" {
    type = string  
}

variable "vault_cluster_id" {
    type = string
}

variable "private_sg" {
    type = string
}

variable "aws_ssh_key" {
  type = string
}

variable "rec_worker_subnet" {
  type = string
}

variable "region" {
  description = "The region of the recording bucket in AWS."
  type        = string
}

variable "aws_recording_bucket_name" {
  description = "The name of the AWS S3 bucket to store Boundary session recordings."
  type        = string
}

variable "aws_iam_access_key_boundary_session_recording_id" {
  description = "The AWS IAM Access Key ID for the Boundary Session Recording bucket."
  type        = string
}

variable "aws_iam_access_key_boundary_session_recording_secret" {
  description = "The AWS IAM Access Key Secret for the Boundary Session Recording bucket."
  type        = string
  sensitive = true
}