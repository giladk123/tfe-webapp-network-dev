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