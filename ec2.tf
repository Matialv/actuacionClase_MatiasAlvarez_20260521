resource "aws_launch_template" "AC2-lt" {
  name_prefix   = "AC2-lt-"
  image_id      = "ami-0a59ec92177ec3fad"
  instance_type = "t3.micro"
  key_name      = "vockey"

  user_data = filebase64("${path.module}/user_data.sh")

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.AC2-sg-ec2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "AC2-ec2-asg"
      ASG  = "true"
    }
  }
}

resource "aws_autoscaling_group" "AC2-asg" {
  name                = "AC2-asg"
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  vpc_zone_identifier = [aws_subnet.AC2-subnet-private-a.id, aws_subnet.AC2-subnet-private-b.id]
  target_group_arns   = [aws_lb_target_group.AC2-tg.arn]

  launch_template {
    id      = aws_launch_template.AC2-lt.id
    version = "$Latest"
  }

  depends_on = [
    aws_route_table_association.AC2-rta-private-a,
    aws_route_table_association.AC2-rta-private-b,
  ]

  tag {
    key                 = "ASG"
    value               = "true"
    propagate_at_launch = true
  }
}