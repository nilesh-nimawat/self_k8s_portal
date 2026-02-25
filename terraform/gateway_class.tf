resource "kubernetes_manifest" "envoy_gateway_class" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "GatewayClass"
    metadata = {
      name = "envoy-gateway-class"   //important so controller connect krega className k jariye
    }
    spec = {
      # ENVOY KI IDENTITY:
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
    }
  }
  depends_on = [helm_release.envoy_gateway]
}