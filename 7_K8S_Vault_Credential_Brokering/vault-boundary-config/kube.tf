data "aws_eks_cluster" "example" {
  name = data.tfe_outputs.eks.values.cluster_name
}


data "aws_eks_cluster_auth" "example" {
  name = data.tfe_outputs.eks.values.cluster_name
}


provider "kubernetes" {
  host                   = data.tfe_outputs.eks.values.cluster_endpoint
  cluster_ca_certificate = base64decode(data.tfe_outputs.eks.values.cluster_certificate_authority_data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.eks.values.cluster_name]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "vault" {
  metadata {
    annotations = {
      name = "vault"
    }

    labels = {
      mylabel = "vault"
    }

    name = "vault"
  }
}

resource "kubernetes_service_account" "vault" {
  metadata {
    name = "vault"
    namespace = "vault"
  }
    timeouts {
    create = "3m"
  }
}

resource "kubernetes_secret" "vault" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.vault.metadata.0.name
    }
    name = "vault"
    namespace = "vault"
  }

  type = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}


resource "kubernetes_namespace" "test" {
  metadata {
    annotations = {
      name = "test"
    }

    labels = {
      mylabel = "test"
    }

    name = "test"
  }
}

resource "kubernetes_manifest" "clusterrolebinding_vault_token_creator_binding" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRoleBinding"
    "metadata" = {
      "name" = "vault-token-creator-binding"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "ClusterRole"
      "name" = "k8s-full-secrets-abilities-with-labels"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "vault"
        "namespace" = "vault"
      },
    ]
  }
}

resource "kubernetes_manifest" "clusterrole_k8s_full_secrets_abilities_with_labels" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "ClusterRole"
    "metadata" = {
      "name" = "k8s-full-secrets-abilities-with-labels"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "namespaces",
        ]
        "verbs" = [
          "get",
        ]
      },
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "serviceaccounts",
          "serviceaccounts/token",
        ]
        "verbs" = [
          "create",
          "update",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "rbac.authorization.k8s.io",
        ]
        "resources" = [
          "rolebindings",
          "clusterrolebindings",
        ]
        "verbs" = [
          "create",
          "update",
          "delete",
        ]
      },
      {
        "apiGroups" = [
          "rbac.authorization.k8s.io",
        ]
        "resources" = [
          "roles",
          "clusterroles",
        ]
        "verbs" = [
          "bind",
          "escalate",
          "create",
          "update",
          "delete",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "serviceaccount_test_test_service_account_with_generated_token" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "ServiceAccount"
    "metadata" = {
      "name" = "test-service-account-with-generated-token"
      "namespace" = "test"
    }
  }
}

resource "kubernetes_manifest" "role_test_test_role_list_create_delete_pods" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "Role"
    "metadata" = {
      "name" = "test-role-list-create-delete-pods"
      "namespace" = "test"
    }
    "rules" = [
      {
        "apiGroups" = [
          "",
        ]
        "resources" = [
          "pods",
        ]
        "verbs" = [
          "list",
          "create",
          "update",
          "delete",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "rolebinding_test_test_role_abilities" {
  manifest = {
    "apiVersion" = "rbac.authorization.k8s.io/v1"
    "kind" = "RoleBinding"
    "metadata" = {
      "name" = "test-role-abilities"
      "namespace" = "test"
    }
    "roleRef" = {
      "apiGroup" = "rbac.authorization.k8s.io"
      "kind" = "Role"
      "name" = "test-role-list-create-delete-pods"
    }
    "subjects" = [
      {
        "kind" = "ServiceAccount"
        "name" = "test-service-account-with-generated-token"
        "namespace" = "test"
      },
    ]
  }
}

