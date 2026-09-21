# Terraform Multi-Environment AWS Infrastructure

A Terraform-based Infrastructure as Code project for provisioning and managing separate **Development and Production environments on AWS** using a reusable configuration.

##  Project Overview

This project demonstrates how Terraform can be used to manage multiple environments within the same AWS account.

Instead of maintaining separate Terraform code for Dev and Prod, the project uses **Terraform Workspaces and environment-specific variables** to control the infrastructure configuration.

##  Infrastructure

```text
                         Terraform
                             │
                 ┌───────────┴───────────┐
                 │                       │
             Dev Workspace          Prod Workspace
                 │                       │
             1 × t3.micro             3 × t3.small
                 │                       │
                 └───────────┬───────────┘
                             │
                         AWS Region
                         ap-south-1
                             │
                    ┌────────┴────────┐
                    │                 │
              Existing VPC       Amazon Linux
                    │                  AMI
                 Subnets
                    │
                    ▼
              EC2 Instances
                    │
              Security Group
              ┌─────┴─────┐
              │           │
           HTTP :80    SSH :22
```

The project uses an existing AWS VPC and subnets discovered dynamically through Terraform Data Sources.

##  Technologies

- **Terraform**
- **AWS EC2**
- **AWS VPC**
- **AWS Security Groups**
- **Terraform Workspaces**
- **Terraform Variables & tfvars**
- **Terraform Data Sources**
- **Git & GitHub**

## 📁 Project Structure

```text
terraform-multi-environment/
│
├── main.tf
├── variables.tf
├── terraform.tf
├── output.tf
├── terraform.tfvars.dev
├── terraform.tfvars.prod
├── .terraform.lock.hcl
├── .gitignore
└── README.md
```

### Configuration

- `main.tf` — AWS data sources and infrastructure resources
- `variables.tf` — Terraform variable definitions
- `terraform.tf` — Terraform and AWS provider configuration
- `output.tf` — EC2 IDs, IPs, DNS and security group outputs
- `terraform.tfvars.dev` — Development configuration
- `terraform.tfvars.prod` — Production configuration

##  Environment Configuration

| | Development | Production |
|---|---|---|
| Workspace | `dev` | `prod` |
| EC2 Instances | 1 |