# Mini InSAR Deployment on AWS ECS using Terraform & Docker

## Project Overview

This project demonstrates an end-to-end deployment of a small InSAR (Interferometric Synthetic Aperture Radar) demo application using AWS services:

-   **Terraform** for Infrastructure as Code (ECS Cluster, Service, Task Definitions, IAM Roles)
-   **Docker** for containerizing the Python application
-   **AWS ECS Fargate** for serverless container execution

The goal: deploy a containerized Python application to AWS ECS in a fully automated, reproducible way.

## Workflow

### Step 1: Initialize Terraform

```bash
PS C:\Portfolio\aws-insar-demo\infra> terraform init
Terraform has been successfully initialized!
```

### Step 2: Validate Terraform Configuration

```bash
PS C:\Portfolio\aws-insar-demo\infra> terraform validate
Success! The configuration is valid.
```

### Step 3: Plan Infrastructure

```bash
PS C:\Portfolio\aws-insar-demo\infra> terraform plan
Plan: 3 to add, 0 to change, 0 to destroy.
```

### Step 4: Apply Infrastructure

```bash
PS C:\Portfolio\aws-insar-demo\infra> terraform apply
Do you want to perform these actions? Enter a value: yes
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

### Step 5: Build Docker Container

```bash
PS C:\Portfolio\aws-insar-demo> docker build -t insar-demo:latest .
```

### Step 6: Deploy ECS Service

Terraform automatically creates:

-   ECS Cluster (`insar-cluster`)
-   Task Definition (`insar-task`)
-   Fargate Service (`insar-service`) with proper networking

## Key Terraform Code

### ECS Cluster & Task Definition

```terraform
resource "aws_ecs_cluster" "this" {
  name = "insar-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "insar-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name         = "insar-container"
      image        = "925047940439.dkr.ecr.ap-southeast-2.amazonaws.com/insar-demo:latest"
      essential    = true
      portMappings = [{ containerPort = 8080, hostPort = 8080 }]
    }
  ])
}
```

### ECS Service

```terraform
resource "aws_ecs_service" "service" {
  name            = "insar-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    subnets          = ["<your-subnet-id>"]
  }
}
```

### Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY hello_insar.py .
CMD ["python", "hello_insar.py"]
```

## Workflow Diagram (Concept)

```
+----------------+       +----------------+       +----------------+
| Docker Build   |  -->  | Push to ECR    |  -->  | Terraform Apply |
| insar-demo:latest |     | insar-demo repo|       | ECS Cluster/Service|
+----------------+       +----------------+       +----------------+
                                         |
                                         v
                                 +----------------+
                                 | ECS Fargate    |
                                 | Task Runs      |
                                 | insar-container|
                                 +----------------+
```

### Explanation:

-   Docker build produces a container image (`insar-demo:latest`).
-   Image is pushed to AWS ECR repository.
-   Terraform creates ECS cluster, Fargate service, task definitions, and IAM roles.
-   ECS Fargate launches the container using the task definition.

## Portfolio Highlights

-   Automated infrastructure deployment using Terraform
-   Configured IAM roles for ECS task execution
-   Built and deployed containerized Python application
-   Managed networking (VPC, subnets) and ECS configuration
-   Demonstrated troubleshooting and state management in Terraform
-   Clear, reproducible DevOps workflow

## Detailed Workflow Commands

For a comprehensive list of the commands used to set up and manage this workflow, including Docker and Terraform operations, please refer to the [WORKFLOW_COMMANDS.md](WORKFLOW_COMMANDS.md) document.

