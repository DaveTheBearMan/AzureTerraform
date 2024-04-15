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
    2. [Deploy a email server.](#EmailServer)
    3. [Deploy arbitrary VMs without grouping](#UbuntuServers)
4. [Main Configuration](#MainConfig)

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