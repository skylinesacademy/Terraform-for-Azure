/*
Script used within the module: "Demo: Creating a Dev Environment in Terraform"

This deploys the Virtual Machine, once you have updated the script as shown in the module

Note this script deploys a virtual machine using the SSH keys as discussed in the video. This can be done using ssh-keygen, without a 
valid ssh key file this script will error. 
*/

provider "azurerm" {
  version         = "1.38.0"
  subscription_id = var.subscriptionID
}

resource "azurerm_virtual_machine" "SkylinesDevVM" {
  name                  = "skylinesvm"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = ["${var.network_interface_id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "skylinesdev01"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/azure.pub")
    }
  }
  tags = {
    environment = "staging"
  }
}