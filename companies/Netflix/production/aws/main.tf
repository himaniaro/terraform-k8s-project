provider "aws" {
region = "ap-south-1"
}

module "eks_cluster" {
source = "../../../../modules/aws/eks"
cluster_name = "eks-cluster"
cluster_role_arn   = "arn:aws:iam::ACCOUNT_ID:role/eks-cluster-role"
namespaces = ["services", "monitoring"]
}

module "nginx_services" {
source = "../../../../modules/networking/expose_to_internet"
namespaces = ["services"]
}

module "monitoring" {
source = "../../../../modules/monitoring/prometheus_grafana"
namespaces = ["monitoring"]
}


