resource "vault_policy" "policy_windows" {
  name = "windows-policy"

  policy = file("${path.module}/vault_policies/windows_static.hcl")
}

resource "vault_token" "boundary_vault_token_windows" {
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