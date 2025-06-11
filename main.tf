provider "aws" {
    region = var.region
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_key_pair" "web-infra-key" {
    key_name = var.key_name
    public_key = file(var.public_key_path)
}

resource "aws_security_group" "bastion_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "alb_sg" {
    name        = "alb-sg"
    description = "Allow HTTP"
    vpc_id      = aws_vpc.main.id

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.11.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "private-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.12.0/24"
    availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public-1.id
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_assoc_1" {
    subnet_id = aws_subnet.public-1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
    subnet_id = aws_subnet.public-2.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
}

resource "aws_route_table_association" "private_assoc_1" {
    subnet_id = aws_subnet.private-1.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
    subnet_id = aws_subnet.private-2.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_instance" "bastion" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = aws_key_pair.web-infra-key.key_name
    subnet_id = aws_subnet.public-1.id
    vpc_security_group_ids = [aws_security_group.bastion_sg.id]
    associate_public_ip_address = true

    tags = {
        Name = "Bastion"
    }
}

resource "aws_instance" "private_ec2_1" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = aws_key_pair.web-infra-key.key_name
    subnet_id = aws_subnet.private-1.id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    tags = {
        Name = "PrivateEC2-1"
    }
}

resource "aws_instance" "private_ec2_2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = aws_key_pair.web-infra-key.key_name
    subnet_id = aws_subnet.private-2.id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    tags = {
        Name = "PrivateEC2-2"
    }
}

resource "aws_lb" "app_alb" {
    name = "app-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet.public-1.id , aws_subnet.public-2.id]

    enable_deletion_protection = false

    tags = {
        Name = "App-alb"
    }
}

resource "aws_lb_target_group" "app_tg" {
    name = "app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id

    health_check {
        path = "/"
        protocol = "HTTP"
        interval = 30
        timeout = 5
        healthy_threshold = 3
        unhealthy_threshold = 2
    }

    tags = {
        Name = "App-tg"
    }
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.app_alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app_tg.arn
    }
}

resource "aws_launch_template" "app_lt" {
    name_prefix = "app_launch_template"
    instance_type = var.instance_type
    key_name = var.key_name
    image_id = data.aws_ami.ubuntu.id
    
    network_interfaces {
        security_groups = [aws_security_group.ec2_sg.id]
        associate_public_ip_address = false
    }
    
    user_data = base64encode(<<-EOF
       #!/bin/bash
       apt update -y
       apt install nginx -y
       echo "<h1>Hello World from Auto Scaling Group</h1>" > /var/www/html/index.html
       systemctl enable nginx
       systemctl start nginx
    EOF
    )

    tags = {
        name = "app-server"
    }
}

resource "aws_autoscaling_group" "app_asg" {
    desired_capacity = 2
    min_size = 1
    max_size = 3
    vpc_zone_identifier = [aws_subnet.private-1.id , aws_subnet.private-2.id]

    launch_template {
        id = aws_launch_template.app_lt.id
        version = "$Latest"
    }

    health_check_type = "EC2"
    health_check_grace_period = 30
    target_group_arns = [aws_lb_target_group.app_tg.arn]

    tag {
        key = "Name"
        value = "asg_app_instance"
        propagate_at_launch = true
    }

    lifecycle {
        create_before_destroy = true
    }
}