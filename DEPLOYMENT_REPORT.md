# Mini InSAR Pipeline – AWS Cloud Deployment Report

**Author:** Taka
**Period:** November 2025
**Tech Stack:** Docker, AWS ECR, AWS ECS (Fargate), IAM, VPC, Terraform, Python (InSAR Processing)

## 1. Project Overview

This project demonstrates the deployment of a containerized Mini InSAR processing pipeline to the Amazon Web Services cloud using infrastructure-as-code (Terraform) and AWS ECS Fargate.

The goal was to build a fully reproducible cloud workflow capable of running an InSAR processing container in a serverless compute environment. This was my first complete AWS deployment starting from a free-tier account, making it an ideal proof of hands-on cloud engineering capability.

## 2. Architecture Summary

The system consists of the following cloud components:

### Core Components

| Component                     | Purpose                                                              |
| :---------------------------- | :------------------------------------------------------------------- |
| Docker Image                  | Containerized Mini InSAR pipeline (Python-based)                     |
| AWS ECR (Elastic Container Registry) | Private storage for the container image                              |
| AWS ECS (Fargate Launch Type) | Serverless task execution for the pipeline                           |
| IAM Roles (Task Execution Role) | Secure access to pull images & CloudWatch                            |
| Default VPC (Subnets, Route Tables) | Networking for ECS tasks                                             |
| Terraform                     | Declarative IaC used to create all cloud resources                   |

### Execution Flow

1.  Build Docker image locally
2.  Push image to AWS ECR
3.  Terraform deploys ECS infrastructure
4.  Fargate tasks run the InSAR container

This architecture mirrors modern industry standards for geospatial data pipelines and scientific batch jobs.

## 3. Deployment Steps (Actual Work Performed)

Below is the chronological series of tasks I completed.

### 3.1 Docker Image Build

-   Installed Python dependencies
-   Built and tagged the image
    ```bash
    docker build -t insar-demo .
    ```
-   Tagged and pushed to ECR
    ```bash
    docker tag insar-demo:latest <account>.dkr.ecr.<region>.amazonaws.com/insar-demo:latest
    docker push <account>.dkr.ecr.<region>.amazonaws.com/insar-demo:latest
    ```

### 3.2 AWS ECR Setup

-   Created private ECR repository `insar-demo`
-   Configured authentication using `aws ecr get-login-password`
-   Verified pushed layers in the ECR console

### 3.3 Terraform Infrastructure Deployment

Terraform files created:

-   `main.tf`
-   `ecs.tf`
-   `ecr.tf`
-   `iam.tf`
-   `variables.tf`

Main components:

-   ✔ ECS Cluster
-   ✔ Task Definition
-   ✔ Task Execution Role (IAM)
-   ✔ Log Group
-   ✔ ECS Service (Fargate)
-   ✔ Network configuration for default VPC

Executed with:

```bash
terraform init
terraform apply
```

### 3.4 ECS Fargate Task Execution

After deployment:

-   ECS attempted to pull the container image
-   Initial errors: `CannotPullContainerError`
-   Root cause: ECR repository was empty due to push/image tag mismatch
-   After correcting the tag & repo name, ECS successfully registered the task

This debugging demonstrates real-world familiarity with AWS container deployment issues.

### 3.5 Resource Cleanup (Cost Optimization)

To avoid charges:

-   Set ECS desired tasks = 0
-   Deleted ECS Service
-   Deleted ECS Cluster
-   Removed ECR repository (optional)
-   Verified Billing → Bills = $0.00
-   Confirmed no active compute/service resources

This is an important operational skill often evaluated in cloud roles.

## 4. Workflow Diagram

![Workflow Image](image.png)

## 5. Skills Demonstrated

### Cloud Engineering

-   Managed AWS ECS deployment end-to-end
-   Implemented IaC with Terraform
-   Understood IAM roles and least-privilege policies
-   Troubleshot ECR/ECS integration errors

### DevOps

-   Built and deployed production-ready Docker images
-   Used CI-like workflow with Terraform
-   Performed cost optimization and resource shutdown

### Geospatial / Scientific Computing

-   Containerized a Mini InSAR processing pipeline
-   Showcased ability to operationalize scientific workloads in the cloud

## 6. Key Achievement

Completed a full AWS cloud deployment cycle — from containerization, ECR upload, IaC provisioning, to Fargate execution — entirely from scratch, without using preconfigured AWS environments.

This is a strong, uncommon, and highly valuable skill set for GeoAI, scientific computing, and cloud engineering positions.

## 7. Suggested Resume Bullet Points (Copy/Paste)

### ✔ Cloud Deployment (AWS + Terraform)

-   Designed and deployed a serverless InSAR processing pipeline on AWS using Docker, ECR, ECS Fargate, IAM, and Terraform.
-   Built and pushed container images to AWS ECR and automated resource creation using infrastructure-as-code.
-   Resolved real-world deployment issues (ECR image pull errors, task definition mismatches, IAM permission troubleshooting).
-   Ensured cost optimization by shutting down unused ECS services and monitoring AWS billing.

### ✔ Scientific Computing + DevOps

-   Containerized a geospatial Mini InSAR workflow and executed it in a scalable cloud environment.
-   Applied modern DevOps practices (IaC, reproducible containers, cloud logs, automated provisioning) to scientific workflows.
