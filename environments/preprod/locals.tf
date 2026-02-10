locals {
    project = "webapp-php"
    
    common_tags = {
        project = local.project
        environment = var.environment
        managed_by = "terraform"
    }
    
    name_prefix = "${local.project}-${var.environment}"
}