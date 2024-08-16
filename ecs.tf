resource "aws_ecs_cluster" "this" {
  name = "cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name  = "hello-world"
      image = "docker/welcome-to-docker"
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80,
          "protocol" : "tcp",
        }
      ],
    }
  ])
  cpu    = "512"
  memory = "1024"
}

resource "aws_ecs_service" "this" {
  name            = "service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id]
    assign_public_ip = true
  }
}
