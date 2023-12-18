resource "aws_security_group" "nmsWSSecurityGroup" {
  name        = "allow_ssh_http"
  description = "Allow ssh trafic"
  vpc_id      = var.nms_vpc_id


  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "nmsWSSecuritygroup"
    Project = "nmsProject"
  }
}

resource "aws_lb" "nmsLoadBalancer" {
  load_balancer_type = "application"
  subnets            = [var.nms_public_subnets[0].id, var.nms_public_subnets[1].id]
  security_groups    = [aws_security_group.nmsWSSecurityGroup.id]
  tags = {
    Name    = "nmsLoadBalancer"
    Project = "nmsProject"
  }

}

resource "aws_lb_listener" "nmsLblistener" {
  load_balancer_arn = aws_lb.nmsLoadBalancer.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.nmsTargetGroup.id
    type             = "forward"
  }

}

resource "aws_lb_target_group" "nmsTargetGroup" {
  name     = "trail-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.nms_vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name    = "nmsTargetGroup"
    Project = "nmsProject"
  }

}

resource "aws_lb_target_group_attachment" "ws1" {
  target_group_arn = aws_lb_target_group.nmsTargetGroup.arn
  target_id        = aws_instance.ws1.id
  port             = 80

}

resource "aws_lb_target_group_attachment" "ws2" {
  target_group_arn = aws_lb_target_group.nmsTargetGroup.arn
  target_id        = aws_instance.ws2.id
  port             = 80

}

resource "aws_instance" "ws1" {
  ami                         = local.ami_id
  instance_type               = local.instance_type
  key_name                    = local.key_name
  subnet_id                   = var.nms_public_subnets[0].id
  security_groups             = [aws_security_group.nmsWSSecurityGroup.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash -xe
              sudo su 
              yum update -y 
              yum install -y httpd 
              echo "<h1>Hello, World!</h1>server: nmsWS1" > /var/www/html/index.html 
              echo "healthy" > /var/www/html/hc.html 
              service httpd start
              EOF

}

resource "aws_instance" "ws2" {
  ami                         = local.ami_id
  instance_type               = local.instance_type
  key_name                    = local.key_name
  subnet_id                   = var.nms_public_subnets[1].id
  security_groups             = [aws_security_group.nmsWSSecurityGroup.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash -xe
              sudo su 
              yum update -y 
              yum install -y httpd 
              echo "<h1>Hello, World!</h1>server: nmsWS2" > /var/www/html/index.html 
              echo "healthy" > /var/www/html/hc.html 
              service httpd start
              EOF
}