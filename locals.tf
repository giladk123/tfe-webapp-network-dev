locals {
  resource_group   = jsondecode(file("ccoe/rg.json"))
  vnet_settings    = jsondecode(file("network/vnet.json"))
  storage_accounts = jsondecode(file("ccoe/storage-accounts.json"))
}
