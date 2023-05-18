variable "access_key" {
	description = "Access Key for AWS"
	type = string
	default = "XXX"
}

variable "secret_key" {
	description = "Secret Key for AWS"
	type = string
	default = "XXX"
}

variable "aws_region" {
	description = "AWS region"
	type = string
	default = "eu-central-1"
}

variable "path_to_ssh_key" {
	description = "Path to the ssh key"
	type = string
	default = "./terraform.pub"
}

variable "ami_for_instance" {
	description = "Ubuntu AMI id for AWS instance"
	type = string
	default = "ami-0ec7f9846da6b0f61"
}