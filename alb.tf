# Application Load Balancer
resource "aws_lb" "lab_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
  }
}

# Target Group for Red instances
resource "aws_lb_target_group" "red_tg" {
  name     = "${var.project_name}-red-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/red/index.html"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-red-tg"
    Environment = var.environment
  }
}

# Target Group for Blue instances
resource "aws_lb_target_group" "blue_tg" {
  name     = "${var.project_name}-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/blue/index.html"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-blue-tg"
    Environment = var.environment
  }
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "red_attachment" {
  target_group_arn = aws_lb_target_group.red_tg.arn
  target_id        = aws_instance.red_instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "blue_attachment" {
  target_group_arn = aws_lb_target_group.blue_tg.arn
  target_id        = aws_instance.blue_instance.id
  port             = 80
}

# Load Balancer Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.lab_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red_tg.arn
  }
}

# Path-based routing rules
resource "aws_lb_listener_rule" "red_path_rule" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red_tg.arn
  }

  condition {
    path_pattern {
      values = ["/red*"]
    }
  }

  tags = {
    Name = "${var.project_name}-red-path-rule"
  }
}

resource "aws_lb_listener_rule" "blue_path_rule" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_tg.arn
  }

  condition {
    path_pattern {
      values = ["/blue*"]
    }
  }

  tags = {
    Name = "${var.project_name}-blue-path-rule"
  }
}

# Host-based routing rules
resource "aws_lb_listener_rule" "red_host_rule" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red_tg.arn
  }

  condition {
    host_header {
      values = ["red.${var.domain_name}"]
    }
  }

  tags = {
    Name = "${var.project_name}-red-host-rule"
  }
}

resource "aws_lb_listener_rule" "blue_host_rule" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 400

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_tg.arn
  }

  condition {
    host_header {
      values = ["blue.${var.domain_name}"]
    }
  }

  tags = {
    Name = "${var.project_name}-blue-host-rule"
  }
}