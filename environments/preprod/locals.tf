locals {
    project = "webapp-php"
    environment = "preprod"
    
    common_tags = {
        project = local.project
        environment = local.environment
        managed_by = "terraform"
    }
    
    name_prefix = "${local.project}-${local.environment}"
}