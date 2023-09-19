provider "kubernetes" {
  config_path = "../kind-config" # Path to your kubeconfig file, adjust as needed
}

provider "helm" {
  kubernetes {
    config_path = "../kind-config" # Path to your kubeconfig file, adjust as needed
  }
}

provider "kind" {
}