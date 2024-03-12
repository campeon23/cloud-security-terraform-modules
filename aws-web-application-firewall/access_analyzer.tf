resource "aws_accessanalyzer_analyzer" "analyzer" {
  analyzer_name = "default"
  type          = "ACCOUNT" # or "ORGANIZATION" if you want to enable it at the organization level
  tags = {
    Name = "default-analyzer"
  }
}