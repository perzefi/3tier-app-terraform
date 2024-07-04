# Implementing a 3-Tier Architecture on AWS Using Terraform

![3-Tier Architecture on AWS](https://miro.medium.com/v2/resize:fit:4800/format:webp/1*a9g4OCJEw0xXDJQIb8xVqA.png)

Welcome to the repository for implementing a 3-tier architecture on AWS using Terraform. This project demonstrates how to set up a scalable and efficient infrastructure, leveraging the power of Terraform for automation.

## Prerequisites
AWS account with necessary permissions.
Terraform installed on your local machine.


## Overview

This project showcases the creation of a 3-tier architecture comprising:

1. **VPC**: A Virtual Private Cloud to isolate the network.
2. **Subnet**: Separate subnets for public and private layers.
3. **Route Tables**: Routing configuration to manage traffic flow.
4. **Security Groups**: Security rules for controlling access.
5. **EC2 Instances**: Compute resources for web, application, and database layers.
6. **ELB**: Elastic Load Balancer for distributing incoming traffic.
7. **RDS**: Managed Relational Database Service for persistent storage.

## Repository Structure

- **main.tf**: The main Terraform configuration file that ties together all other resources and modules.
- **var.tf**: Declares variables used throughout the Terraform configuration for parameterization and flexibility.
- **network.tf**: Sets up the networking components, including VPC, subnets, route tables, and internet gateways.
- **secgroup.tf**: Specifies the security groups used to control access to the different tiers of the architecture.
- **autoscaling.tf**: Manages the Auto Scaling groups and policies to handle the scalability of the application servers.
- **alb**.tf: Defines the AWS Application Load Balancer configuration, including listeners, target groups, and load balancer settings.
- **db.tf**: Configures the database resources, such as AWS RDS instances, including their settings and security groups.
- **output.tf**: Defines the outputs of the Terraform run, such as endpoint URLs or resource IDs.


## Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/perzefi/3tier-app-terraform.git
cd 3tier-app-terraform
terraform init #Initialize Terraform
terraform apply #review and Apply the configuration


## Conclusion
This repository provides necessary Terraform scripts to deploy a 3-tier architecture on AWS. For a detailed explanation, check out the full article on [Medium](https://medium.com/@perzefi/implementing-3-tier-architecture-on-aws-using-terraform-872007f7387a).
