data "azurerm_management_group" "this" {
  display_name = "Test Management Group"
}

module "policies" {
  source                         = "./policies"
  definition_management_group_id = data.azurerm_management_group.this.id
}

output "policies" {
  value = module.policies
}