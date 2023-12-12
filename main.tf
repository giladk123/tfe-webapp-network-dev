module "vnet" {
  source  = "app.terraform.io/hcta-azure-dev/vnet/azurerm"
  version = "2.0.0"
  resource_group = local.vnet_settings.resource_group
  location = local.vnet_settings.location
  vnet_name = local.vnet_settings.vnet_name
  address_space = local.vnet_settings.address_space
  subnet_objects = local.subnet_objects
  nsg_objects = local.nsg_objects
}

module "blob" {
  source  = "app.terraform.io/hcta-azure-dev/blob/azurerm"
  version = "3.0.0"
  resource_group_name = local.blob_settings.resource_group_name
  storage_account_name     = local.blob_settings.storage_account_name
  location                = local.blob_settings.location
  account_tier            = local.blob_settings.account_tier
  account_replication_type = local.blob_settings.account_replication_type
  environment = local.blob_settings.environment

  depends_on = [ module.vnet ]
}
#123