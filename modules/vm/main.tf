resource "azurerm_public_ip" "default" {
  name                = "pip-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "default" {
  name                = "nic-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.default.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_linux_virtual_machine" "default" {
  name                  = "vm-${var.workload}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.size
  admin_username        = var.username
  network_interface_ids = [azurerm_network_interface.default.id]

  custom_data = filebase64("${path.module}/custom_data/ubuntu.sh")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = var.username
    public_key = file(var.public_key_path)
  }

  os_disk {
    name                 = "osdisk-linux-${var.workload}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}
