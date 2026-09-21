# Terraform Multi-Environment AWS Infrastructure

## 📌 Project Overview

This project demonstrates how to build and manage **multiple AWS environments using Terraform** from a single AWS account.

The project uses **Terraform Workspaces, Variables, `.tfvars` files, Data Sources, Resources, and Outputs** to create separate **Development (Dev)** and **Production (Prod)** environments.

The main objective is to maintain a reusable Terraform configuration while allowing each environment to have different infrastructure requirements.

---

## 🎯 Objectives

- Create multiple environments using Terraform Workspaces.
- Maintain separate Terraform state for Dev and Prod.
- Use variables instead of hardcoded configuration values.
- Use environment-specific `.tfvars` files.
- Use AWS Data Sources to discover existing AWS infrastructure.
- Create EC2 instances based on environment-specific requirements.
- Apply appropriate tags to AWS resources.
- Validate, format, plan, apply, and destroy infrastructure using Terraform.
- Demonstrate Infrastructure as Code (IaC) principles.

---

## 🏗️ Architecture

The project uses an existing AWS Default VPC and discovers the required networking and AMI information through Terraform Data Sources.

```text
                    AWS Account
                         │
                         │
                  Terraform
                         │
              ┌──────────┴──────────┐
              │                     │
          Dev Workspace         Prod Workspace
              │                     │
        1 × t3.micro          3 × t3.small
              │                     │
              └──────────┬──────────┘
                         │
                  Existing AWS VPC
                         │
              ┌──────────┴──────────┐
              │                     │
        Existing Subnets       Amazon Linux AMI
              │
              ▼
        EC2 Instances
              │
              ▼
        Security Group
```

---

## 🛠️ Technologies Used

- **Terraform**
- **AWS**
- **Amazon EC2**
- **Amazon VPC**
- **AWS Security Groups**
- **AWS Data Sources**
- **Terraform Workspaces**
- **Terraform Variables**
- **Git & GitHub**

AWS Region:

```text
ap-south-1
```

---

## 📁 Project Structure

```text
terraform-multi-environment/
│
├── .gitignore
├── .terraform.lock.hcl
├── main.tf
├── output.tf
├── terraform.tf
├── variables.tf
├── terraform.tfvars.dev
└── terraform.tfvars.prod
```

### File Description

| File | Purpose |
|---|---|
| `terraform.tf` | Defines Terraform version requirements and AWS provider |
| `main.tf` | Contains AWS data sources, security group, and EC2 resources |
| `variables.tf` | Defines configurable Terraform variables |
| `output.tf` | Defines useful infrastructure outputs |
| `terraform.tfvars.dev` | Configuration values for Dev environment |
| `terraform.tfvars.prod` | Configuration values for Prod environment |
| `.terraform.lock.hcl` | Locks Terraform provider versions/checksums |
| `.gitignore` | Prevents Terraform state and local files from being committed |

---

## 🌎 Terraform Workspaces

The project uses separate Terraform workspaces for different environments.

Available workspaces:

```text
default
dev
prod
```

The `dev` and `prod` workspaces maintain **separate Terraform state**, allowing the environments to be managed independently while using the same Terraform configuration.

### Create Workspaces

```bash
terraform workspace new dev
terraform workspace new prod
```

### Switch Workspace

```bash
terraform workspace select dev
```

or:

```bash
terraform workspace select prod
```

### Check Current Workspace

```bash
terraform workspace show
```

### List Workspaces

```bash
terraform workspace list
```

---

## ⚙️ Environment Configuration

The project uses separate `.tfvars` files to provide different values for each environment.

### Development

```text
Instance Type: t3.micro
Instance Count: 1
Environment: dev
VPC CIDR: 10.10.0.0/16
Subnet CIDR: 10.10.1.0/24
```

### Production

```text
Instance Type: t3.small
Instance Count: 3
Environment: prod
VPC CIDR: 10.20.0.0/16
Subnet CIDR: 10.20.1.0/24
```

This allows the same Terraform code to be reused while changing infrastructure configuration between environments.

---

## 🔍 Terraform Data Sources

The project uses AWS Data Sources to discover existing AWS information instead of hardcoding resource IDs.

### 1. Default VPC

```hcl
data "aws_vpc" "default" {
  default = true
}
```

Finds the existing default VPC.

### 2. Availability Zones

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

Retrieves currently available Availability Zones in the selected AWS region.

### 3. Existing Subnets

```hcl
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
```

Finds subnets belonging to the discovered VPC.

### 4. Amazon Linux AMI

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  ...
}
```

Dynamically finds the latest matching Amazon Linux AMI instead of using a hardcoded AMI ID.

---

## 🖥️ Infrastructure Resources

### EC2 Instances

The number and instance type are controlled by variables.

Development:

```text
1 × t3.micro
```

Production:

```text
3 × t3.small
```

The EC2 instances use the Amazon Linux AMI discovered through a Terraform Data Source.

### Security Group

A security group is created for each environment.

It allows:

- HTTP traffic on port `80`
- SSH traffic on port `22`
- Outbound traffic

Each security group is tagged with the environment and project name.

---

## 🏷️ Resource Tagging

Resources are tagged using Terraform variables.

Example:

```hcl
tags = {
  Name        = "${var.project_name}-${var.environment}-app-${count.index + 1}"
  Environment = var.environment
  Project     = var.project_name
}
```

This makes it easier to identify resources belonging to each environment.

---

## 📤 Terraform Outputs

The project provides useful outputs after deployment:

- Current environment
- EC2 instance IDs
- EC2 public IP addresses
- EC2 public DNS names
- Security group ID

View outputs using:

```bash
terraform output
```

---

# 🚀 Getting Started

## 1. Initialize Terraform

```bash
terraform init
```

This initializes the Terraform working directory and downloads the required provider.

---

## 2. Format the Configuration

```bash
terraform fmt
```

Formats Terraform configuration files according to standard Terraform formatting.

---

## 3. Validate the Configuration

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically and structurally valid.

---

## 4. Select Development Workspace

```bash
terraform workspace select dev
```

---

## 5. Preview Development Infrastructure

```bash
terraform plan -var-file="terraform.tfvars.dev"
```

This shows what Terraform plans to create or change without actually modifying AWS infrastructure.

---

## 6. Deploy Development Environment

```bash
terraform apply -var-file="terraform.tfvars.dev"
```

Review the plan and type:

```text
yes
```

to create the infrastructure.

---

## 7. Deploy Production Environment

Switch to the production workspace:

```bash
terraform workspace select prod
```

Preview:

```bash
terraform plan -var-file="terraform.tfvars.prod"
```

Apply:

```bash
terraform apply -var-file="terraform.tfvars.prod"
```

---

## 🧹 Destroy Infrastructure

When the infrastructure is no longer required, it can be destroyed to avoid unnecessary AWS charges.

For Dev:

```bash
terraform workspace select dev
terraform destroy -var-file="terraform.tfvars.dev"
```

For Prod:

```bash
terraform workspace select prod
terraform destroy -var-file="terraform.tfvars.prod"
```

---

## ✅ Verification

Check the available workspaces:

```bash
terraform workspace list
```

Validate Terraform:

```bash
terraform validate
```

Format Terraform:

```bash
terraform fmt
```

View managed resources:

```bash
terraform state list
```

View outputs:

```bash
terraform output
```

Count Data Sources:

```bash
grep -c "^data " main.tf
```

---

## 📊 Dev vs Prod

| Configuration | Development | Production |
|---|---|---|
| Workspace | `dev` | `prod` |
| Instance Type | `t3.micro` | `t3.small` |
| Instance Count | 1 | 3 |
| Environment Tag | `dev` | `prod` |
| VPC CIDR | `10.10.0.0/16` | `10.20.0.0/16` |
| Subnet CIDR | `10.10.1.0/24` | `10.20.1.0/24` |
| State | Separate | Separate |

---

## 🔑 Key Terraform Concepts Demonstrated

### Infrastructure as Code

Terraform allows infrastructure to be defined using configuration files instead of manually creating resources through the AWS Console.

### Variables

Variables make Terraform configurations reusable and configurable.

### `.tfvars`

Environment-specific values are supplied through `.tfvars` files.

### Data Sources

Data sources allow Terraform to retrieve information about existing AWS resources.

### Resources

Resources define infrastructure that Terraform creates and manages.

### Workspaces

Workspaces provide separate Terraform state for different environments while reusing the same configuration.

### State

Terraform state keeps track of infrastructure managed by Terraform.

### Dependency Management

Terraform automatically determines dependencies between resources and data sources.

---

## 🔐 Security Considerations

The repository does not contain:

- AWS access keys
- Secret keys
- Terraform state files
- Private keys
- `.env` files

The `.gitignore` file prevents sensitive or unnecessary Terraform files from being committed.

For a production deployment, SSH access should also be restricted to trusted IP addresses instead of allowing SSH from the entire internet.

---
