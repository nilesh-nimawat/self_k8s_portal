resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = kubernetes_namespace.mega_project.metadata[0].name
  }

  data = {
    password = base64encode("admin123")
  }

  type = "Opaque"
}