provider "aws" {
  region = "us-east-1"
}
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}
// Use heredoc syntax to embed the JSON template directly
resource "aws_ecs_task_definition" "my_task_definition" {
  family                = "my-task-family"
  container_definitions = <<-EOT
    [
      {
        "name": "my-container",
        "image": "654654184219.dkr.ecr.us-east-1.amazonaws.com/capstone-ecr:latest",
        "cpu": 256,
        "memory": 512,
        "essential": true,
        "portMappings": [
          {
            "containerPort": 80,
            "hostPort": 80
          }
        ]
      }
    ]
  EOT
}
resource "aws_ecs_service" "my_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "EC2"
}
resource "aws_lb" "my_load_balancer" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0f30b0bacbc9f4274"]
  subnets            = ["subnet-052fe9b7b25fa5ccf", "subnet-012b59cc7b8d2083e", "subnet-008ab37ef625e3b2f", "subnet-0f067d5d685a84857", "subnet-084bfa02f76872182", "subnet-029644b9164317122"]
}
resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id = "vpc-08def81723f7f09d6"
}
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }
}
resource "aws_lb_target_group_attachment" "ecs_attachments" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = "i-0fcb238982c160e35" // Replace with your EC2 instance ID
}

/*resource "aws_route53_record" "my-webapp-dns" {
  depends_on = [aws_lb.my_load_balancer]  # Wait for the load balancer to be created
  zone_id = "Z00467372EQQ65KCHYK5R"
  name    = "www.princeokhaishie.com"
  type    = "CNAME"  # Use CNAME instead of A
  ttl     = "300"
  records = ["my-load-balancer-1287222695.us-east-1.elb.amazonaws.com"] # Use the DNS name created by the LB
}*/