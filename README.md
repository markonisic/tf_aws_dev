# Terraform AWS EC2/VPC/SSH template
---
This repo will contain a template written in Terraform(HCL) to deploy
on AWS a new VPC, with a public subnet, security groups, internet gateway,
a route table, SSH connection configured and SSH parameteres written in the
local SSH config.
---
- EC2 instance will be deployed with an Ubuntu 18.04 image,
and running Docker.
- Local SSH pub key will be added to the EC2 instance and the login parameters
will be written in the local SSH config.
