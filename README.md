# These terrafom script create all needs to run an instance with IAP Web Access

lb-unmanaged.tf --> Create unmanaged instance group, backend services and all components required by the load balancer 

network-firewall.tf --> Configure basic firewall for the network

network-variables.tf --> Define network variables

network.tf --> Define network, vpc, subnet, icmp firewall

provider.tf --> Configure Google Cloud provider

terraform.tfvars --> Defining variables 

variables-auth.tf --> Application and authentication variables

vm-output.tf --> Output of VMs 

vm.tf --> Create two Ubuntu VMs with Apache web server

# Notes

- Create domain name point to load balancer

- Create certificate and add into load balancer

- Set Up IAP

- https://cloud.google.com/iap/docs/tutorial-gce