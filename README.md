# 


## Technology / Tools used

1. Github Actions - This is used for CICD for the Docker image. It builts the docker image and publish
2. Docker Hub - The Docker image is published to Docker Hub Registry 
3. Makefile - Used to run Docker commands and commands to setup `kind` cluster on the local machine. 
4. Helm Chart - Used to deploy and package the kubernetes manifest file. 
5. Terraform - IaC tool - Terraform is used for deployiing to the `kind` cluster and for setting up infra.


### Commands to used 

1. To build the app locally use command (for example, build the Dockefile of the express app) `make run`
2. To check if kind is installed run command `make check-kind`, it will create kind cluster if not installed.
3. To create the kind cluster run command `make check-cluster`


### Structure 
1. `app` folder contains express app 
2. `intern` folder contains the helm chart 
3. `Terraform` folder contains the terraform files 
4. `Makefile` file, commands for running auomation scripts 
5. `README.md` file, for instructions
6. `.github\workflows` file contains the GitHub Actions workflow for `cicd`