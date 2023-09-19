resource "helm_release" "prometheus" {
  chart      = "prometheus"
  name       = "prometheus"
  namespace  = "grafana"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "15.5.3"

  # You can provide a map of value using yamlencode. Don't forget to escape the last element after point in the name
  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
  depends_on = [kubernetes_namespace.monitoring_namespace]
}


resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "grafana"
  }

  data = {
    admin-user     = "admin"
    admin-password = random_password.grafana.result
  }
  depends_on = [kubernetes_namespace.monitoring_namespace]
}

resource "random_password" "grafana" {
  length = 24
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "grafana"
  version    = "6.24.1"

  values = [
    templatefile("./templates/grafana-values.yaml", {
      admin_existing_secret = kubernetes_secret.grafana.metadata[0].name
      admin_user_key        = "admin-user"
      admin_password_key    = "admin-password"
      prometheus_svc        = "${helm_release.prometheus.name}-server"
      replicas              = 1
    })
  ]
  depends_on = [kubernetes_namespace.monitoring_namespace]
}

resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
    name = "grafana"
  }
}