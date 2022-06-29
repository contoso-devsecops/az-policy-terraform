data "azurerm_management_group" "this" {
  display_name = "Test Management Group"
}

resource "azurerm_management_group_policy_assignment" "add_tag_to_resource" {
  name                 = "test-assignment-tags"
  policy_definition_id = azurerm_policy_definition.this["add_tag_to_resource"].id
  management_group_id  = data.azurerm_management_group.this.id
  location             = "westus"

  identity {
    type = "SystemAssigned"
  }

  parameters = <<PARAMETERS
  {
    "tagName": {
      "value": "Test-Key"
    },
    "tagValue": {
      "value": "Test-Value"
    }
  }
  PARAMETERS
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "test-assignment-location"
  policy_definition_id = azurerm_policy_definition.this["allowed_locations"].id
  management_group_id  = data.azurerm_management_group.this.id

  parameters = <<PARAMETERS
  {
    "listOfAllowedLocations": {
      "value": [
        "westus"
      ]
    }
  }
  PARAMETERS
}