data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

resource "azurerm_role_assignment" "bob_owner" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Owner"
  principal_id         = azuread_user.bob.object_id
}
