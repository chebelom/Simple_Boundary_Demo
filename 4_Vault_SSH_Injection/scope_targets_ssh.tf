data "boundary_scope" "org" {
  name     = "Demo"
  scope_id = "global"
}

/* Create a project scope within the "ops-org" organsation
Each org can contain multiple projects and projects are used to hold
infrastructure-related resources
*/
resource "boundary_scope" "project" {
  name                     = "Scenario3_ssh-project"
  description              = "SSH test machines"
  scope_id                 = data.boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_credential_store_vault" "vault" {
  name        = "certificates-store"
  description = "My second Vault credential store!"
  address     = data.tfe_outputs.platform.values.vault_public_url
  token       = data.tfe_outputs.vault-config-4.values.boundary_token
  scope_id    = boundary_scope.project.id
  namespace   = "admin"
}

resource "boundary_credential_library_vault_ssh_certificate" "ssh" {
  name                = "certificates-library"
  description         = "Certificate Library"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "ssh-client-signer/sign/boundary-client" # change to Vault backend path
  username            = "ubuntu"
  key_type            = "ecdsa"
  key_bits            = 521

  extensions = {
    permit-pty = ""
  }
}



resource "boundary_host_catalog_static" "aws_instance" {
  name        = "ssh-catalog"
  description = "SSH catalog"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "ssh" {
  name            = "ssh-host"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id
  address         = aws_instance.ssh_injection_target.public_ip
}

resource "boundary_host_set_static" "ssh" {
  name            = "ssh-host-set"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id

  host_ids = [
    boundary_host_static.ssh.id
  ]
}


resource "boundary_target" "ssh" {
  type        = "ssh"
  name        = "Scenario3_ssh-target"
  description = "Scenario3_ssh-target"
  #egress_worker_filter     = " \"sm-egress-downstream-worker1\" in \"/tags/type\" "
  #ingress_worker_filter    = " \"sm-ingress-upstream-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.ssh.id
  ]

  # Comment this to avoid brokeing the credentials

  injected_application_credential_source_ids = [
    boundary_credential_library_vault_ssh_certificate.ssh.id
  ]

}


resource "boundary_alias_target" "scenario3_ssh_injection" {
  name           = "Scenario3_ssh_injection"
  description    = "Scenario3_ssh_injection"
  scope_id       = "global"
  value          = var.scenario3_alias
  destination_id = boundary_target.ssh.id
  #authorize_session_host_id = boundary_host_static.bar.id
}