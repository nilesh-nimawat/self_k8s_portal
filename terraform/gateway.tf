resource "kubernetes_manifest" "my_gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = "my-gateway"
      namespace = kubernetes_namespace.mega_project.metadata[0].name
    }
    spec = {
      gatewayClassName = kubernetes_manifest.envoy_gateway_class.manifest.metadata.name  //match class k andr metadata ka name
      listeners = [{
        name     = "https"
        protocol = "HTTPS"  //http, tcp , https
        port     = 443
         tls = {                
          mode = "Terminate"    
          certificateRefs = [{  
            name      = "gateway-tls" 
            namespace = kubernetes_namespace.mega_project.metadata[0].name
          }]
        }
        allowedRoutes = {
          namespaces = {
            from = "All"
          }
        }
      }]
    }
  }
  depends_on = [helm_release.envoy_gateway]
}