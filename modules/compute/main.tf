resource "azurerm_availability_set" "web_availabilty_set" {
  name                = "web_availabilty_set"
  location            = var.location
  resource_group_name = var.resource_group

  tags = {
    environment = "dev"
  }
}

data "azurerm_image" "magentovm" {
  name                = "magentovm"
  resource_group_name = "azimagevm"
}

output "image_id" {
  value = "/subscriptions/94ba27d6-505e-44e4-ae1d-0a39c5296f06/resourceGroups/azimagevm/providers/Microsoft.Compute/images/magentovm"
}

resource "azurerm_network_interface" "net-interface" {
    name = "dev-network"
    resource_group_name = var.resource_group
    location = var.location

    ip_configuration{
        name = "dev-webserver"
        subnet_id = var.web_subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "example" {
  network_interface_id    = azurerm_network_interface.net-interface.id
  ip_configuration_name   = "dev-webserver"
  backend_address_pool_id = var.backend_address_pool_id
}


resource "azurerm_virtual_machine" "dev-web" {
  name = "dev-web"
  location = var.location
  resource_group_name = var.resource_group
  network_interface_ids = [ azurerm_network_interface.net-interface.id ]
  availability_set_id = azurerm_availability_set.web_availabilty_set.id
  vm_size = "Standard_D2s_v3"
  delete_os_disk_on_termination = true
  
  storage_image_reference {
    id = data.azurerm_image.magentovm.id
  }

  storage_os_disk {
    name = "dev-webdisk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = var.host_name
    admin_username = var.username
    admin_password = var.os_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    "environment" = "dev"
  }
}


