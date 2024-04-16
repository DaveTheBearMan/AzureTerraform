# AzureCompetitionTest
This repository contains the terraform I have written to make easy cloud deployments for various personal projects, including but not limited too:
- Virtual Network
- Mail Server
- SSH Jump Box
- Arbitrary VMs

# Table of Contents
1. Storage Groups
    1. [Creating a storage group](#ResourceGroup)
2. Network Deployment
    1. [Deploying a network](#Network)
3. VM Deployment
    1. [Deploy a jump box.](#Jumpbox)

# ResourceGroup

When creating a resource group, thankfully all that is needed is a name and location when creating the module. This resource group can then be used to logically seperate resources in a given environment. For more information, read the write up [here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal).

In this project, a resource group is defined as a moudle in the following way:
```tf
module "storage" {
  source                        = "./storage"

  // Resource Group
  resource_group_name           = var.resource_group_name
  resource_group_location       = var.resource_group_location
}
```

Providing the following outputs:
```tf
output "resource_group_name" {
  value = azurerm_resource_group.competition.name
}

output "resource_group_location" {
  value = azurerm_resource_group.competition.location
}
```

# Network
A network in Azure has a lot of modularity in terms of connecting fire walls, in some more expensive configurations microsoft defender and monitor, as well as DDoS Protection and Peerings (two or more connected virtual networks). However, in the configuration I am running VMs have their own firewall rules applied and as it stands the network-wide firewall does not yet exist.

The configuration I currently run for firewall rules is very barebones, allowing only particular IP addresses and limited publicly facing virtualization. As well, even on internal virtual machines ports are locked down. 

Creating a virtual network is as easy as a resource group, requiring only:
```tf
module "network" {
  source                        = "./network"

  // Resource Group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location
}
```

Providing the following outputs:
```tf
output "virtual_network" {
  value = azurerm_virtual_network.main.id
}

output "internal_subnet" {
  value = azurerm_subnet.internal.id
}

output "SSHSecurity" {
  value = azurerm_network_security_group.SSHSecurity.id
}

output "InternalSecurity" {
  value = azurerm_network_security_group.InternalSecurity.id
}

output "MailSecurity" {
  value = azurerm_network_security_group.MailServer.id
}

output "WindowsSecurity" {
  value = azurerm_network_security_group.WindowsFirewall.id
}
```

You'll notice that included in the output for a virtual network is the existing firewall configurations. This is because with so few present firewall configurations, it would not provide an exceptional benefit to seperate a firewall file. As the project grows however, this path will certainly be persued. 

# JumpBox
Below is example code that would create a resource group, a virtual network and a subnet to place both VMs in. Further, it would then assign a public IP to one of the boxes to accept incoming network traffic, while denying outside connection to the inside box. This could easily be scaled up by increasing count to however many VMs was required, but, this should only be done to a certain point and for good reason as there is a seperate resource for creating mass VMs all of the same type, with less overhead.
```tf
# Module blocks
module "storage" {
  source                        = "./storage"

  // Resource Group
  resource_group_name           = var.resource_group_name
  resource_group_location       = var.resource_group_location
}

module "network" {
  source                        = "./network"

  // Resource Group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location
}

module "jump_box" {
  source                        = "./jump_box"

  // Resource group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location

  // Network
  network_interface_id          = module.network.virtual_network
  internal_subnet_id            = module.network.internal_subnet
  network_security_group_id     = module.network.SSHSecurity
}

module "internal_vm" {
  source                        = "./internal_vm"
  count                         = 1

  // Resource group
  resource_group_name           = module.storage.resource_group_name
  resource_group_location       = module.storage.resource_group_location

  // Network
  network_interface_id          = module.network.virtual_network
  internal_subnet_id            = module.network.internal_subnet
  network_security_group_id     = module.network.InternalSecurity
}
```