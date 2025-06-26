output "rg_id" {
  value = module.resource-group.resource_groups["testing"].id
}

output "rg_name" {
  value = module.resource-group.resource_groups["testing"].name
}

output "rg_location" {
  value = module.resource-group.resource_groups["testing"].location
}

# Optional: If you want to output all resource groups
output "all_resource_groups" {
  value = module.resource-group.resource_groups
}

# VNet outputs
output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.modules_vnet.vnet["testing"].id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.modules_vnet.vnet["testing"].name
}

output "vnet_location" {
  description = "The location of the virtual network"
  value       = module.modules_vnet.vnet["testing"].location
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = module.modules_vnet.vnet["testing"].address_space
}

output "vnet_resource_group_name" {
  description = "The resource group name of the virtual network"
  value       = module.modules_vnet.vnet["testing"].resource_group_name
}

# Subnet outputs
output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for k, v in module.modules_vnet.subnet : k => v.id
    if startswith(k, "testing-")
  }
}

output "subnet_names" {
  description = "Map of subnet keys to their names"
  value = {
    for k, v in module.modules_vnet.subnet : k => v.name
    if startswith(k, "testing-")
  }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value = {
    for k, v in module.modules_vnet.subnet : k => v.address_prefixes
    if startswith(k, "testing-")
  }
}

# All resources output
output "all_vnets" {
  description = "All virtual networks managed by this module"
  value       = module.modules_vnet.vnet
}

output "all_subnets" {
  description = "All subnets managed by this module"
  value       = module.modules_vnet.subnet
}