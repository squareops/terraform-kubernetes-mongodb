## MongoDB

![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
This module is for deploying a highly available MongoDB cluster on Kubernetes using Helm charts. This module provides flexible configuration options to customize the MongoDB deployment such as setting the volume size, architecture, replica count, and more. It also includes options to enable MongoDB backups and restores, and to deploy MongoDB exporters for getting metrics in Grafana. Additionally, this module provides options to create a new namespace, and to configure recovery windows for AWS Secrets Manager, Azure key vault & GCP secrets manager. With this module, users can easily deploy a highly available MongoDB cluster on AWS EKS, Azure AKS & GCP GKE Kubernetes clusters with the flexibility to customize their configurations according to their needs.

## Supported Versions:

|  MongoDB Helm Chart Version    |     K8s supported version (EKS, AKS & GKE)  |  
| :-----:                       |         :---                |
| **15.6.12**                     |    **1.23,1.24,1.25,1.26,1.27,1.28,1.29**           |


## Usage Example

```hcl
locals {
  name        = "mongo"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
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
  source                             = "squareops/mongodb/kubernetes//modules/resources/aws"
  environment                        = local.environment
  name                               = local.name
  namespace                          = local.namespace
  store_password_to_secret_manager   = local.store_password_to_secret_manager
  cluster_name                       = ""
  mongodb_custom_credentials_enabled = local.mongodb_custom_credentials_enabled
  mongodb_custom_credentials_config  = local.mongodb_custom_credentials_config
}

module "mongodb" {
  source           = "squareops/mongodb/kubernetes"
  namespace        = local.namespace
  create_namespace = local.create_namespace
  mongodb_config = {
    name                             = local.name
    namespace                        = local.namespace
    values_yaml                      = ""
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


```
- Refer [AWS examples](https://github.com/squareops/terraform-kubernetes-mongodb/tree/main/examples/complete/aws) for more details.
- Refer [Azure examples](https://github.com/squareops/terraform-kubernetes-mongodb/tree/main/examples/complete/azure) for more details.
- Refer [GCP examples](https://github.com/squareops/terraform-kubernetes-mongodb/tree/main/examples/complete/gcp) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/squareops/terraform-kubernetes-mongodb/blob/main/IAM.md)
## Mongo Backup and Restore
This module provides functionality to automate the backup and restore process for mongo databases using AWS S3 buckets. It allows users to easily schedule backups, restore databases from backups stored in S3, and manage access permissions using AWS IAM roles.
Features
### Backup
- Users can schedule full backups.
- Backups are stored in specified S3 buckets.
### Restore
- Users can restore Mongo databases from backups stored in S3 buckets.
- Supports specifying the backup file to restore from and the target S3 bucket region.
### IAM Role for Permissions
- Users need to provide an IAM role for the module to access the specified S3 bucket and perform backup and restore operations.
## Module Inputs
### Backup Configuration
- bucket_uri: The URI of the S3 bucket where backups will be stored.
- s3_bucket_region: The region of the S3 bucket.
- cron_for_full_backup: The cron expression for scheduling full backups.
### Restore Configuration
- mongodb_restore_config: Configuration for restoring databases.
- bucket_uri: The URI of the S3 bucket containing the backup file.
- file_name: The name of the backup file to restore.
- s3_bucket_region: The region of the S3 bucket containing the backup file.
## Important Notes
  1. In order to enable the exporter, it is required to deploy Prometheus/Grafana first.
  2. The exporter is a tool that extracts metrics data from an application or system and makes it available to be scraped by Prometheus.
  3. Prometheus is a monitoring system that collects metrics data from various sources, including exporters, and stores it in a time-series database.
  4. Grafana is a data visualization and dashboard tool that works with Prometheus and other data sources to display the collected metrics in a user-friendly way.
  5. To deploy Prometheus/Grafana, please follow the installation instructions for each tool in their respective documentation.
  6. Once Prometheus and Grafana are deployed, the exporter can be configured to scrape metrics data from your application or system and send it to Prometheus.
  7. Finally, you can use Grafana to create custom dashboards and visualize the metrics data collected by Prometheus.
  8. This module is compatible with EKS, AKS & GKE which is great news for users deploying the module on an AWS, Azure & GCP cloud. Review the module's documentation, meet specific configuration requirements, and test thoroughly after deployment to ensure everything works as expected.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.mongodb](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_backup](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.mongodb_restore](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.mongodb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_password.mongodb_exporter_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mongodb_root_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_version"></a> [app\_version](#input\_app\_version) | Version of the Mongodb application that will be deployed. | `string` | `"7.0.12-debian-12-r0"` | no |
| <a name="input_az_account_backup"></a> [az\_account\_backup](#input\_az\_account\_backup) | Azure user managed account backup identity | `string` | `""` | no |
| <a name="input_az_account_restore"></a> [az\_account\_restore](#input\_az\_account\_restore) | Azure user managed account restore identity | `string` | `""` | no |
| <a name="input_azure_container_name"></a> [azure\_container\_name](#input\_azure\_container\_name) | Azure container name | `string` | `""` | no |
| <a name="input_azure_storage_account_key"></a> [azure\_storage\_account\_key](#input\_azure\_storage\_account\_key) | Azure storage account key | `string` | `""` | no |
| <a name="input_azure_storage_account_name"></a> [azure\_storage\_account\_name](#input\_azure\_storage\_account\_name) | Azure storage account name | `string` | `""` | no |
| <a name="input_bucket_provider_type"></a> [bucket\_provider\_type](#input\_bucket\_provider\_type) | Choose what type of provider you want (s3, gcs) | `string` | `"gcs"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of the Mongodb chart that will be used to deploy Mongodb application. | `string` | `"15.6.12"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Specifies the name of the EKS cluster to deploy the Mongodb application on. | `string` | `""` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Specify whether or not to create the namespace if it does not already exist. Set it to true to create the namespace. | `string` | `false` | no |
| <a name="input_iam_role_arn_backup"></a> [iam\_role\_arn\_backup](#input\_iam\_role\_arn\_backup) | IAM role ARN for backup (AWS) | `string` | `""` | no |
| <a name="input_iam_role_arn_restore"></a> [iam\_role\_arn\_restore](#input\_iam\_role\_arn\_restore) | IAM role ARN for restore (AWS) | `string` | `""` | no |
| <a name="input_metric_exporter_password"></a> [metric\_exporter\_password](#input\_metric\_exporter\_password) | Metric exporter password for MongoDB | `string` | `""` | no |
| <a name="input_mongodb_backup_config"></a> [mongodb\_backup\_config](#input\_mongodb\_backup\_config) | Configuration options for Mongodb database backups. It includes properties such as the S3 bucket URI, the S3 bucket region, and the cron expression for full backups. | `any` | <pre>{<br>  "bucket_uri": "",<br>  "cron_for_full_backup": "*/5 * * * *",<br>  "s3_bucket_region": "us-east-2"<br>}</pre> | no |
| <a name="input_mongodb_backup_enabled"></a> [mongodb\_backup\_enabled](#input\_mongodb\_backup\_enabled) | Specifies whether to enable backups for Mongodb database. | `bool` | `false` | no |
| <a name="input_mongodb_config"></a> [mongodb\_config](#input\_mongodb\_config) | Specify the configuration settings for Mongodb, including the name, environment, storage options, replication settings, and custom YAML values. | `any` | <pre>{<br>  "architecture": "",<br>  "custom_databases": "",<br>  "custom_databases_passwords": "",<br>  "custom_databases_usernames": "",<br>  "environment": "",<br>  "name": "",<br>  "replica_count": 2,<br>  "storage_class_name": "",<br>  "store_password_to_secret_manager": true,<br>  "values_yaml": "",<br>  "volume_size": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_config"></a> [mongodb\_custom\_credentials\_config](#input\_mongodb\_custom\_credentials\_config) | Specify the configuration settings for Mongodb to pass custom credentials during creation. | `any` | <pre>{<br>  "metric_exporter_password": "",<br>  "metric_exporter_user": "",<br>  "root_password": "",<br>  "root_user": ""<br>}</pre> | no |
| <a name="input_mongodb_custom_credentials_enabled"></a> [mongodb\_custom\_credentials\_enabled](#input\_mongodb\_custom\_credentials\_enabled) | Specifies whether to enable custom credentials for MongoDB database. | `bool` | `false` | no |
| <a name="input_mongodb_exporter_config"></a> [mongodb\_exporter\_config](#input\_mongodb\_exporter\_config) | Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana. | `any` | <pre>{<br>  "version": "3.5.0"<br>}</pre> | no |
| <a name="input_mongodb_exporter_enabled"></a> [mongodb\_exporter\_enabled](#input\_mongodb\_exporter\_enabled) | Specify whether or not to deploy Mongodb exporter to collect Mongodb metrics for monitoring in Grafana. | `bool` | `false` | no |
| <a name="input_mongodb_exporter_values"></a> [mongodb\_exporter\_values](#input\_mongodb\_exporter\_values) | Mongo DB prometheus exporter values file | `any` | `""` | no |
| <a name="input_mongodb_restore_config"></a> [mongodb\_restore\_config](#input\_mongodb\_restore\_config) | Configuration options for restoring dump to the Mongodb database. | `any` | <pre>{<br>  "bucket_uri": "s3://mymongo/mongodumpfull_20230424_112501.gz",<br>  "file_name": "",<br>  "s3_bucket_region": "us-east-2"<br>}</pre> | no |
| <a name="input_mongodb_restore_enabled"></a> [mongodb\_restore\_enabled](#input\_mongodb\_restore\_enabled) | Specifies whether to enable restoring dump to the Mongodb database. | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of the Kubernetes namespace where the Mongodb deployment will be deployed. | `string` | `"mongodb"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud project ID | `string` | `""` | no |
| <a name="input_recovery_window_aws_secret"></a> [recovery\_window\_aws\_secret](#input\_recovery\_window\_aws\_secret) | Number of days that AWS Secrets Manager will wait before deleting a secret. This value can be set to 0 to force immediate deletion, or to a value between 7 and 30 days to allow for recovery. | `number` | `0` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Azure region | `string` | `"East US"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure Resource Group name | `string` | `""` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | Root password for MongoDB | `string` | `""` | no |
| <a name="input_service_account_backup"></a> [service\_account\_backup](#input\_service\_account\_backup) | Service account for backup (GCP) | `string` | `""` | no |
| <a name="input_service_account_restore"></a> [service\_account\_restore](#input\_service\_account\_restore) | Service account for restore (GCP) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodb_credential"></a> [mongodb\_credential](#output\_mongodb\_credential) | MongoDB credentials used for accessing the MongoDB database. |
| <a name="output_mongodb_endpoints"></a> [mongodb\_endpoints](#output\_mongodb\_endpoints) | MongoDB endpoints in the Kubernetes cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribution & Issue Reporting

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-kubernetes-mongodb/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/squareops/terraform-kubernetes-mongodb).

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Starring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 5 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

To find more information about our company, visit [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
