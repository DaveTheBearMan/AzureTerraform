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

When creating a resource group, thankfully all that is needed is a name and location when creating the module. This resource group can then be used to logically seperate resources in a given environment. For more information, read the write up here.

In this project, a resource group is defined as a moudle in the following way:
```tf
module "storage" {
  source                        = "./storage"

  // Resource Group
  resource_group_name           = var.resource_group_name
  resource_group_location       = var.resource_group_location
}
```

With the following outputs:
```tf
output "resource_group_name" {
  value = azurerm_resource_group.competition.name
}

output "resource_group_location" {
  value = azurerm_resource_group.competition.location
}
```