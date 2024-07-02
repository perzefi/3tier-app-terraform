variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "public_subnets" {
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnets" {
  default = ["10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
}

variable "ami_id" {
  default = "ami-08a0d1e16fc3f61ea"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "2webtier"
}

variable "cpu_threshold" {
  default = 50.0
}

