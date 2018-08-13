/*
  Database Servers
*/
resource "aws_security_group" "LB" {
    name = "Child Local Machine"
    description = "Linux Machine- Docker/Tomcat to run the artefact created by CI BOX in Public subnet"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.vpc_cidr}"]
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
        Name = "LocalVM"
    }
}

resource "aws_instance" "LB-1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "ap-south-1a"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.LB.id}"]
    subnet_id = "${aws_subnet.ap-south-1a-private.id}"
    source_dest_check = false

    tags {
        Name = "Local VM 1"
    }
}