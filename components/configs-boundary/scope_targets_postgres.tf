resource "boundary_credential_library_vault" "dba" {
  name                = "northwind dba"
  description         = "northwind dba"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "database/creds/dba" # change to Vault backend path
  http_method         = "GET"
}

resource "boundary_credential_library_vault" "analyst" {
  name                = "northwind analyst"
  description         = "northwind analyst"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "database/creds/analyst" # change to Vault backend path
  http_method         = "GET"
}

resource "boundary_host_catalog_static" "aws_instance" {
  name        = "db-catalog"
  description = "DB catalog"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "db" {
  name            = "postgres-host"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id
  address         = var.postgres_private_ip
}

resource "boundary_host_set_static" "db" {
  name            = "db-host-set"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id

  host_ids = [
    boundary_host_static.db.id
  ]
}

resource "boundary_target" "dba" {
  type        = "tcp"
  name        = "Database Admin"
  description = "DBA Target"
  #egress_worker_filter     = " \"sm-egress-downstream-worker1\" in \"/tags/type\" "
  #ingress_worker_filter    = " \"sm-ingress-upstream-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 5432
  host_source_ids = [
    boundary_host_set_static.db.id
  ]

  brokered_credential_source_ids = [
    boundary_credential_library_vault.dba.id
  ]

}

resource "boundary_alias_target" "scenario2_dba" {
  name           = "Database Admin Alias"
  description    = "The alias used by admins to reach the DB"
  scope_id       = "global"
  value          = "admin.db.boundary.demo"
  destination_id = boundary_target.dba.id
  #authorize_session_host_id = boundary_host_static.bar.id
}

resource "boundary_target" "analyst" {
  type                     = "tcp"
  name                     = "Database Analyst"
  description              = "Analyst Target"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 5432
  host_source_ids = [
    boundary_host_set_static.db.id
  ]

  # Comment this to avoid brokeing the credentials
  brokered_credential_source_ids = [
    boundary_credential_library_vault.analyst.id
  ]

}

resource "boundary_alias_target" "scenario2_analyst" {
  name           = "Database Analyst Alias"
  description    = "The alias used by Analyst to reach the DB"
  scope_id       = "global"
  value          = "analyst.db.boundary.demo"
  destination_id = boundary_target.analyst.id
  #authorize_session_host_id = boundary_host_static.bar.id
}
