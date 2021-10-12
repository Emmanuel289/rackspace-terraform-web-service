# Registry module which creates AWS VPC resources
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = var.cidr-block

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Rackspace   = "true"
    Environment = "dev"
  }
}

# EC2 key-pair
# resource "aws_key_pair" "dev_web" {
#   key_name   = "${var.name}-key-pair"
#   public_key = "${file("~/.ssh/id_ed25519.pub")}"
# }



# AutoScaling group for EC2 instances
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

resource "aws_autoscaling_group" "dev_web" {
  # availability_zones  = var.availability_zones
  name = "${var.name}-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier = module.vpc.private_subnets

  # launch templates are to be preferred over launch configurations to ease versioning and access to
  # latest updates and features
  # https://docs.aws.amazon.com/autoscaling/ec2/userguide/LaunchTemplates.html

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

# AutoScaling policy for scaling up
resource "aws_autoscaling_policy" "scale_up" {
    name = "${var.name}-scaleup"
    autoscaling_group_name = aws_autoscaling_group.dev_web.id
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = 1
    cooldown = 60
    policy_type = "SimpleScaling"

}

# AutoScaling policy for scaling down
resource "aws_autoscaling_policy" "scale_down" {
    name = "${var.name}-scaledown"
    autoscaling_group_name = aws_autoscaling_group.dev_web.id
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = -1
    cooldown = 60
    policy_type = "SimpleScaling"

}

# Launch template for creating autoscaling group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template

resource "aws_launch_template" "dev_web" {
  name_prefix   = "dev-web"
  description   = "Launch t2.micro instances in the subnets of the VPC"
  image_id      = var.ami
  instance_type = "t2.micro"
  # key_name = aws_key_pair.dev_web.key_name

  tags = {
    Rackspace   = "true"
    Environment = "dev"
  }

}

# Load balancer attachment to connect load balancer to autoscaling group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment

resource "aws_autoscaling_attachment" "dev_web" {
  autoscaling_group_name = aws_autoscaling_group.dev_web.id
  elb                    = aws_elb.dev_web.id
}

# Elastic load balancer for registering web server instances
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb
resource "aws_elb" "dev_web" {
  name               = "rackspace-elb"
  # availability_zones = var.availability_zones
  subnets         = module.vpc.private_subnets
  security_groups = [aws_security_group.lb_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing = true



}


# Security group for EC2 instances

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow inbound http traffic only from load balancer"
  vpc_id      = module.vpc.vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Rackspace   = "true"
    Environment = "dev"
  }

}

# Security group for load balancer

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Allow inbound http traffic to load balancer from anywhere"
  vpc_id      = module.vpc.vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Rackspace   = "true"
    Environment = "dev"
  }

}









