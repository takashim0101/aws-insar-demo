# =========================================
# IAM Role for ECS Task Execution
# =========================================
resource "aws_iam_role" "ecs_task_execution" {
  name = "insar-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# =========================================
# ECS Cluster
# =========================================
resource "aws_ecs_cluster" "this" {
  name = "insar-cluster"
}

# =========================================
# ECS Task Definition
# =========================================
resource "aws_ecs_task_definition" "task" {
  family                   = "insar-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "insar-container"
      image     = "925047940439.dkr.ecr.ap-southeast-2.amazonaws.com/insar-demo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

# =========================================
# ECS Service
# =========================================
resource "aws_ecs_service" "service" {
  name            = "insar-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true

    # Sydney (ap-southeast-2) public subnets
    subnets = [
      "subnet-00f386c0218ef6237",
      "subnet-0f518a164d87b8e69",
      "subnet-0de848fc31915cda9"
    ]

    # security_groups omitted → default security group will be used
  }

  scheduling_strategy    = "REPLICA"
  wait_for_steady_state  = true
}
