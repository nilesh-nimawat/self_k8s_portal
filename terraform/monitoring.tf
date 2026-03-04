resource "helm_release" "kube_prometheus" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace  = kubernetes_namespace.monitoring.metadata[0].name
} 