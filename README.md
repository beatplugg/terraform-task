# Terraform Task

## Description

This repo is being used to set up an AWS EC2 instance with installation of Docker and further configuring of Grafana, Prometheus and Node Exporter in it. It imports the key into the AWS cloud, creates a security group (opens 22, 443, 80, 3000, 9100, 9090 incoming ports and allows all outgoing traffic), launches an AWS instance, downloads the necessary files from the repository (grafana provisioning, docker-compose,yml, prometheus configuration file and custom dashboard), installs Docker, Docker Compose on it , configures them and launches. Then it creates an Elastic IP and attaches it to the instance. Upon completion, it provides an output with the IP address of running machine. Docker Compose runs 3 containers: Grafana, Prometheus, Node Exporter, connects them into one network, mount the necessery volumes for provisioning (for example, uploads custom dashboard to grafana with linux metrics and configures it) and then you can access it using the Elastic IP address with port 3000.

## Prerequisites

- Clone the directory
- Run ssh-keygen in current directory and generate key-pair named terraform
- Edit variables.tf (access_key, secret_key, aws_region, ami_for_instance, etc.)
- Run terraform init and terraform apply 

## Technologies used

- Terraform
- Docker, Docker Compose
- Grafana
- Prometheus
- Node Exporter
- Git