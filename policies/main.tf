variable "definition_management_group_id" {}

locals {
  policies = { for policy_name in fileset("./policies/definitions", "*.json") :
    trimsuffix(policy_name, ".json") => jsondecode(file("./policies/definitions/${policy_name}"))
  }
}

resource "azurerm_policy_definition" "this" {
  for_each            = local.policies
  name                = each.value.name
  policy_type         = "Custom"
  mode                = each.value.properties.mode
  display_name        = each.value.properties.displayName
  description         = each.value.properties.description
  management_group_id = var.definition_management_group_id

  metadata    = jsonencode(each.value.properties.metadata)
  policy_rule = jsonencode(each.value.properties.policyRule)
  parameters  = jsonencode(each.value.properties.parameters)
}

output "definitions" {
  description = "All created policies"
  value       = local.policies
}
