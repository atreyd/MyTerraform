variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-south-1"
}

variable "pub_ami" {
    description = "AMI to use for an instance running with Jenkins/Ansible in Public Subnet"
    default = {
        ap-south-1 = "ami-d783a9b8" # ubuntu 14.04 LTS
    }
}

variable "pri_ami" {
    description = "AMI to use for an instance running with Docker Private Subnet"
    default = {
        ap-south-1 = "ami-5a8da735" # Linux Ami with Docker
    }
}
  
variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "170.20.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "170.20.10.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "170.20.20.0/24"
}