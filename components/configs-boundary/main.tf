resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "Demo"
  auto_create_default_role = true
  auto_create_admin_role   = true
}

resource "boundary_scope" "project" {
  name                     = "My Demo project"
  description              = "Manage DB Prod Resources"
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "hcp_vault_cluster_admin_token" "token" {
  cluster_id = var.vault_cluster_id
}

resource "boundary_credential_store_vault" "vault" {
  name        = "vault"
  description = "My Vault credential store!"
  address     = var.boundary_address
  token       = hcp_vault_cluster_admin_token.token.token
  scope_id    = boundary_scope.project.id
  namespace   = "admin"
  depends_on = [ hcp_vault_cluster_admin_token.token ]
}