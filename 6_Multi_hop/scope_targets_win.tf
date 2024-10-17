data "boundary_scope" "org" {
  name     = "Demo"
  scope_id = "global"
}

/* Create a project scope within the "ops-org" organsation
Each org can contain multiple projects and projects are used to hold
infrastructure-related resources
*/
resource "boundary_scope" "project_w" {
  name                     = "Scenario5_win-private-multi-project"
  description              = "win test machines"
  scope_id                 = data.boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}



resource "boundary_host_catalog_static" "aws_instance_w" {
  name        = "win-catalog-private"
  description = "win catalog"
  scope_id    = boundary_scope.project_w.id
}

resource "boundary_host_static" "win" {
  name            = "win-host"
  host_catalog_id = boundary_host_catalog_static.aws_instance_w.id
  address         = aws_instance.windows-server.private_ip
}

resource "boundary_host_set_static" "win" {
  name            = "win-host-set"
  host_catalog_id = boundary_host_catalog_static.aws_instance_w.id

  host_ids = [
    boundary_host_static.win.id
  ]
}

resource "boundary_credential_store_static" "example" {
  name        = "example_static_credential_store"
  description = "Credential Store for First Target"
  scope_id    = boundary_scope.project_w.id
}

resource "boundary_credential_username_password" "example" {
  name                = "RDP Credentials"
  description         = "Credentials for Windows Host"
  credential_store_id = boundary_credential_store_static.example.id
  username            = "Administrator"
  password            = rsadecrypt(aws_instance.windows-server.password_data, data.tfe_outputs.first-target-2.values.ssh-key-private)

}

resource "boundary_target" "win" {
  type                     = "tcp"
  name                     = "Scenario5_win-rdp-target-private-multi"
  description              = "win-rdp- target"
  egress_worker_filter     = " \"worker-multi\" in \"/tags/type\" "
  ingress_worker_filter    = " \"true\" in \"/tags/boundary.cloud.hashicorp.com:managed\" "
  scope_id                 = boundary_scope.project_w.id
  session_connection_limit = -1
  default_port             = 3389
  host_source_ids = [
    boundary_host_set_static.win.id
  ]

  # Comment this to avoid brokeing the credentials
  brokered_credential_source_ids = [
    boundary_credential_username_password.example.id
  ]
}



resource "boundary_target" "win_http" {
  type                 = "tcp"
  name                 = "Scenario5_win-http-target-private-multi"
  description          = "win-http-target"
  egress_worker_filter = " \"worker-multi\" in \"/tags/type\" "
  # ingress_worker_filter    = " \"true\" in \"/tags/boundary.cloud.hashicorp.com:managed\" "
  ingress_worker_filter    = " \"worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project_w.id
  session_connection_limit = -1
  default_port             = 80
  host_source_ids = [
    boundary_host_set_static.win.id
  ]

  # Comment this to avoid brokeing the credentials
  /*
  injected_application_credential_source_ids = [
    boundary_credential_library_vault_ssh_certificate.ssh.id
  ]
  */
}

resource "boundary_alias_target" "scenario5_rdp_injection" {
  name           = "Scenario5_rdp_injection"
  description    = "Scenario5_rdp_injection"
  scope_id       = "global"
  value          = var.scenario5_rdp_alias
  destination_id = boundary_target.win.id
  #authorize_session_host_id = boundary_host_static.bar.id
}