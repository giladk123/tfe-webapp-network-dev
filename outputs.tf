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

# # VNet outputs
# output "vnet_id" {
#   description = "The ID of the virtual network"
#   value       = module.modules_vnet.vnet["testing"].id
# }

# output "vnet_name" {
#   description = "The name of the virtual network"
#   value       = module.modules_vnet.vnet["testing"].name
# }

# output "vnet_location" {
#   description = "The location of the virtual network"
#   value       = module.modules_vnet.vnet["testing"].location
# }

# output "vnet_address_space" {
#   description = "The address space of the virtual network"
#   value       = module.modules_vnet.vnet["testing"].address_space
# }

# output "vnet_resource_group_name" {
#   description = "The resource group name of the virtual network"
#   value       = module.modules_vnet.vnet["testing"].resource_group_name
# }

# # Subnet outputs
# output "subnet_ids" {
#   description = "Map of subnet names to their IDs"
#   value = {
#     for k, v in module.modules_vnet.subnet : k => v.id
#     if startswith(k, "testing-")
#   }
# }

# output "subnet_names" {
#   description = "Map of subnet keys to their names"
#   value = {
#     for k, v in module.modules_vnet.subnet : k => v.name
#     if startswith(k, "testing-")
#   }
# }

# output "subnet_address_prefixes" {
#   description = "Map of subnet names to their address prefixes"
#   value = {
#     for k, v in module.modules_vnet.subnet : k => v.address_prefixes
#     if startswith(k, "testing-")
#   }
# }

# # All resources output
# output "all_vnets" {
#   description = "All virtual networks managed by this module"
#   value       = module.modules_vnet.vnet
# }

# output "all_subnets" {
#   description = "All subnets managed by this module"
#   value       = module.modules_vnet.subnet
# }

# # Storage Account outputs
# output "storage_account_ids" {
#   description = "Map of storage account keys to their resource IDs"
#   value       = module.modules_storage_account.storage_account_ids
# }

# output "storage_account_names" {
#   description = "Map of storage account keys to their actual names"
#   value       = module.modules_storage_account.storage_account_names
# }

# output "storage_account_primary_blob_endpoints" {
#   description = "Map of storage account keys to their primary blob endpoints"
#   value       = module.modules_storage_account.primary_blob_endpoints
# }

# output "storage_account_primary_connection_strings" {
#   description = "Map of storage account keys to their primary connection strings"
#   value       = module.modules_storage_account.primary_connection_strings
#   sensitive   = true
# }

# output "storage_accounts" {
#   description = "Comprehensive map of all created storage accounts with their properties"
#   value       = module.modules_storage_account.storage_accounts
#   sensitive   = true
# }

# # Storage containers, file shares, queues, and tables outputs
# output "storage_containers" {
#   description = "Map of all created storage containers"
#   value       = module.modules_storage_account.containers
# }

# output "storage_file_shares" {
#   description = "Map of all created file shares"
#   value       = module.modules_storage_account.file_shares
# }

# output "storage_queues" {
#   description = "Map of all created storage queues"
#   value       = module.modules_storage_account.queues
# }

# output "storage_tables" {
#   description = "Map of all created storage tables"
#   value       = module.modules_storage_account.tables
# }

# # Private endpoint outputs for storage accounts
# output "storage_private_endpoints" {
#   description = "Map of all created private endpoints for storage accounts"
#   value       = module.modules_storage_account.private_endpoints
# }

# # Specific storage account outputs (for the storageaccount001)
# output "storageaccount001_id" {
#   description = "The ID of storageaccount001"
#   value       = try(module.modules_storage_account.storage_account_ids["storageaccount001"], null)
# }

# output "storageaccount001_name" {
#   description = "The name of storageaccount001"
#   value       = try(module.modules_storage_account.storage_account_names["storageaccount001"], null)
# }

# output "storageaccount001_primary_blob_endpoint" {
#   description = "The primary blob endpoint of storageaccount001"
#   value       = try(module.modules_storage_account.primary_blob_endpoints["storageaccount001"], null)
# }