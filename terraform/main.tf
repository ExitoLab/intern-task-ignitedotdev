provider "kubernetes" {
  config_context_cluster = "kind-cluster-name" # Replace with your Kind cluster name
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "example-namespace"
  }
}