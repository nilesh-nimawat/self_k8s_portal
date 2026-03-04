resource "kubernetes_namespace_v1" "mega_project" {
  metadata {
    name = "mega-project-ns"
  }
}

resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = "jenkins-ns"
  }
}

resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring-ns"
  }
}