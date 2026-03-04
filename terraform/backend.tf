resource "helm_release" "backend" {
  name      = "backend"
  chart     = "${path.module}/helm_charts/backend-chart"
  namespace = kubernetes_namespace.mega_project.metadata[0].name
  force_update = true
}