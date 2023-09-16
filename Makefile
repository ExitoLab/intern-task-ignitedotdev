# Makefile for managing a KinD Kubernetes cluster

CLUSTER_NAME := intern
KUBECONFIG := $(shell kind get kubeconfig-path --name=$(CLUSTER_NAME))
IMAGE_NAME := intern-task-ignitedotdev
IMAGE_TAG := v0.0.2
PORT := 3000

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

.PHONY: build
build:
	cd app && docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

# Run a Docker container from the previously built image
.PHONY: run
run: build
	docker run -it -p $(PORT):$(PORT) --rm $(IMAGE_NAME):$(IMAGE_TAG) 

# To scan docker image
.PHONY: scan
scan:
	docker scan $(IMAGE_NAME):$(IMAGE_TAG)

# Clean up - remove the local Docker image
.PHONY: clean
clean:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)


.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make create-cluster: Create a KinD cluster"
	@echo "  make delete-cluster: Delete the KinD cluster"
	@echo "  make get-kubeconfig: Print the kubeconfig file location"
	@echo "  make deploy-app: Deploy your application to the KinD cluster"
	@echo "  make delete-app: Delete your application from the KinD cluster"
	@echo "  make help: Display this help message"
	@echo "  make build: Build the Docker image"
	@echo "  make run: Run a Docker container from the image"
	@echo "  make clean: Remove the local Docker image"

.DEFAULT_GOAL := help
