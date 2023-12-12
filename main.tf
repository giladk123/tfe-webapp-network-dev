module "vnet" {
  source  = "app.terraform.io/hcta-azure-dev/vnet/azurerm"
  version = "2.0.0"
  resource_group = local.vnet_settings.resource_group
  location = local.vnet_settings.location
  vnet_name = local.vnet_settings.vnet_name
  address_space = local.vnet_settings.address_space
  subnet_objects = local.subnet_objects
  nsg_objects = local.nsg_objects
<<<<<<< HEAD
  count   = var.use_module_dev ? 1 : 0
=======
>>>>>>> 45ea6d36e5c2d91e64bf7a3e7e52563721401448
}