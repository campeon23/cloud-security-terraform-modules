resource "aws_accessanalyzer_analyzer" "main" {
  analyzer_name = "default"
  type          = "ACCOUNT" # or "ORGANIZATION" if you want to enable it at the organization level
}