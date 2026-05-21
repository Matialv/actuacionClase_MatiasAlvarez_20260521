resource "aws_security_group" "AC2-sg-alb" {
  name        = "AC2-sg-alb"
  description = "Allow HTTP from internet to ALB"
  vpc_id      = aws_vpc.AC2-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AC2-sg-alb"
  }
}

resource "aws_security_group" "AC2-sg-ec2" {
  name        = "AC2-sg-ec2"
  description = "Allow HTTP from ALB"
  vpc_id      = aws_vpc.AC2-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.AC2-sg-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AC2-sg-ec2"
  }
}