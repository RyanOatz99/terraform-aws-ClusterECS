resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "project.dev"
  description = "Dominio para todos os serviços"
  vpc         = data.terraform_remote_state.vpc-project-dev.outputs.vpc_id
  tags        = var.tags
}

resource "aws_service_discovery_service" "this" {
  name = "project-service"
  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.this.id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 5
  }
  tags = var.tags
}