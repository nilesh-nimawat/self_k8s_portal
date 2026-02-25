resource "kubernetes_namespace" "mega_project" {
  metadata {
    name = "mega-project-ns"
  }
}