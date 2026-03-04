resource "helm_release" "frontend" {
  name      = "frontend"
  chart     = "${path.module}/helm_charts/frontend-chart"
  namespace = kubernetes_namespace.mega_project.metadata[0].name
  force_update = true
}


