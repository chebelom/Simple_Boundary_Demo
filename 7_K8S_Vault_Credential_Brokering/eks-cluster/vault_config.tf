resource "vault_policy" "policy_k8s" {
  name = "k8s-policy"

  # policy = file("kubernetes_policy.hcl")
  policy = <<-EOT
        path "kubernetes/creds/my-role" {
          capabilities = ["update"]
        }
    EOT
}


resource "vault_kubernetes_secret_backend" "config" {
  path                      = "kubernetes"
  description               = "kubernetes secrets engine description"
  default_lease_ttl_seconds = 43200
  max_lease_ttl_seconds     = 86400
  kubernetes_host           = module.eks.cluster_endpoint
  kubernetes_ca_cert        = kubernetes_secret.vault.data["ca.crt"]
  service_account_jwt       = kubernetes_secret.vault.data["token"]
  disable_local_ca_jwt      = true
  depends_on = [ kubernetes_service_account.vault ]
}

resource "vault_kubernetes_secret_backend_role" "sa-example" {
  backend                       = vault_kubernetes_secret_backend.config.path
  name                          = "my-role"
  allowed_kubernetes_namespaces = ["*"]
  token_max_ttl                 = 43200
  token_default_ttl             = 3600
  service_account_name          = "test-service-account-with-generated-token"

}


resource "vault_token" "boundary_token_k8s" {
  no_default_policy = true
  period            = "20m"
  policies          = ["boundary-controller", "k8s-policy"]
  no_parent         = true
  renewable         = true


  renew_min_lease = 43200
  renew_increment = 86400

  metadata = {
    "purpose" = "service-account-k8s"
  }
}
