# resource "hcp_vault_cluster_admin_token" "token" {
#   cluster_id = var.vault_cluster_id
#   depends_on = [hcp_vault_cluster.hcp_vault]
# }