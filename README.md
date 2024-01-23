# terraform-k8s-project
A project displaying working knowledge of Terraform with Kubernetes


**CHECK COMPANIES/NETFLIX FOLDER FOR ACTUAL CODE**

There are 2 parts to this project:
Part A - terraform repository structure
Part B - terraform coding

**A. Terraform repository structure**
Structure the repository in a way that will allow it to manage multiple companies that can have multiple environments (staging, production...) and can have environments in multiple cloud providers (some in GCP, some in AWS...).

**B. Use terraform to achieve following goals using terraform structure from part A (consider yourself a company with AWS production account):**
1. EKS cluster with namespace “services” and “monitoring”
2. deploy vanilla Nginx web server to “services” namespace
3. deploy prometheus + Grafana to monitoring namespace
4. expose Nginx + Grafana to the internet
