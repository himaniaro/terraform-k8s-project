provider "aws" {
region = "ap-south-1"
}

module "eks_cluster" {
source = "../../modules/aws/eks"
cluster_name = "eks-cluster"
namespaces = ["services", "monitoring"]
}

module "nginx_services"
{
source = "../../../modules/aws/eks"
cluster_name = "eks-cluster"
namespace = "services"
}

module "monitoring" {
source = "../../../modules/monitoring/prometheus_grafana"
namespace = "monitoring"
}

module "expose to internet" {
source = "../../../modules/networking/expose_to_internet"
}

