module "ecs_apps" {
  source               = "git::https://github.com/FelipeGFalcao/terraform-aws-ClusterECS.git"
  name                 = local.workspace["cluster_name"]
  instance_type_1      = "t3.large"
  instance_type_2      = "t2.large"
  instance_type_3      = "m2.xlarge"
  vpc_id               = local.workspace["vpc_id"]
  private_subnet_ids   = [split(",", local.workspace["private_subnet_ids"])]
  public_subnet_ids    = [split(",", local.workspace["public_subnet_ids"])]
  secure_subnet_ids    = [split(",", local.workspace["secure_subnet_ids"])]
  certificate_arn      = local.workspace["alb_certificate_arn"]
  on_demand_percentage = 0
}