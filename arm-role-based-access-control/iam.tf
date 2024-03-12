resource "azuread_user" "bob" {
  user_principal_name = "Bob@${var.company}" # Replace example.com with your Azure AD domain
  display_name        = "Robert Green"
  given_name          = "Robert"
  password            = random_password.password.result
  job_title           = "Cloud Security Executive"
  department          = "Security and Information Technology"
  company_name        = "Global SecurityTech"
  # Set the account to be enabled
  account_enabled     = true
  # Other optional attributes can be set here as well.
}

resource "random_password" "password" {
  length  = 16
  special = true
}