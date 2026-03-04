resource "helm_release" "postgres" {
  name      = "postgres"
  chart     = "${path.module}/helm_charts/database-chart"
  namespace = kubernetes_namespace.mega_project.metadata[0].name
  force_update = true
}