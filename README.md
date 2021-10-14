# rackspace-terraform-web-service
This repository contains submissions for Approach 1 Using Terraform and scripting.

# Setup

- Clone the repository https://github.com/Emmanuel289/rackspace-terraform-web-service.git.
- Open a terminal and navigate to the root directory. Run the following commands and enter "yes" to approve the actions after confirming the deployment plan.
```
terraform init   #  Updates the terraform modules and required providers
terraform plan  # Optional: run terraform plan -out <design.plan> to save the deployment plan to an output file named <design-plan>
terraform apply # Apply the actions in the plan
```

# Components

- The ``` vpc.tf``` files contains configuration for a VPC that is deployed in the Canada-Central region. The VPC is allocated with the 10.0.0.0/16 CIDR block.
- The VPC spans 3 availability zones and comprises 3 /24 public subnets and 3 /24 private subnets.
- A pair of public and private subnets live in an availability zone and a NAT gateway is attached to each public subnet.
- An Autoscaling group is configured with a launch template for EC2 instances. Scaling policies are configured to resize the number of instances according to a cpu utilization threshold of 75 %. The associated CloudWatch alarms for the scaling events are configured in ```alarms.tf```.
- An Elastic load balancer is used to register the instances within the autoscaling group.
- A security group that allows HTTP traffic to the load balancer from anywhere (not directly to the instance(s)) is configured.
- A security group that allows only HTTP traffic from the load balancer to the instances(s) is configured.
- ```install_apache.sh``` installs an apache web server on an instance when it comes into service.






