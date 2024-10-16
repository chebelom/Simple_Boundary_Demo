data "tfe_outputs" "eks" {
  organization = "hashicorp-italy"
  workspace = "7_K8S_Vault_Credential_Brokering-eks"
}



data "aws_eks_cluster" "example" {
  name = data.tfe_outputs.eks.values.cluster_name
}


data "aws_eks_cluster_auth" "example" {
  name = data.tfe_outputs.eks.values.cluster_name
}


provider "kubernetes" {
  host                   = data.tfe_outputs.eks.values.cluster_endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  cluster_ca_certificate = base64decode(data.tfe_outputs.eks.values.cluster_name.certificate_authority[0].data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.eks.values.cluster_name]
    command     = "aws"
  }
}