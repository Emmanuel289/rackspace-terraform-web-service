# Launch template for creating instances
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
# launch templates are to be preferred over launch configurations in order to take advantage of versioning
# https://docs.aws.amazon.com/autoscaling/ec2/userguide/LaunchTemplates.html

resource "aws_launch_template" "dev_web" {
  description   = "Launch t2.micro instances in the subnets of the VPC"
  name          = "${var.name}-launch-template"
  image_id      = "ami-0a70476e631caa6d3"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.dev_web.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  # network_interfaces {
  #   associate_public_ip_address = true
  #   delete_on_termination       = true
  #   security_groups             = [aws_security_group.ec2_sg.id]
  # }

  lifecycle {
    create_before_destroy = true
  }

  user_data = filebase64("install_apache.sh")

  tags = var.tags

}

# SSH key
resource "aws_key_pair" "dev_web" {
  key_name   = "rackspace-ec2-key"
  public_key = file("ec2_key.pub")
}

# AutoScaling group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

resource "aws_autoscaling_group" "dev_web" {
  name                      = "${var.name}-asg"
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.dev_web.id]
  force_delete              = true
  enabled_metrics           = var.metrics
  vpc_zone_identifier       = module.vpc.private_subnets
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      load_balancers
    ]
  }

  launch_template {
    id      = aws_launch_template.dev_web.id
    version = "$Latest"
  }

  tag {
    key                 = "Rackspace"
    value               = "true"
    propagate_at_launch = "true"
  }
}

# Policy for scaling up
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.name}-scaleup"
  autoscaling_group_name = aws_autoscaling_group.dev_web.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
  policy_type            = "SimpleScaling"

}

# Policy for scaling down
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.name}-scaledown"
  autoscaling_group_name = aws_autoscaling_group.dev_web.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  policy_type            = "SimpleScaling"

}

# Elastic load balancer for registering instances
# Exactly one of availability_zones or subnets must be specified:
# this determines if the ELB exists in a VPC or in EC2-classic.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb

resource "aws_elb" "dev_web" {
  name            = "${var.name}-elb"
  subnets         = module.vpc.private_subnets
  security_groups = [aws_security_group.lb_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300

  tags = var.tags



}

# Load balancer attachment to connect load balancer to autoscaling group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment

resource "aws_autoscaling_attachment" "dev_web" {
  autoscaling_group_name = aws_autoscaling_group.dev_web.id
  elb                    = aws_elb.dev_web.id
}

