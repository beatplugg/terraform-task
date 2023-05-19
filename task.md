# Terraform

## Requirements:

- Create a _Terraform_ module for provisioning one _AWS_/_Azure_/_GCP_/_OCI_/... (cloud provider of your choice) compute instance (VM);
- Provision one SSH public key for the created instance;
- Provision and attach static IP to the instance;
- Install and configure docker on the instance;
- Run _Grafana_ container in _Docker_ so that it is accessible from the web, i.e. `http://<IP-ADDRESS>:<PORT>/dashboards`;
- Provide instructions along with the code on _GitHub_ (or other VCS platform of your choice).

### Additional:

- Make use of varibales;
- Make use of outputs.

## Optional:

- Make use of _Ansible_ playbooks for configuration management;
- Add custom _Grafana_ dashboards to observe specific metrics.