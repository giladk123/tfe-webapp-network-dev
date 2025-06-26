module "resource-group" {
  source  = "app.terraform.io/hcta-azure-dev/modules/azurerm//modules/resource-group"
  version = "1.0.48"

  resource_groups = local.resource_group.resource_groups
}

