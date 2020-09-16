resource "aws_ecs_cluster" "ecs" {
  name = var.name

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
