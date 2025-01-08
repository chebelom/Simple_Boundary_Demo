resource "boundary_credential_store_vault" "vault_win" {
  name        = "vault-windows"
  description = "Vault cred store for windows!"
  address     = var.vault_address
  token       = var.boundary_vault_token_windows
  scope_id    = boundary_scope.project.id
  namespace   = "admin"
}

resource "boundary_credential_library_vault" "windows" {
  name                = "Vault KV"
  description         = "Vault KV for windows creds"
  credential_store_id = boundary_credential_store_vault.vault_win.id
  path                = "secrets/data/windows_secret" # change to Vault backend path
  http_method         = "GET"
}

resource "boundary_host_catalog_static" "aws_instance_w" {
  name        = "Windows Server"
  description = "Windows Server"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "win" {
  name            = "windows-host"
  host_catalog_id = boundary_host_catalog_static.aws_instance_w.id
  address         = var.windows_server_private_ip
}

resource "boundary_host_set_static" "win" {
  name            = "win-host-set"
  host_catalog_id = boundary_host_catalog_static.aws_instance_w.id

  host_ids = [
    boundary_host_static.win.id
  ]
}

resource "boundary_target" "win_rdp" {
  type                     = "tcp"
  name                     = "Windows RDP"
  description              = "Windows RDP Target"
  scope_id                 = boundary_scope.project.id
  egress_worker_filter     = " \"worker_ssh\" in \"/tags/type\" "
  session_connection_limit = -1
  default_port             = 3389
  host_source_ids = [
    boundary_host_set_static.win.id
  ]

  brokered_credential_source_ids = [
    boundary_credential_library_vault.windows.id
  ]

}

resource "boundary_target" "win_http" {
  type                     = "tcp"
  name                     = "Windows HTTP"
  description              = "Windows HTTP Target"
  scope_id                 = boundary_scope.project.id
  egress_worker_filter     = " \"worker_ssh\" in \"/tags/type\" "
  session_connection_limit = -1
  default_port             = 80
  host_source_ids = [
    boundary_host_set_static.win.id
  ]
  # Comment this to avoid brokeing the credentials
  /*
  brokered_credential_source_ids = [
    boundary_credential_library_vault.windows.id
  ]
  */
}

resource "boundary_alias_target" "win_rdp" {
  name           = "Windows RDP Alias"
  description    = "Windows RDP Alias"
  scope_id       = "global"
  value          = "rdp.boundary.demo"
  destination_id = boundary_target.win_rdp.id
}

resource "boundary_alias_target" "win_http" {
  name           = "Windows HTTP Alias"
  description    = "Windows HTTP Alias"
  scope_id       = "global"
  value          = "http-win.boundary.demo"
  destination_id = boundary_target.win_http.id
}