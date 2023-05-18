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
	protocol "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "terraform-task-instance" {
	ami = var.ami_for_instance
	instance_type = "t2.micro"
	key_name = aws_key_pair.terraform-task-key.key_name
	vpc_security_group_ids = [aws_security_group.terraform-task-sg.id]
	user_data = <<EOF
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install -y ca-certificates curl gnupg 
	mkdir -p /home/ubuntu/docker-compose/ 
	curl -o /home/ubuntu/docker-compose/docker-compose.yml https://github.com/beatplugg/terraform-task/raw/master/docker-compose.yml && curl -o /home/ubuntu/docker-compose/prometheus.yml https://github.com/beatplugg/terraform-task/raw/master/prometheus.yml
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo \
  	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  	sudo apt-get update
  	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  	sudo usermod -aG docker $USER
	sudo systemctl enable docker
	sudo systemctl start docker
	docker build -t grafana /home/ubuntu/dockerfiles/grafana
	docker run -d grafana
	docker build -t prometheus /home/ubuntu/dockerfiles/prometheus
	docker run -d prometheus
	EOF
}

resource "aws_eip" "terraform-task-eip" {
	instance = aws_instance.terraform-task-instance.id	
}

output "instance_ip" {
	value = aws_eip.terraform-task-eip.public_ip
}