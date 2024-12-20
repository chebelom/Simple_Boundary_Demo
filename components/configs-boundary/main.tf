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

resource "boundary_credential_store_vault" "vault" {
  name        = "vault"
  description = "My Vault credential store!"
  address     = var.vault_address
  token       = var.boundary_vault_token
  scope_id    = boundary_scope.project.id
  namespace   = "admin"
}