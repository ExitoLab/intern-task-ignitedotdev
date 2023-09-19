resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "helm_chart" {
  name      = var.name
  namespace = var.namespace
  chart     = var.chart_name

  depends_on = [kubernetes_namespace.namespace]
}