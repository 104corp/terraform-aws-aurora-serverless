# tf-aws-aurora-serverless

AWS Aurora DB Cluster for Serverless Terraform Module.

Gives you:

 - A DB subnet group
 - An Aurora DB cluster
 - Optionally RDS 'Enhanced Monitoring' + associated required IAM role/policy (by simply setting the `monitoring_interval` param to > `0`
 - Optionally sensible alarms to SNS (high CPU, high connections, slow replication)
 - Optionally configure autoscaling for read replicas (MySQL clusters only)

## Contributing

Ensure any variables you add have a type and a description.
This README is generated with [terraform-docs](https://github.com/segmentio/terraform-docs):

`terraform-docs md . > README.md`

## Usage examples

*It is recommended you always create a parameter group, even if it exactly matches the defaults.*
Changing the parameter group in use requires a restart of the DB cluster, modifying parameters within a group
may not (depending on the parameter being altered)

### Aurora 1.x (MySQL 5.6)

resource "aws_sns_topic" "db_alarms_56" {
  name = "aurora-db-alarms-56"
}

module "aurora_db_56" {
  source                          = "../.."
  name                            = "test-aurora-db-56"
  envname                         = "test56"
  envtype                         = "test"
  subnets                         = ["${module.vpc.private_subnets}"]
  azs                             = ["${module.vpc.availability_zones}"]
  security_groups                 = ["${aws_security_group.allow_all.id}"]
  username                        = "root"
  password                        = "changeme"
  backup_retention_period         = "5"
  final_snapshot_identifier       = "final-db-snapshot-prod"
  storage_encrypted               = "true"
  apply_immediately               = "true"
  monitoring_interval             = "10"
  cw_alarms                       = true
  cw_sns_topic                    = "${aws_sns_topic.db_alarms_56.id}"
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_56_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_cluster_56_parameter_group.id}"
}

resource "aws_db_parameter_group" "aurora_db_56_parameter_group" {
  name        = "test-aurora-db-56-parameter-group"
  family      = "aurora5.6"
  description = "test-aurora-db-56-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_56_parameter_group" {
  name        = "test-aurora-56-cluster-parameter-group"
  family      = "aurora5.6"
  description = "test-aurora-56-cluster-parameter-group"
}

### Aurora 2.x (MySQL 5.7)

```hcl
resource "aws_sns_topic" "db_alarms" {
  name = "aurora-db-alarms"
}

module "aurora_db_57" {
  source                          = "../.."
  engine_version                  = "5.7.12"
  name                            = "test-aurora-db-57"
  envname                         = "test-57"
  envtype                         = "test"
  subnets                         = ["${module.vpc.private_subnets}"]
  azs                             = ["${module.vpc.availability_zones}"]
  security_groups                 = ["${aws_security_group.allow_all.id}"]
  username                        = "root"
  password                        = "changeme"
  backup_retention_period         = "5"
  final_snapshot_identifier       = "final-db-snapshot-prod"
  storage_encrypted               = "true"
  apply_immediately               = "true"
  monitoring_interval             = "10"
  cw_alarms                       = true
  cw_sns_topic                    = "${aws_sns_topic.db_alarms.id}"
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_57_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id}"
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "test-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "test-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-57-cluster-parameter-group"
}
```
### Aurora PostgreSQL

```hcl
resource "aws_sns_topic" "db_alarms_postgres96" {
  name = "aurora-db-alarms-postgres96"
}

module "aurora_db_postgres96" {
  source                          = "../.."
  engine                          = "aurora-postgresql"
  engine_version                  = "9.6.3"
  name                            = "test-aurora-db-postgres96"
  envname                         = "test-pg96"
  envtype                         = "test"
  subnets                         = ["${module.vpc.private_subnets}"]
  azs                             = ["${module.vpc.availability_zones}"]
  security_groups                 = ["${aws_security_group.allow_all.id}"]
  username                        = "root"
  password                        = "changeme"
  backup_retention_period         = "5"
  final_snapshot_identifier       = "final-db-snapshot-prod"
  storage_encrypted               = "true"
  apply_immediately               = "true"
  monitoring_interval             = "10"
  cw_alarms                       = true
  cw_sns_topic                    = "${aws_sns_topic.db_alarms_postgres96.id}"
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_postgres96_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_cluster_postgres96_parameter_group.id}"
}

resource "aws_db_parameter_group" "aurora_db_postgres96_parameter_group" {
  name        = "test-aurora-db-postgres96-parameter-group"
  family      = "aurora-postgresql9.6"
  description = "test-aurora-db-postgres96-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres96_parameter_group" {
  name        = "test-aurora-postgres96-cluster-parameter-group"
  family      = "aurora-postgresql9.6"
  description = "test-aurora-postgres96-cluster-parameter-group"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| apply\_immediately | Determines whether or not any DB modifications are applied immediately, or during the maintenance window | string | `"false"` | no |
| auto\_minor\_version\_upgrade | Determines whether minor engine upgrades will be performed automatically in the maintenance window | string | `"true"` | no |
| auto\_pause | When to perform DB auto pause | string | `"true"` | no |
| auto\_pause | When to perform DB auto pause | string | `"true"` | no |
| azs | List of AZs to use | list | n/a | yes |
| backup\_retention\_period | How long to keep backups for (in days) | string | `"7"` | no |
| cw\_alarms | Whether to enable CloudWatch alarms - requires `cw_sns_topic` is specified | string | `"false"` | no |
| cw\_eval\_period\_connections | Evaluation period for the DB connections alarms | string | `"1"` | no |
| cw\_eval\_period\_cpu | Evaluation period for the DB CPU alarms | string | `"2"` | no |
| cw\_eval\_period\_replica\_lag | Evaluation period for the DB replica lag alarm | string | `"5"` | no |
| cw\_max\_conns | Connection count beyond which to trigger a CloudWatch alarm | string | `"500"` | no |
| cw\_max\_cpu | CPU threshold above which to alarm | string | `"85"` | no |
| cw\_max\_replica\_lag | Maximum Aurora replica lag in milliseconds above which to alarm | string | `"2000"` | no |
| cw\_sns\_topic | An SNS topic to publish CloudWatch alarms to | string | `"false"` | no |
| db\_cluster\_parameter\_group\_name | The name of a DB Cluster parameter group to use | string | `"default.aurora5.6"` | no |
| db\_parameter\_group\_name | The name of a DB parameter group to use | string | `"default.aurora5.6"` | no |
| enabled | Whether the database resources should be created | string | `"true"` | no |
| engine\_version | Aurora database engine version. | string | `"5.6.10a"` | no |
| envname | Environment name (eg,test, stage or prod) | string | n/a | yes |
| envtype | Environment type (eg,prod or nonprod) | string | n/a | yes |
| final\_snapshot\_identifier | The name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. | string | `"final"` | no |
| iam\_database\_authentication\_enabled | Whether to enable IAM database authentication for the RDS Cluster | string | `"false"` | no |
| identifier\_prefix | Prefix for cluster identifier | string | `""` | no |
| max\_capacity | The max capacity for database | string | `"6"` | no |
| min\_capacity | The min capacity for database | string | `"2"` | no |
| monitoring\_interval | The interval (seconds) between points when Enhanced Monitoring metrics are collected | string | `"0"` | no |
| name | Name given to DB subnet group | string | n/a | yes |
| password | Master DB password | string | n/a | yes |
| performance\_insights\_enabled | Whether to enable Performance Insights | string | `"false"` | no |
| preferred\_backup\_window | When to perform DB backups | string | `"02:00-03:00"` | no |
| preferred\_maintenance\_window | When to perform DB maintenance | string | `"sun:05:00-sun:06:00"` | no |
| publicly\_accessible | Whether the DB should have a public IP address | string | `"false"` | no |
| security\_groups | VPC Security Group IDs | list | n/a | yes |
| skip\_final\_snapshot | Should a final snapshot be created on cluster destroy | string | `"false"` | no |
| snapshot\_identifier | DB snapshot to create this database from | string | `""` | no |
| storage\_encrypted | Specifies whether the underlying storage layer should be encrypted | string | `"true"` | no |
| subnets | List of subnet IDs to use | list | n/a | yes |
| username | Master DB username | string | `"root"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint | The 'writer' endpoint for the cluster |
| cluster\_identifier | The ID of the RDS Cluster |
| reader\_endpoint | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |

## Development

Terraform modules on the Terraform Module Registry are open projects, and community contributions are essential for keeping them great. Please follow our guidelines when contributing changes.

For more information, see our [module contribution guide](https://registry.terraform.io/modules/104corp/aurora-serverless/aws/).

## Contributors

To see who's already involved, see the list of [contributors](https://github.com/104corp/terraform-aws-aurora-serverless/graphs/contributors).
