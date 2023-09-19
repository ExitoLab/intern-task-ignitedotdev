provider "kubernetes" {
  config_path = "~/.kube/config" # Path to your kubeconfig file, adjust as needed
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config" # Path to your kubeconfig file, adjust as needed
  }
}

