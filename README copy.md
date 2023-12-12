## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.11.0, <4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_blob"></a> [blob](#module\_blob) | app.terraform.io/hcta-azure-test/blob/azurerm | 1.0.0 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | app.terraform.io/hcta-azure-test/vnet/azurerm | 2.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The target environment (dev, uat, prod) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interface_ip"></a> [interface\_ip](#output\_interface\_ip) | n/a |
| <a name="output_nic_ids"></a> [nic\_ids](#output\_nic\_ids) | n/a |
| <a name="output_rg_id"></a> [rg\_id](#output\_rg\_id) | n/a |
| <a name="output_rg_location"></a> [rg\_location](#output\_rg\_location) | n/a |
| <a name="output_rg_name"></a> [rg\_name](#output\_rg\_name) | n/a |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | n/a |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | n/a |
