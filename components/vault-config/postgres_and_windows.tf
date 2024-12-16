resource "vault_policy" "boundary_controller" {
  name = "boundary-controller"

  policy = file("${path.module}/vault_policies/boundary-controller-policy.hcl")
}

resource "vault_policy" "policy_windows" {
  name = "windows-policy"

  policy = file("${path.module}/vault_policies/windows_static.hcl")
}

resource "vault_mount" "database" {
  path        = "database"
  type        = "database"
  description = "This is an example Database Example"

  default_lease_ttl_seconds = 300
  max_lease_ttl_seconds     = 3600
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.database.path
  name          = "postgres"
  allowed_roles = ["dba", "analyst"]

  # Going towards the private IP of the Ubuntu Server
  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@${var.postgres_private_ip}:5432/postgres?sslmode=disable"
    username       = "vault"
    password       = "vault-password"
  }

  # depends_on = [time_sleep.wait_forpostgres]
}

resource "vault_database_secret_backend_role" "dba" {
  backend             = vault_mount.database.path
  name                = "dba"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = [file("${path.module}/vault_policies/dba.sql.hcl")]
}

resource "vault_database_secret_backend_role" "analyst" {
  backend             = vault_mount.database.path
  name                = "analyst"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = [file("${path.module}/vault_policies/analyst.sql.hcl")]
}

resource "vault_policy" "northwind_database" {
  name = "northwind-database"

  policy = file("${path.module}/vault_policies/northwind-database-policy.hcl")
}

resource "vault_token" "boundary_token_dba" {
  no_default_policy = true
  period            = "20m"
  policies          = ["boundary-controller", "northwind-database"]
  no_parent         = true
  renewable         = true


  renew_min_lease = 43200
  renew_increment = 86400

  metadata = {
    "purpose" = "service-account-dba"
  }
}

resource "vault_token" "boundary_token_kv" {
  no_default_policy = true
  period            = "20m"
  policies          = ["boundary-controller", "windows-policy"]
  no_parent         = true
  renewable         = true


  renew_min_lease = 43200
  renew_increment = 86400

  metadata = {
    "purpose" = "service-account-kv"
  }
}

# Crear una KVv2 donde añadimos los credenciales de acceso
resource "vault_mount" "kv" {
  path        = "secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "Key-Value Secrets Engine"
}

resource "vault_kv_secret_v2" "windows_secret" {
  mount = vault_mount.kv.path
  name  = "windows_secret"
  data_json = jsonencode(
    {
      "data" : {
        "username" : "Administrator",
        "password" : rsadecrypt(var.win_password_data, var.ssh_key_private)
      }
    }
  )
}