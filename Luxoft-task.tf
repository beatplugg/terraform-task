provider "aws" {
	access_key = "xxx"
	secret_key = "xxx"
	region = "eu-central-1"
}

resource "aws_key_pair" "terraform-task-key" {
	key_name = "terraform_key"
	public_key = file("./terraform.pub") 
}

resource "aws_security_group" "terraform-task-sg" {
  name        = "terraform-task-sg"
  description = "Opening ingress ports for ssh, https, http, grafana, prometheus"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform-task-instance" {
	ami = "ami-0ec7f9846da6b0f61"
	instance_type = "t2.micro"
	key_name = aws_key_pair.terraform-task-key.key_name
	vpc_security_group_ids = [aws_security_group.terraform-task-sg.id]
}

provisioner "file" {
    source      = "./dockerfiles/grafana/Dockerfile"
    destination = "/home/ubuntu/dockerfiles/grafana/Dockerfile"
  }

  provisioner "remote-exec" {
    inline = [
      "docker build -t grafana /home/ubuntu/dockerfiles/grafana",
      "docker run -d grafana"
    ]
  }

  provisioner "file" {

  source = "./dockerfiles/prometheus/Dockerfile"
  destination = "/home/ubuntu/dockefriles/prometheus/Dockerfile"
  }

  provisioner "remote-exec" {
  inline [
  "docker build -t prometheus /home/ubuntu/dockerfiles/prometheus
  "docker run -d prometheus"
  	]
  }


resource "aws_eip" "terraform-task-eip" {
	instance = aws_instance.terraform-task-instance.id	
}
