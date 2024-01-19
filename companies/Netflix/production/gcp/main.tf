provider "google" {
  credentials = file("/Users/himaniarora/Downloads/gcp-creds.json")
  project     = "project-terraform-k8s"
  region      = "us-central1"
}

module "gke_cluster" {
  source      = "../../modules/gcp/gke"
  cluster_name = "terraform-k8s-cluster"
  namespaces   = ["services", "monitoring"]
}

module "nginx_services" {
  source     = "../../modules/gcp/compute"
  instance_name = "nginx-instance"
  namespace = "services"
}
