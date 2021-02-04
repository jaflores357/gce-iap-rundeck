# These terrafom script create all needs to run an instance with IAP Rundeck Access

loadbalancer.tf --> Create unmanaged instance group, backend services and all components required by the load balancer 

mysql.tf --> Create unmanaged MySQL server.

firewall.tf --> Configure basic firewall for the network

network.tf --> Define network, vpc, subnet, icmp firewall

provider.tf --> Configure Google Cloud provider

terraform.tfvars --> Defining variables 

variables.tf --> Application and authentication variables

vm.tf --> Create two Ubuntu VMs with Apache web server

# Notes

- Create domain name point to load balancer

- Create certificate and add into load balancer

- Set Up IAP

- https://cloud.google.com/iap/docs/tutorial-gce


