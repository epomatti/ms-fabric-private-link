terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.15.0"
    }
  }
}

resource "random_integer" "generated" {
  min = 000
  max = 999
}

locals {
  affix    = random_integer.generated.result
  workload = "${var.project_name}${local.affix}"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}-workload"
  location = var.location
}

module "vnet" {
  source              = "./modules/network/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "nsg" {
  source                          = "./modules/network/nsg"
  workload                        = local.workload
  resource_group_name             = azurerm_resource_group.default.name
  location                        = azurerm_resource_group.default.location
  compute_subnet_id               = module.vnet.compute_subnet_id
  allowed_source_address_prefixes = var.allowed_source_address_prefixes
}

module "pls_fabric" {
  source            = "./modules/privatelink/services/fabric"
  count             = var.create_fabric_private_link ? 1 : 0
  location          = azurerm_resource_group.default.location
  resource_group_id = azurerm_resource_group.default.id
}

module "ple_fabric" {
  source              = "./modules/privatelink/endpoints/fabric"
  count               = var.create_fabric_private_link ? 1 : 0
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  vnet_id             = module.vnet.vnet_id
  subnet_id           = module.vnet.private_endpoints_subnet_id
  fabric_pls_id       = module.pls_fabric[0].id
}

module "acr" {
  source                          = "./modules/acr"
  workload                        = local.workload
  resource_group_name             = azurerm_resource_group.default.name
  location                        = azurerm_resource_group.default.location
  sku                             = var.acr_sku
  admin_enabled                   = var.acr_admin_enabled
  allowed_source_address_prefixes = var.allowed_source_address_prefixes
}

module "ple_acr" {
  source              = "./modules/privatelink/endpoints/acr"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  vnet_id             = module.vnet.vnet_id
  subnet_id           = module.vnet.private_endpoints_subnet_id
  acr_id              = module.acr.id
}

module "vm" {
  source              = "./modules/vm"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  subnet_id       = module.vnet.compute_subnet_id
  size            = var.vm_size
  username        = var.vm_username
  public_key_path = var.vm_public_key_path

  image_publisher = var.vm_image_publisher
  image_offer     = var.vm_image_offer
  image_sku       = var.vm_image_sku
  image_version   = var.vm_image_version
}

resource "azurerm_role_assignment" "acr_vm_role_assignment" {
  # Allows the Virtual Machine to pull images from the Azure Container Registry
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.vm.managed_identity_principal_id
}

module "fabric_capacity" {
  source                   = "./modules/fabric"
  count                    = var.create_fabric_capacity ? 1 : 0
  workload                 = local.workload
  fabric_capacity_location = var.fabric_capacity_location
  sku_name                 = var.fabric_capacity_sku_name
}
