# resource "helm_release" "postgres" {
#   name       = "postgres"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "postgresql"
#   namespace  = kubernetes_namespace.mega_project.metadata[0].name

#   set = [
#     {
#       name  = "auth.username"
#       value = "admin"
#     },
#     {
#       name  = "auth.password"
#       value = "admin123"
#     },
#     {
#       name  = "auth.database"
#       value = "mydb"
#     },
#     {
#       name  = "primary.persistence.size"
#       value = "2Gi"
#     },
#     {
#       name = "readReplicas.persistentVolumeClaimRetentionPolicy.enabled"
#       value = "true"
#     }
#   ]
# }