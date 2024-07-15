variable "mongodb_config" {
  type = any
  default = {
    name                             = ""
    environment                      = ""
    volume_size                      = ""
    architecture                     = ""
    replica_count                    = 2
    custom_databases                 = ""
    custom_databases_usernames       = ""
    custom_databases_passwords       = ""
    values_yaml                      = ""
    storage_class_name               = ""
    store_password_to_secret_manager = true
  }
  description = "Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values."
}

variable "mongodb_custom_credentials_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable custom credentials for MongoDB database."
}

variable "mongodb_custom_credentials_config" {
  type = any
  default = {
    root_user                = ""
    root_password            = ""
    metric_exporter_user     = ""
    metric_exporter_password = ""
  }
  description = "Specify the configuration settings for Mongodb to pass custom credentials during creation."
}

variable "chart_version" {
  type        = string
  default     = "15.6.12"
  description = "Version of the Mongodb chart that will be used to deploy Mongodb application."
}

variable "app_version" {
  type        = string
  default     = "7.0.12-debian-12-r0"
  description = "Version of the Mongodb application that will be deployed."
}

variable "namespace" {
  type        = string
  default     = "mongodb"
  description = "Name of the Kubernetes namespace where the Mongodb deployment will be deployed."
}

variable "mongodb_backup_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable backups for Mongodb database."
}

variable "mongodb_backup_config" {
  type = any
  default = {
    bucket_uri           = ""
    s3_bucket_region     = "us-east-2"
    cron_for_full_backup = "*/5 * * * *"
  }
  description = "Configuration options for Mongodb database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups."
}

variable "mongodb_exporter_enabled" {
  type        = bool
  default     = false
  description = "Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana."
}

variable "mongodb_exporter_config" {
  type = any
  default = {
    version = "3.5.0"
  }
  description = "Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana."
}

variable "recovery_window_aws_secret" {
  type        = number
  default     = 0
  description = "Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery."
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Specifies the name of the EKS cluster to deploy the Mongodb application on."
}

variable "create_namespace" {
  type        = string
  default     = false
  description = "Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace."
}

variable "mongodb_restore_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable restoring dump to the Mongodb database."
}

variable "mongodb_restore_config" {
  type = any
  default = {
    bucket_uri       = "s3://mymongo/mongodumpfull_20230424_112501.gz"
    s3_bucket_region = "us-east-2"
    file_name        = ""
  }
  description = "Configuration options for restoring dump to the Mongodb database."
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = ""
}

variable "bucket_provider_type" {
  type        = string
  default     = "gcs"
  description = "Choose what type of provider you want (s3, gcs)"
}

variable "root_password" {
  description = "Root password for MongoDB"
  type        = string
  default     = ""
}

variable "metric_exporter_password" {
  description = "Metric exporter password for MongoDB"
  type        = string
  default     = ""
}

variable "iam_role_arn_backup" {
  description = "IAM role ARN for backup (AWS)"
  type        = string
  default     = ""
}

variable "service_account_backup" {
  description = "Service account for backup (GCP)"
  type        = string
  default     = ""
}

variable "iam_role_arn_restore" {
  description = "IAM role ARN for restore (AWS)"
  type        = string
  default     = ""
}

variable "service_account_restore" {
  description = "Service account for restore (GCP)"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
  default     = ""
}

variable "resource_group_location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
variable "azure_storage_account_name" {
  description = "Azure storage account name"
  type        = string
  default     = ""
}

variable "azure_storage_account_key" {
  description = "Azure storage account key"
  type        = string
  default     = ""
}

variable "azure_container_name" {
  description = "Azure container name"
  type        = string
  default     = ""
}

variable "az_account_backup" {
  description = "Azure user managed account backup identity"
  type        = string
  default     = ""
}

variable "az_account_restore" {
  description = "Azure user managed account restore identity"
  type        = string
  default     = ""
}


variable "mongodb_exporter_values" {
  description = "Mongo DB prometheus exporter values file"
  type        = any
  default     = ""
}
