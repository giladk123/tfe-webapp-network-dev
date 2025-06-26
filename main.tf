module "resource-group" {
  source  = "app.terraform.io/hcta-azure-dev/modules/azurerm//modules/resource-group"
  version = "1.0.48"

  resource_groups = local.resource_group.resource_groups
  name_convention = local.resource_group.resource_groups.testing.name_convention
}

module "modules_vnet" {
  source  = "app.terraform.io/hcta-azure-dev/modules/azurerm//modules/vnet"
  version = "1.0.51"

  vnets = {
    for k, v in local.vnet_settings.vnets : k => merge(v, {
      resource_group_name = module.resource-group.resource_groups["testing"].name
    })
  }
  name_convention = local.vnet_settings.name_convention

  depends_on = [
    module.resource-group
  ]
}
