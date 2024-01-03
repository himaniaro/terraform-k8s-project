variable "namespace"{}

resource "helm_release: "prometheus" {
name = "prometheus"
repository = "https://prometheus-community.github.io/helm-charts"
chart = "prometheus"
namespace = var.namespace
set{
 name = "server.service.type"
 value = "LoadBalancer"
}
}

resource "helm_release: "grafana" {
name = "grafana"
repository = "https://grafana.github.io/helm-charts"
chart = "grafana"
namespace = var.namespace
set{
 name = "service.type"
 value = "LoadBalancer"
}
}
