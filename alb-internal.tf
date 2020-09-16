resource "aws_lb" "ecs_internal" {
  count = var.alb_internal ? 1 : 0

  load_balancer_type = "application"
  internal           = true
  name               = "ecs-${var.name}-internal"
  subnets            = data.terraform_remote_state.vpc-project-dev.outputs.private_subnets

  security_groups = [
    aws_security_group.alb_internal[0].id,
  ]

  idle_timeout = 400

  dynamic "access_logs" {
    for_each = compact([var.lb_access_logs_bucket])

    content {
      bucket  = var.lb_access_logs_bucket
      prefix  = var.lb_access_logs_prefix
      enabled = true
    }
  }

  tags = {
    Name = "ecs-${var.name}-internal"
  }
}

resource "aws_lb_listener" "ecs_https_internal" {
  count = var.alb_internal ? 1 : 0

  load_balancer_arn = aws_lb.ecs_internal[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_internal_arn != "" ? var.certificate_internal_arn : var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_default_https_internal[0].arn
  }
}

resource "aws_lb_listener" "ecs_test_https_internal" {
  count = var.alb_internal ? 1 : 0

  load_balancer_arn = aws_lb.ecs_internal[0].arn
  port              = "8443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_internal_arn != "" ? var.certificate_internal_arn : var.certificate_arn

  default_action {
    type = "forward"
    #target_group_arn = aws_lb_target_group.ecs_replacement_https[0].arn
    target_group_arn = aws_lb_target_group.ecs_default_https_internal[0].arn
  }
}

# Generate a random string to add it to the name of the Target Group
resource "random_string" "alb_internal_prefix" {
  count   = var.alb_internal ? 1 : 0
  length  = 4
  upper   = false
  special = false
}

resource "aws_lb_target_group" "ecs_default_https_internal" {
  count = var.alb_internal ? 1 : 0

  name     = substr("ecs-${var.name}-int-default-https-${random_string.alb_internal_prefix[0].result}", 0, 32)
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc-project-dev.outputs.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}



