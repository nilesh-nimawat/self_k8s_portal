resource "kubernetes_manifest" "http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name      = "my-app-route"
      namespace = kubernetes_namespace.mega_project.metadata[0].name
    }

    spec = {
      parentRefs = [
        {
          name      = kubernetes_manifest.my_gateway.manifest.metadata.name
          namespace = kubernetes_namespace.mega_project.metadata[0].name
        }
      ]

      hostnames = ["nilesh.appperfect.com"]

      rules = [

        # Backend API
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/api"
              }
            }
          ]

          backendRefs = [
            {
              name = "backend-service"
              port = 5000
            }
          ]
        },

        # Frontend
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            }
          ]

          backendRefs = [
            {
              name = "frontend-service"
              port = 80
            }
          ]
        },

       
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/grafana"
              }
            }
          ]

          backendRefs = [
            {
              name      = "monitoring-grafana"
              port      = 80
            }
          ]
        }

      ]
    }
  }
}