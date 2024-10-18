variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "postgres_password" {
  type = string
  default = "One1-siu-risotto"
}

variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
}

variable "windows_instance_name" {
  type        = string
  description = "EC2 instance name for Windows Server"
  default     = "tfwinsrv01"
}

variable "key_pair_name" {
  type = string
  default = "demo-boundary-keys"
}

variable "scenario2_alias_dba" {
  type    = string
  default = "scenario2.dba.boundary.demo"
}

variable "scenario2_alias_dbanalyst" {
  type    = string
  default = "scenario2.dbanalyst.boundary.demo"
}

variable "scenario2_alias_win_rdp" {
  type    = string
  default = "scenario2.winrdp.boundary.demo"
}

variable "aws_account_id" {
  type = string
}