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
  value       = module.modules_vnet.vnets["testing"].id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.modules_vnet.vnets["testing"].name
}

output "vnet_location" {
  description = "The location of the virtual network"
  value       = module.modules_vnet.vnets["testing"].location
}

output "vnet_address_space" {
  description = "The address space of the virtual network"
  value       = module.modules_vnet.vnets["testing"].address_space
}

output "vnet_resource_group_name" {
  description = "The resource group name of the virtual network"
  value       = module.modules_vnet.vnets["testing"].resource_group_name
}

# Subnet outputs
output "vnet_subnets" {
  description = "All subnet information for the virtual network"
  value       = module.modules_vnet.vnets["testing"].subnets
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value = {
    for subnet in module.modules_vnet.vnets["testing"].subnets :
    subnet.name => subnet.id
  }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value = {
    for subnet in module.modules_vnet.vnets["testing"].subnets :
    subnet.name => subnet.address_prefixes[0]
  }
}

# All VNets output (if you have multiple vnets in the future)
output "all_vnets" {
  description = "All virtual networks managed by this module"
  value       = module.modules_vnet.vnets
}