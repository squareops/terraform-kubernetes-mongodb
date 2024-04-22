locals {
  name        = "mongo"
  region      = "ap-northeast-1"
  environment = "stg"
  additional_aws_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
  create_namespace                   = true
  namespace                          = "mongodb"
  store_password_to_secret_manager   = true
  mongodb_custom_credentials_enabled = true
  mongodb_custom_credentials_config = {
    root_user                = "root"
    root_password            = "NCPFUKEMd7rrWuvMAa73"
    metric_exporter_user     = "mongodb_exporter"
    metric_exporter_password = "nvAHhm1uGQNYWVw6ZyAH"
  }
}
module "aws" {
  # source                             = "squareops/mongodb/kubernetes//modules/resources/aws"
  source                             = "../../../modules/resources/aws"
  environment                        = local.environment
  name                               = local.name
  namespace                          = local.namespace
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  cluster_name                       = "stg-rachit"
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
}

module "mongodb" {
  source           = "../../../"
  namespace        = local.namespace
  create_namespace = local.create_namespace
  mongodb_config = {
    name                             = local.name
    namespace                        = local.namespace
    values_yaml                      = file("./helm/values.yaml")
    environment                      = local.environment
    volume_size                      = "10Gi"
    architecture                     = "replicaset"
    custom_databases                 = "['db1', 'db2']"
    custom_databases_usernames       = "['admin', 'admin']"
    custom_databases_passwords       = "['pass1', 'pass2']"
    replica_count                    = 2
    storage_class_name               = "gp2"
    store_password_to_secret_manager = local.store_password_to_secret_manager
  }
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
  root_password                      = local.mongodb_custom_credentials_enabled ? "" : module.aws.root_password
  metric_exporter_password           = local.mongodb_custom_credentials_enabled ? "" : module.aws.metric_exporter_password
  bucket_provider_type               = "s3"
  mongodb_backup_enabled             = true
  iam_role_arn_backup                = module.aws.iam_role_arn_backup
  mongodb_backup_config = {
    bucket_uri           = "s3://mongo-demo-backup"
    s3_bucket_region     = "us-east-2"
    cron_for_full_backup = "* * * * *"
  }
  mongodb_restore_enabled = true
  iam_role_arn_restore    = module.aws.iam_role_arn_restore
  mongodb_restore_config = {
    bucket_uri       = "s3://mongo-demo-backup/mongodumpfull_20230523_092110.gz"
    s3_bucket_region = "us-east-2"
    file_name        = "mongodumpfull_20230523_092110.gz"
  }
  mongodb_exporter_enabled = true
  mongodb_exporter_values  = file("./helm/exporter.yaml")

}
