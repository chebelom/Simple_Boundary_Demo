resource "vault_policy" "boundary_controller" {
  name = "boundary-controller"

  policy = file("${path.module}/vault_policies/boundary-controller-policy.hcl")
}