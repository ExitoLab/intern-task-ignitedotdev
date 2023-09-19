KIND_CLUSTER_NAME := intern
IMAGE_NAME := intern-task-ignitedotdev
IMAGE_TAG := v0.0.2
PORT := 3000
KIND_VERSION ?= 0.20.0
KIND_BINARY  := kind
KUBECONFIG_FILE := kind-config
HELM_CHART_NAME := intern
NAMESPACE := intern
RELEASE_NAME := intern

.PHONY: check-kind
check-kind:
	@if ! command -v $(KIND_BINARY) > /dev/null ; then \
		echo "Kind is not installed, installing"; \
		make install-kind; \
    else \
        echo "Kind is installed"; \
        make check-cluster; \
    fi

.PHONY: install-kind
install-kind:
	@if ! command -v $(KIND_BINARY) &> /dev/null; then \
        echo "Kind is not installed. Installing Kind..."; \
        curl -Lo $(KIND_BINARY) "https://github.com/kubernetes-sigs/kind/releases/download/v$(KIND_VERSION)/kind-$(shell uname)-amd64"; \
        chmod +x $(KIND_BINARY); \
        sudo mv $(KIND_BINARY) /usr/local/bin/; \
    else \
        echo "Kind is already installed."; \
    fi

.PHONY: check-cluster
check-cluster:
	@if ! kind get clusters | grep -q $(KIND_CLUSTER_NAME); then \
    	echo "Kind cluster is not running. Creating one..."; \
    	make create-cluster; \
	else \
    	echo "Kind cluster is already running."; \
		make create-kubeconfig; \
		make get-kubeconfig; \
	fi

.PHONY: create-cluster
create-cluster:
	@kind create cluster --name=$(KIND_CLUSTER_NAME)

.PHONY: create-kubeconfig
create-kubeconfig:
    kind get kubeconfig --name=$(KIND_CLUSTER_NAME) > $(KUBECONFIG_FILE)
    export KUBECONFIG=$(PWD)/$(KUBECONFIG_FILE)

.PHONY: delete-cluster
delete-cluster:
	@kind delete cluster --name=$(KIND_CLUSTER_NAME)

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

.PHONY: install-helm-chart
install-helm-chart:
	cd terraform && terraform init && \
		terraform fmt -check && terraform validate && \
		terraform plan -var-file=values.tfvars && terraform apply -var-file=values.tfvars  -auto-approve

destroy-helm-chart:
	terraform destroy -auto-approve

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