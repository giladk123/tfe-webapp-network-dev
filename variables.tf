variable "environment" {
   description = "The target environment (dev, uat, prod)"
   type        = string
}

variable "use_module_dev" {
  description = "Set to true to use module dev, false for module prod"
  type        = bool
}
