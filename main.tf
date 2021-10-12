
# # Define VPC configuration
# resource "aws_vpc" "prod_web" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     "Name" : "rackspace-vpc"
#   }
# }


# # Define configuration for public subnet
# resource "aws_subnet" "az1" {
#   vpc_id            = aws_vpc.prod_web.id
#   cidr_block        = "10.0.0.0/24"
#   availability_zone = "ca-central-1a"

#   tags = {
#     "Name" : "rackspace-public"
#   }
# }

# # Define configuration for private subnet
# resource "aws_subnet" "az2" {

#   vpc_id            = aws_vpc.prod_web.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "ca-central-1b"

#   tags = {
#     "Name" : "rackspace-private"
#   }

# }


# Terraform module which creates VPC resources on AWS
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


# Security group for load balancer

resource "aws_security_group" "dev_web" {
  name        = "dev-web"
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

# Launch template for creating autoscaling group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template

resource "aws_launch_template" "dev_web" {
  name_prefix   = "dev-web"
  description   = "Launch t2.micro instances in the subnets of the VPC"
  image_id      = "ami-02e136e904f3da870"
  instance_type = "t2.micro"

  tags = {
    Rackspace   = "true"
    Environment = "dev"
  }

}

# AutoScaling group for EC2 instances
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

resource "aws_autoscaling_group" "dev_web" {
  # availability_zones  = var.availability_zones
  vpc_zone_identifier = module.vpc.private_subnets
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

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
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.dev_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


}

