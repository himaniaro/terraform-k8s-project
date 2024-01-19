provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source           = "../../../../modules/aws/eks"
  cluster_name     = "eks-cluster"
  cluster_role_arn = module.eks_cluster.role_arn
  namespaces       = ["services", "monitoring"]
}

module "nginx_services" {
  source     = "../../../../modules/aws/networking/expose_to_internet"
  namespaces = ["services"]
}

module "monitoring" {
  source     = "../../../../modules/aws/monitoring/prometheus_grafana"
  namespaces = ["monitoring"]
}


