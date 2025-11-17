# AWS InSAR Demo

This project demonstrates a basic InSAR (Interferometric Synthetic Aperture Radar) mini-pipeline deployed on AWS using Amazon Elastic Container Service (ECS) with Fargate. The infrastructure is provisioned using Terraform.

## Project Structure

- `Dockerfile`: Defines the Docker image for the InSAR application.
- `hello_insar.py`: The core Python application for the InSAR mini-pipeline.
- `infra/`: Contains Terraform configurations for deploying the AWS infrastructure.
    - `ecr.tf`: Defines the Amazon Elastic Container Registry (ECR) repository.
    - `ecs.tf`: Configures the Amazon ECS cluster, task definition, and service using AWS Fargate.
    - `main.tf`: Specifies AWS provider details and required Terraform versions.
    - `.github/workflows/deploy.yml`: GitHub Actions workflow for continuous deployment.

## AWS Infrastructure

The following AWS services are provisioned and configured by Terraform:

- **Amazon ECR (Elastic Container Registry):** A private Docker image repository named `insar-demo` to store the application's container image.
- **Amazon ECS (Elastic Container Service):**
    - **ECS Cluster:** `insar-cluster` hosts the Fargate tasks.
    - **ECS Task Definition:** `insar-task` defines the container specifications (CPU, memory, network mode) for running the `hello_insar.py` application. The container `insar-container` uses the image from the `insar-demo` ECR repository and exposes port 8080.
    - **ECS Service:** `insar-service` maintains the desired count of running `insar-task` instances on AWS Fargate, ensuring the application is always available.
- **AWS IAM (Identity and Access Management):**
    - **IAM Role:** `insar-task-execution-role` provides the necessary permissions for ECS tasks to pull images from ECR and publish logs to CloudWatch.

## Workflow

This project implements a streamlined workflow for developing and deploying a mini InSAR application on AWS ECS using Terraform and Docker.

1.  **Develop Application:** Write and test the InSAR processing logic in Python (`hello_insar.py`).
2.  **Containerize:** Create a Dockerfile to package the application and its dependencies into a Docker image.
3.  **Build & Push Docker Image:** Build the Docker image and push it to Amazon ECR.
4.  **Define Infrastructure:** Use Terraform to define the AWS infrastructure, including ECR repositories, ECS clusters, task definitions, and services.
5.  **Deploy Infrastructure:** Apply Terraform configurations to provision and update the AWS resources.
6.  **Run on ECS Fargate:** The containerized application runs on AWS ECS using Fargate, providing serverless compute for containers.

![Mini InSAR Development Workflow](image.png)



## Getting Started

### Prerequisites

- AWS Account
- AWS CLI configured with appropriate permissions
- Terraform (v1.0.0 or higher)
- Docker

### Deployment

1.  **Build and Push Docker Image:**
    Build the Docker image for the `hello_insar.py` application and push it to the ECR repository.
    ```bash
    # Authenticate Docker to your ECR registry
    aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 925047940439.dkr.ecr.ap-southeast-2.amazonaws.com

    # Build the Docker image
    docker build -t insar-demo .

    # Tag the image
    docker tag insar-demo:latest 925047940439.dkr.ecr.ap-southeast-2.amazonaws.com/insar-demo:latest

    # Push the image to ECR
    docker push 925047940439.dkr.ecr.ap-southeast-2.amazonaws.com/insar-demo:latest
    ```

2.  **Deploy Infrastructure with Terraform:**
    Navigate to the `infra/` directory and apply the Terraform configuration.
    ```bash
    cd infra/
    terraform init
    terraform plan
    terraform apply
    ```

3.  **Verify Deployment:**
    After successful deployment, you can check the status of your ECS cluster, service, and tasks in the AWS Management Console.

## Application Details

The `hello_insar.py` is a simple Python script that prints a message, serving as a placeholder for a more complex InSAR processing pipeline. It's designed to run as a containerized application on AWS Fargate.

## Contributing

Feel free to fork this repository and contribute to enhance the InSAR pipeline or improve the infrastructure.

## License

This project is licensed under the MIT License.

## Detailed Portfolio Document

For a more in-depth explanation of the workflow, code, and deployment steps, please refer to the [PORTFOLIO.md](PORTFOLIO.md) document.

## AWS Cloud Deployment Report

For a detailed report on the AWS cloud deployment, including architecture, deployment steps, and demonstrated skills, please refer to the [DEPLOYMENT_REPORT.md](DEPLOYMENT_REPORT.md) document.


