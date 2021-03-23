module "ecs_app_wordpress_01" {
  source                 = "git::https://github.com/FelipeGFalcao/terraform-aws-ClusterECS.git"
  vpc_id                 = local.workspace["vpc_id"]
  cluster_name           = module.ecs_apps.ecs_name
  service_role_arn       = module.ecs_apps.ecs_service_iam_role_arn
  task_role_arn          = module.ecs_apps.ecs_task_iam_role_arn
  alb_listener_https_arn = element(module.ecs_apps.alb_listener_https_arn, 0)
  alb_dns_name           = element(module.ecs_apps.alb_dns_name, 0)
  name                   = "wordpress-01"
  image                  = "nginxdemos/hello:latest"
  container_port         = 80
  hostname               = "wp01.labs.host"        # signed by cf_certificate_arn
  hostname_blue          = "wp01-blue.labs.host"   # signed by cf_certificate_arn
  hostname_origin        = "wp01-origin.labs.host" # signed by alb_certificate_arn
  hosted_zone            = "labs.host"
  certificate_arn        = local.workspace["cf_certificate_arn"] # goes on cloudfront
  alb_cloudfront_key     = module.ecs_apps.alb_cloudfront_key

  # use these values for Wordpress
  healthcheck_path                          = "/readme.html"
  service_health_check_grace_period_seconds = 120
}
