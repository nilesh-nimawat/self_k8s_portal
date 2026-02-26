resource "kubernetes_deployment" "backend" {
  metadata {
    name = "self-k8s-backend"
    namespace = kubernetes_namespace.mega_project.metadata[0].name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 1 

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.admin_a.metadata[0].name
        container {
          image = "nileshnimawat/self-k8s-backend:1.4" 
          name  = "flask-app"
          image_pull_policy = "Always"
          port {
            container_port = 5000 
          }
        } 
      } 
    }
  }
}



//services

resource "kubernetes_service" "backend_service" {
  metadata {
    name = "backend-service"
    namespace = kubernetes_namespace.mega_project.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.backend.metadata[0].labels.app
    }
    port {
      port        = 5000        
      target_port = 5000     
    }

  }
}