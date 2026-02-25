resource "null_resource" "gateway_api_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml"
  }
}


resource "helm_release" "envoy_gateway" {
  name       = "envoy-gateway"
  repository = "oci://docker.io/envoyproxy" # 1. Envoy ka official repo
  chart      = "gateway-helm"                      # 2. Envoy Gateway ka chart name
  namespace  = "envoy-gateway-system"
  create_namespace = true
 
  # Gateway API CRDs pehle honi chahiye
  depends_on = [null_resource.gateway_api_crds]
}