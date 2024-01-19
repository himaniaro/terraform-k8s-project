variable "namespaces" {
type = list(string)
default = []
description = "The namespace for Prometheus and Grafana deployment"
}

variable "kubeconfig_path" {
  type    = string
  default = "/path/to/your/kubeconfig.yaml"  # Replace with the actual path to your kubeconfig file
}
