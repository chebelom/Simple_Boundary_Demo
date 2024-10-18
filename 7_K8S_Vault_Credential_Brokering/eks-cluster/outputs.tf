output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "k8s_connect" {
  value = "boundary connect kube -target-id=${var.scenario6_alias}"
}

output "k8s_connect_alias" {
  value = "boundary connect kube ${var.scenario6_alias}"
}


output "k8s_authorize_connect" {
  value = <<-EOF
  eval "$(boundary targets authorize-session -id ${var.scenario6_alias} -format json | jq -r '.item | "export BOUNDARY_SESSION_TOKEN=\(.authorization_token) BOUNDARY_K8S_TOKEN=\(.credentials[0].secret.decoded.service_account_token)"')"
  boundary connect kube ${var.scenario6_alias} -- run my-pod3 --image=nginx -n test --token=$BOUNDARY_K8S_TOKEN --certificate-authority=ca.crt
  EOF
}

output "k8s_token" {
  value = nonsensitive(kubernetes_secret.vault.data["token"])
}

output "k8s_ca" {
  value = nonsensitive(kubernetes_secret.vault.data["ca.crt"])
}