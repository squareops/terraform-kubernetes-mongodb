output "mongodb_endpoints" {
  description = "MongoDB endpoints in the Kubernetes cluster."
  value = {
    mongoport                 = "27017",
    mongodb_headless_endpoint = "mongodb-headless.${var.namespace}.svc.cluster.local"
    mongodb_primary_endpoint  = "mongodb-primary.${var.namespace}.svc.cluster.local"
  }
}

output "mongodb_credential" {
  description = "MongoDB credentials used for accessing the MongoDB database."
  value = var.mongodb_config.store_password_to_secret_manager ? null : {
    root_user                = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_user : "root",
    root_password            = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.root_password : var.root_password,
    metric_exporter_user     = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_user : "mongodb_exporter",
    metric_exporter_password = var.mongodb_custom_credentials_enabled ? var.mongodb_custom_credentials_config.metric_exporter_password : var.metric_exporter_password
  }
}
