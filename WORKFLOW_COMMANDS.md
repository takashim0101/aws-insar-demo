# Workflow Commands

This document outlines the key commands used during the development and deployment of the Mini InSAR application on AWS ECS using Terraform and Docker. These commands serve as a practical guide and a record of the operational steps.

## 1. AWS ECR Login

Before building and pushing Docker images, authenticate Docker to your Amazon ECR registry. Replace `<YOUR_AWS_ACCOUNT_ID>` with your actual AWS account ID.

```bash
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com
```

## 2. Docker Image Management

These commands are executed from the project root directory (`/c/Portfolio/aws-insar-demo`).

### Build Docker Image

```bash
docker build -t insar-demo:latest .
```

### Tag Docker Image

Tag the built image with your ECR repository URI. Replace `<YOUR_AWS_ACCOUNT_ID>` with your actual AWS account ID.

```bash
docker tag insar-demo:latest <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/insar-demo:latest
```

### Push Docker Image to ECR

Push the tagged image to your ECR repository. Replace `<YOUR_AWS_ACCOUNT_ID>` with your actual AWS account ID.

```bash
docker push <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/insar-demo:latest
```

## 3. Terraform Infrastructure Management

These commands are executed from the `infra/` directory (`/c/Portfolio/aws-insar-demo/infra`).

### Initialize Terraform

Initializes a working directory containing Terraform configuration files.

```bash
terraform init
```

### Validate Terraform Configuration

Verifies the syntax and internal consistency of the Terraform configuration.

```bash
terraform
```

### Plan Infrastructure Changes

Generates an execution plan, showing what actions Terraform will take to achieve the desired state.

```bash
terraform plan
```

### Apply Infrastructure Changes

Applies the changes required to reach the desired configuration of the infrastructure.

```bash
terraform apply
```

### Destroy Infrastructure

Destroys all the infrastructure managed by the current Terraform configuration. Use with caution.

```bash
terraform destroy
```
