# Makefile for managing a KinD Kubernetes cluster

CLUSTER_NAME := intern
KUBECONFIG := $(shell kind get kubeconfig-path --name=$(CLUSTER_NAME))

.PHONY: create-cluster
create-cluster:
	@kind create cluster --name=$(CLUSTER_NAME)

.PHONY: delete-cluster
delete-cluster:
	@kind delete cluster --name=$(CLUSTER_NAME)

.PHONY: get-kubeconfig
get-kubeconfig:
	@echo "KUBECONFIG: $(KUBECONFIG)"

.PHONY: deploy-app
deploy-app:
	@kubectl apply -f your-app-deployment.yaml --kubeconfig=$(KUBECONFIG)

.PHONY: delete-app
delete-app:
	@kubectl delete -f your-app-deployment.yaml --kubeconfig=$(KUBECONFIG)

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  - create-cluster: Create a KinD cluster"
	@echo "  - delete-cluster: Delete the KinD cluster"
	@echo "  - get-kubeconfig: Print the kubeconfig file location"
	@echo "  - deploy-app: Deploy your application to the KinD cluster"
	@echo "  - delete-app: Delete your application from the KinD cluster"
	@echo "  - help: Display this help message"

.DEFAULT_GOAL := help
