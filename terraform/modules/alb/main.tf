# Пример ALB (если понадобится)
resource "aws_lb" "this" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.subnet_id]
}