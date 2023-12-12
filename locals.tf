locals {
  environment_path = "${path.module}/${var.environment}/network.json"
  vnet_settings    = jsondecode(file(local.environment_path))

  blob_path = "${path.module}/${var.environment}/blob.json"
  blob_settings = jsondecode(file(local.blob_path))

  subnet_objects = [
    for subnet in local.vnet_settings.subnets : {
      name              = subnet.name
      address_prefix    = subnet.address_prefix
      nic_name          = subnet.network_interface.name
      private_ip_allocation_method = subnet.network_interface.private_ip_allocation_method
      #security_group_ids = subnet.security_groups
    }
  ]

  nsg_objects = [
    for nsg in local.vnet_settings.network_security_groups : {
      name            = nsg.name
      security_rules = nsg.security_rules
    }
  ]
}