resource "boundary_worker" "ingress_pki_worker" {
  scope_id                    = "global"
  name                        = "recording-pki-worker"
  worker_generated_auth_token = ""
}