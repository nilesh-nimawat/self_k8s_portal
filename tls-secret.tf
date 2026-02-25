resource "kubernetes_secret_v1" "gateway_tls" {
  metadata {
    name      = "gateway-tls"
    namespace = kubernetes_namespace.mega_project.metadata[0].name
  }
type = "kubernetes.io/tls"


binary_data = {
  "tls.crt" = filebase64("${path.module}/certs/server.crt")        
  "tls.key" = filebase64("${path.module}/certs/server.key")
}
}
