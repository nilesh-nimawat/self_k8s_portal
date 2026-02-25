resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "self-k8s-frontend"
    namespace = kubernetes_namespace.mega_project.metadata[0].name
    labels = {
      app = "frontend"
    }
  }

  spec {
    replicas = 1 # Scaling up for high availability

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          image = "nileshnimawat/self-k8s-frontend:1.1" 
          name  = "frontend-app"
          image_pull_policy = "Always"
          port {
            container_port = 80 # Standard port for web servers
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend_service" {
  metadata {
    namespace = kubernetes_namespace.mega_project.metadata[0].name
    name = "frontend-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.frontend.metadata[0].labels.app
    }
    port {
      port        = 80  # Port accessed via your browser
      target_port = 80  # Port inside the container
    }
   
  }
}