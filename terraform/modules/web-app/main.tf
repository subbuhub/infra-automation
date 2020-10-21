locals {
  web-app-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
docker run -d -p 80:8080 "${var.web_app.docker_image}"

USERDATA
}


resource "aws_launch_configuration" "web_app_lc" {
  associate_public_ip_address = true
  key_name        = var.key_pair_name
  image_id        = var.ami
  instance_type   = var.web_app.instance_type
  name_prefix     = "${var.application}-${var.environment}-web-app-lc"
  security_groups = [aws_security_group.web_app_sg.id]

  root_block_device {
    volume_size = var.web_app.volume_size
    volume_type = var.web_app.volume_type
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data_base64 = base64encode(local.web-app-userdata)

  depends_on = [var.key_pair_name]
}

resource "aws_autoscaling_group" "web_app_asg" {
  desired_capacity     = var.web_app.asg_desired_capacity
  launch_configuration = aws_launch_configuration.web_app_lc.id
  max_size             = var.web_app.asg_max_size
  min_size             = var.web_app.asg_min_size
  name                 = "${var.application}-${var.environment}-web-app-asg"

  vpc_zone_identifier  = [ var.public_subnet_ids[0], var.public_subnet_ids[1] ]

  tag {
    key                 = "Name"
    value               = "${var.application}-${var.environment}-web-app"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [var.public_subnet_ids,aws_launch_configuration.web_app_lc]
}

resource "aws_security_group" "web_app_sg" {
  name        = "${var.application}-${var.environment}-web-app-sg"
  description = "${var.application} ${var.environment} web app sg"
  vpc_id      = var.vpc_id

  depends_on = [var.vpc_id, aws_security_group.web_app_sg]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.application}-${var.environment}-web-app-sg"
  }
}

resource "aws_security_group_rule" "web_app_80" {
  description              = "app-elb-80"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_app_sg.id
  source_security_group_id = aws_security_group.web_app_elb.id
  to_port                  = 80
  type                     = "ingress"
}

resource "aws_security_group_rule" "web_app_22" {
  description              = "app-sg-22"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_app_sg.id
  cidr_blocks              = var.ssh_whitelist_ips
  to_port                  = 22
  type                     = "ingress"
}

data "aws_instances" "app_node_data" {
  depends_on = [ aws_autoscaling_group.web_app_asg ]
  instance_tags = {
    Name = "${var.application}-${var.environment}-web-app"
  }

  instance_state_names = ["running", "stopped" ]
}

# Create a new load balancer
resource "aws_lb" "web_app_elb" {
  name            = "${var.application}-${var.environment}-web-app-elb"
  security_groups = [aws_security_group.web_app_elb.id]
  subnets         = var.public_subnet_ids
  load_balancer_type = "application"
  internal           = false

  depends_on = [ var.public_subnet_ids, aws_security_group.web_app_elb ]

  enable_cross_zone_load_balancing = true
  idle_timeout                     = 300

  tags = {
    Name = "${var.application}-${var.environment}-web-app-elb"
  }
}

resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.web_app_elb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_target_group.arn
  }

  depends_on = [aws_lb_target_group.web_app_target_group]
}

resource "aws_lb_target_group" "web_app_target_group" {
  name     = "web-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled  = true
    interval = 30
    path     = "/"
    port     = 80
    protocol = "HTTP"
    healthy_threshold = 5
    matcher = 200
  }
}

resource "aws_lb_target_group_attachment" "test" {
  depends_on = [aws_lb_target_group.web_app_target_group]
  count      = var.web_app.asg_desired_capacity
  target_group_arn = aws_lb_target_group.web_app_target_group.arn
  target_id        = data.aws_instances.app_node_data.ids[count.index]
  port             = 80
}

resource "aws_security_group" "web_app_elb" {
  name        = "${var.application}-${var.environment}-web-app-elb-sg"
  description = "${var.application} ${var.environment} web app elb sg"
  vpc_id      = var.vpc_id

  depends_on = [var.vpc_id]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.application}-${var.environment}-web-app-elb-sg"
  }
}

resource "aws_security_group_rule" "web_app_elb_80" {
  description       = "whitelisted-IPs"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.web_app_elb.id
  cidr_blocks       = var.web_app_elb_whitelist
  to_port           = 80
  type              = "ingress"
}

