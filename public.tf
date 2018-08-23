/*
  VB Servers
*/
resource "aws_security_group" "VB" {
    name = "SG_Public VM"
    description = "Security group for Instances in Public subnet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "Custom TCP Rule"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "ssh"
        cidr_blocks = ["0.0.0.0/0"]    
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "PubSubSG"
    }
}
resource "aws_instance" "Local_VM_Pub" {
    ami = "${lookup(var.pub_ami, var.aws_region)}"
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.VB.id}"]
    subnet_id = "${aws_subnet.ap-south-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
        sudo yum install java-1.8.0 -y
        sudo yum install jenkins -y
        sudo service jenkins start
        sudo amazon-linux-extras install ansible2
        sudo yum install maven -y
        EOF

    tags {
        Name = "Local_VM_Pub"
    }
}

resource "aws_eip" "Local_VM_Pub" {
    instance = "${aws_instance.Local_VM_Pub.id}"
    vpc = true
}