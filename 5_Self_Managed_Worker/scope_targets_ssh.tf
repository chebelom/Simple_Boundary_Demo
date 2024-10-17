data "boundary_scope" "org" {
  name     = "Demo"
  scope_id = "global"
}

/* Create a project scope within the "ops-org" organsation
Each org can contain multiple projects and projects are used to hold
infrastructure-related resources
*/
resource "boundary_scope" "project" {
  name                     = "Scenario4_ssh-private-project"
  description              = "SSH test machines"
  scope_id                 = data.boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "vault_token" "boundary_token" {
  no_default_policy = true
  period            = "24h"
  policies          = ["boundary-controller", "ssh"]
  no_parent         = true
  renewable         = true


  renew_min_lease = 43200
  renew_increment = 86400

  metadata = {
    "purpose" = "service-account-boundary-private"
  }
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 120" #Adding a bit of delay
  }
  depends_on = [aws_instance.boundary_upstream_worker]
}


resource "boundary_credential_store_vault" "vault" {
  name        = "certificates-store"
  description = "My second Vault credential store!"
  # address     = data.terraform_remote_state.local_backend.outputs.vault_public_url
  address   = data.tfe_outputs.platform.values.vault_private_url
  token     = vault_token.boundary_token.client_token
  scope_id  = boundary_scope.project.id
  namespace = "admin"
  # Adding worker filter to send request to Vault via Worker, worker that has access to Vault via HVN peering
  worker_filter = " \"worker1\" in \"/tags/type\" "
  # Introducing some delay to let the worker start up
  depends_on = [null_resource.delay]
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
  name        = "ssh-catalog-private"
  description = "SSH catalog"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "ssh" {
  name            = "ssh-host"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id
  address         = aws_instance.internal_target.private_ip
}

resource "boundary_host_set_static" "ssh" {
  name            = "ssh-host-set"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id

  host_ids = [
    boundary_host_static.ssh.id
  ]
}


resource "boundary_target" "ssh" {
  type                     = "ssh"
  name                     = "Scenario4_ssh-target-private"
  description              = "ssh-target"
  ingress_worker_filter    = " \"worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.ssh.id
  ]

  # Comment this to avoid brokering the credentials

  injected_application_credential_source_ids = [
    boundary_credential_library_vault_ssh_certificate.ssh.id
  ]

}

resource "boundary_alias_target" "scenario4_ssh_injection" {
  name           = "Scenario4_ssh_injection"
  description    = "Scenario4_ssh_injection"
  scope_id       = "global"
  value          = var.scenario4_alias
  destination_id = boundary_target.ssh.id
  #authorize_session_host_id = boundary_host_static.bar.id
}