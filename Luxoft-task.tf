provider "aws" {
	access_key = "xxx"
	secret_key = "xxx"
	region = "eu-central-1"
}

resource "aws_instance" "terraform-task" {
	ami = "ami-0ec7f9846da6b0f61"
	instance_type = "t2.micro"
}