

resource "kubernetes_namespace" "user_a_ns" {
  metadata { name = "user-a-ns" }
}

resource "kubernetes_role" "user_a_role" {
  metadata {
    name      = "user-a-role"
    namespace = kubernetes_namespace.user_a_ns.metadata[0].name
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "create"]
  }
}

resource "kubernetes_role_binding" "user_a_binding" {
  metadata {
    name      = "user-a-binding"
    namespace = kubernetes_namespace.user_a_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.user_a_role.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "user-a"
    api_group = "rbac.authorization.k8s.io"
  }
}



resource "kubernetes_namespace" "user_b_ns" {
  metadata { name = "user-b-ns" }
}

resource "kubernetes_role" "user_b_role" {
  metadata {
    name      = "user-b-role"
    namespace = kubernetes_namespace.user_b_ns.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "create"]
  }
}

resource "kubernetes_role_binding" "user_b_binding" {
  metadata {
    name      = "user-b-binding"
    namespace = kubernetes_namespace.user_b_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.user_b_role.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "user-b"
    api_group = "rbac.authorization.k8s.io"
  }
}



resource "kubernetes_namespace" "user_c_ns" {
  metadata { name = "user-c-ns" }
}

resource "kubernetes_role" "user_c_role" {
  metadata {
    name      = "user-c-role"
    namespace = kubernetes_namespace.user_c_ns.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "create"]
  }
}

resource "kubernetes_role_binding" "user_c_binding" {
  metadata {
    name      = "user-c-binding"
    namespace = kubernetes_namespace.user_c_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.user_c_role.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "user-c"
    api_group = "rbac.authorization.k8s.io"
  }
}



resource "kubernetes_namespace" "user_d_ns" {
  metadata { name = "user-d-ns" }
}

resource "kubernetes_role" "user_d_role" {
  metadata {
    name      = "user-d-role"
    namespace = kubernetes_namespace.user_d_ns.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "create"]
  }
}

resource "kubernetes_role_binding" "user_d_binding" {
  metadata {
    name      = "user-d-binding"
    namespace = kubernetes_namespace.user_d_ns.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.user_d_role.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "user-d"
    api_group = "rbac.authorization.k8s.io"
  }
}