# Security Groups
resource "aws_security_group" "alb_sg" {
  name   = "itss-ojt-Cajayon-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
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
    Environment    = "Sandbox"
    Resource_Types = "Instances Volumes Network_Interfaces"
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "itss-ojt-Cajayon-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["sg-0cd8f93d5b33bbe24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment    = "Sandbox"
    Resource_Types = "Instances Volumes Network_Interfaces"
  }
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "itss-ojt-Cajayon-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0cd8f93d5b33bbe24"]
  subnets            = var.public_subnet_ids

  tags = {
    Environment    = "Sandbox"
    Resource_Types = "Instances Volumes Network_Interfaces"
  }
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "itss-ojt-Cajayon-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Environment    = "Sandbox"
    Resource_Types = "Instances Volumes Network_Interfaces"
  }
}

# ALB HTTP Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  tags = {
    Environment    = "Sandbox"
    Resource_Types = "Instances Volumes Network_Interfaces"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami             = "ami-039454f12c36e7620"  # Replace with a valid AMI ID
  instance_type   = var.instance_type
  subnet_id       = var.private_subnet_ids[0]
  security_groups = ["sg-0f24a18c1aefde757"]

  tags = {
    Name            = "itss-ojt-Cajayon-ec2-v2"
    Environment     = "Sandbox"
    backup          = "no"
    Schedule        = "running"
    Patch           = "No"
    Resource_Types  = "Instances Volumes Network_Interfaces"
  }
}

# Register EC2 with Target Group
resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}