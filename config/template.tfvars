# General
project_name                    = "litware"
location                        = "eastus2"
allowed_source_address_prefixes = ["1.2.3.4/32"] # Replace with your IP address

# Fabric capcity
create_fabric_capacity   = false # Set to true to create a fabric capacity
fabric_capacity_location = "brazilsouth"
fabric_capacity_sku_name = "F2"

# Application VM
vm_size            = "Standard_B2ats_v2"
vm_username        = "azureuser"
vm_public_key_path = "keys/temp_rsa.pub"
vm_image_publisher = "Canonical"
vm_image_offer     = "ubuntu-24_04-lts"
vm_image_sku       = "server"
vm_image_version   = "latest"

# Container Registry
acr_sku           = "Premium"
acr_admin_enabled = true
