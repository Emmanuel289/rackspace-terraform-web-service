output "project_name" {
  description = "Name of Project"
  value       = var.name
}

output "project_tags" {
  description = "Tags to apply to resources in project"
  value       = var.tags

}

output "elb_instances" {

  description = "List of instances in the ELB"
  value       = aws_elb.dev_web.instances

}

output "elb_dns_name" {
  description = "DNS name of load balancer"
  value = aws_elb.dev_web.dns_name
}

output "private_subnets" {

  description = "List of private subnets"
  value = module.vpc.private_subnets

}

output "public_subnets" {

  description = "List of public subnets"
  value = module.vpc.public_subnets

}

output "health_check_type" {
  description = "Type of health check"
  value = aws_autoscaling_group.dev_web.health_check_type

}

output "vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value = aws_autoscaling_group.dev_web.vpc_zone_identifier

}

output "pub_key_name" {

  description = "public key name for SSH into EC2"
  value = aws_key_pair.dev_web.key_name
}

output "public_key" {
  description = "public key for SSH into EC2"
  value = aws_key_pair.dev_web.public_key

}