resource "aws_lb" "AC2-alb" {
  name               = "AC2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.AC2-sg-alb.id]
  subnets            = [aws_subnet.AC2-subnet-public-a.id, aws_subnet.AC2-subnet-public-b.id]

  tags = {
    Name = "AC2-alb"
  }
}

resource "aws_lb_target_group" "AC2-tg" {
  name     = "AC2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.AC2-vpc.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  tags = {
    Name = "AC2-tg"
  }
}

resource "aws_lb_listener" "AC2-lb-listener" {
  load_balancer_arn = aws_lb.AC2-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.AC2-tg.arn
  }
}