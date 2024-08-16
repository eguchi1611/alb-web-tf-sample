resource "aws_ecs_cluster" "this" {
  name = "cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
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
