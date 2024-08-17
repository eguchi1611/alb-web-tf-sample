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
  desired_count   = 2

  network_configuration {
    subnets          = [aws_subnet.public-1a.id, aws_subnet.public-1c.id, aws_subnet.public-1d.id]
  }

  load_balancer {
    container_name   = "hello-world"
    container_port   = 80
    target_group_arn = aws_lb_target_group.this.arn
  }
}
