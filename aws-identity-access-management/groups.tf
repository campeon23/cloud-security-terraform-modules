# Crate an IAM group named "Traning_Group"
resource "aws_iam_group" "training_group" {
  name = "Training_Group"
}

# Add user "Alice" to group "Training_Group"
resource "aws_iam_group_membership" "alice_group_membership" {
  name      = "Alice"
  group     = aws_iam_group.training_group.name
  users     = [aws_iam_user.alice.name]
}