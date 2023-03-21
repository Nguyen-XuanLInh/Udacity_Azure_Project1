# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
We will need to:
1. Create an Packer image.
2. Create infrastructure with Terraform template.

Packer Image

Terraform Template
1. Configure environment
  - Azure Subcription:
  - Configure Terraform
  - Create SSH key pair
2. Implement code
  - Create a file main.tf
  - Create a file vars.tf to contain the variables
  
3. Initialize Terraform deployent
  - Run: terraform init 
4. Terraform execution plan
  - Terraform plan command creates execution plan but NOT execute
  - Run: terraform plan - out solution.plan
  The -out parameter allows speify an out put file and revie the plan.
5. Apply a Terraform plan
  - Terraform apply command to execute plan to infrastructure
  - Run: terraform apply solution.plan
### Output
Terraform will perform:

