

resource "kubernetes_service_account" "admin_a" {
  metadata {
    name      = "admin-a"
    namespace = kubernetes_namespace.mega_project.metadata[0].name
  }
}



resource "kubernetes_cluster_role" "backend_cluster_role" {
  metadata {
    name = "backend-cluster-role"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "create", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["services", "configmaps", "secrets"]
    verbs      = ["get", "create", "list", "delete"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "create", "list", "delete"]
  }
}


resource "kubernetes_cluster_role_binding" "backend_binding" {
  metadata {
    name = "backend-cluster-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.backend_cluster_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin_a.metadata[0].name
    namespace = kubernetes_namespace.mega_project.metadata[0].name
  }
}
