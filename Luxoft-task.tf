provider "aws" {
	access_key = "xxx"
	secret_key = "xxx"
	region = var.aws_region
}

resource "aws_key_pair" "terraform-task-key" {
	key_name = "terraform-key"
	public_key = file(var.path_to_ssh_key)
}

resource "aws_security_group" "terraform-task-sg" {
	name = "terraform-task-sg"
	description = "Opening ingress ports for ssh, https, http, grafana, prometheus, node exporter"

	ingress {
	from_port = 22
	to_port = 22
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
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	from_port = 3000
	to_port = 3000
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	from_port = 9090
	to_port = 9090
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	from_port = 9100
	to_port = 9100
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

resource "aws_instance" "terraform-task-instance" {
	ami = var.ami_for_instance
	instance_type = "t2.micro"
	key_name = aws_key_pair.terraform-task-key.key_name
	vpc_security_group_ids = [aws_security_group.terraform-task-sg.id]
	user_data = <<-EOF
	#!/bin/bash
	apt update
	apt install -y curl
	git clone --depth 1 https://github.com/beatplugg/terraform-task.git /home/ubuntu/docker-compose
	apt-get update
 	apt-get install ca-certificates gnupg 
 	install -m 0755 -d /etc/apt/keyrings
 	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 	chmod a+r /etc/apt/keyrings/docker.gpg
 	echo \
  	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  	tee /etc/apt/sources.list.d/docker.list > /dev/null
  	apt-get update
  	apt-get install -y docker-compose docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  	usermod -aG docker ubuntu
	systemctl enable docker
	systemctl start docker
	cd /home/ubuntu/docker-compose/
	docker-compose up -d
	EOF
}

resource "aws_eip" "terraform-task-eip" {
	instance = aws_instance.terraform-task-instance.id	
}

output "instance_ip" {
	value = aws_eip.terraform-task-eip.public_ip
}