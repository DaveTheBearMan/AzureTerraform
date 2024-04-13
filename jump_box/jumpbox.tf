resource "azurerm_public_ip" "competition_box_ip" {
  name                = "CompetitionIpAddress"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
}

// Establish a NIC
resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "jumpbox-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.internal_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.competition_box_ip.id
  }
}

// Attach security group to the nic
resource "azurerm_network_interface_security_group_association" "nic_sec_association" {
  network_interface_id      = azurerm_network_interface.jumpbox_nic.id
  network_security_group_id = var.network_security_group_id
}

// Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.jumpbox_nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.ubuntu_image_properties.publisher
    offer     = var.ubuntu_image_properties.offer
    sku       = var.ubuntu_image_properties.sku
    version   = var.ubuntu_image_properties.version
  }
  storage_os_disk {
    name              = "competitionOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_credentials.username
    admin_password = var.admin_credentials.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}