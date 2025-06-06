iRage Assignment

# Solution:
Provision isolated staging and production environments on AWS using Terraform, with:
A modular structure
Secure and scalable architecture
GitOps CI/CD pipeline via GitHub Actions

# Project Directory Structure: 
.├── README.md
├── environment
│   ├── production
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── staging
│       ├── backend.tf
│       ├── main.tf
│       ├── terraform.tfvars
│       └── variables.tf
└── modules
    ├── bastion
    │   ├── main.tf
    │   ├── output.tf
    │   └── variables.tf
    ├── database
    │   ├── main.tf
    │   ├── output.tf
    │   └── variables.tf
    ├── network
    │   ├── main.tf
    │   ├── output.tf
    │   └── variables.tf
    └── security
        ├── main.tf
        ├── output.tf
        └── variables.tf


# Modular Design: 
All the core AWS resources : Network (VPC, Subnet), Bastion, RDS, Security Groups are in modular structure.
Each environment just reuses modules with different variables. 
#Backend:
The tfstate file is stored in s3 (per env). 
Locking is enabled by Dynamo DB. This ensures that multiple users won’t be able to execute the tf files at the same time.
# AWS Secrets: 
AWS credentials are stored as github secrets.
Separate IAM users and secrets are used for both both staging and production.
# Security Considerations: 
Bastion is only accessible from a fixed IP. The IP address will be the one provided in the variable file. It is in public subnet. 
RDS is in private subnet and is not publicly accessible. Its access is through custom port from Bastion server only. 
IAM roles for each account will be different for terraform apply to maintain separation and isolation.
# GitOps Workflow:
There are 3 things that needs to be done according to the problem statement.
On pull request, run terraform fmt, validate and plan.
Whenever there is a merge to main branch, terraform apply for staging environment.
Whenever there is a tag push, like v1.0.0, terraform apply for production environment. 

# Environment Handling: 
Terraform supports multiple environments using separate folders and backends:
environment/staging/terraform.tfvars
environment/production/terraform.tfvars
# Each environment:
Uses its own state file
Uses its own backend config (backend.tf)
Has its own variables
No duplication of logic — modules ensure DRY principle.

# Pre-Requisite: 
The db password shouldn't be given as a input in the tfvars files. It's better to put it in the aws secret manager (or any other secret manager) and pull it into the terraform by data module. The same has been done here. So, as a prerequisite, for each environment, secrets need to be created.
S3 and dynamo DB has to be created for proper backend configuration. Ensure it has been created for both the environments and put into the buckets and dynamoDB before running.

# Manual Testing Instructions
Ensure s3 and dynamoDB locking has been created before manual testing as terraform init wont work if both are not created.
For Staging env:
cd environment/staging
terraform init
terraform apply -var-file="terraform.tfvars"
For Production env:
cd environment/production
terraform init
terraform apply -var-file="terraform.tfvars"

# Why We Use terraform.tfvars Instead of Workspaces
Strict Environment Isolation
Each environment (staging and production) is defined in a separate directory with its own state backend, secrets, and configuration. This ensures a hard boundary between environments, which Terraform workspaces do not guarantee.
GitOps Compatibility
CI/CD pipeline treats each environment independently. Using terraform.tfvars files per environment simplifies workflow design and avoids introducing workspace switching logic into automation.
Credential Separation
Different AWS credentials are used for staging and production via GitHub Secrets. This separation is more secure and easier to manage when environments are structured with tfvars and directories instead of shared workspaces.






By: 
Saimoon Bej
DevOps Engineer
8107133927
sai.bej1234@gmail.com
