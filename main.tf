/**
  * # AWS Aurora Serverless Terraform module
  *
  * ![Build Status](https://travis-ci.com/104corp/terraform-aws-aurora-serverless.svg?branch=master) ![LicenseBadge](https://img.shields.io/github/license/104corp/terraform-aws-aurora-serverless.svg)
  *
  * AWS Aurora DB Cluster for Serverless Terraform Module.
  *
  * Gives you:
  *
  *  - A DB subnet group
  *  - An Aurora DB cluster
  *  - Optionally RDS 'Enhanced Monitoring' + associated required IAM role/policy (by simply setting the `monitoring_interval` param to > `0`
  *  - Optionally sensible alarms to SNS (high CPU, high connections, slow replication)
  *
  * ## Terraform version
  *
  * Terraform version 0.10.3 or newer is required for this module to work.
  *
  * ## Contributing
  *
  * Ensure any variables you add have a type and a description.
  * This README is generated with [terraform-docs](https://github.com/segmentio/terraform-docs):
  *
  * `terraform-docs md . > README.md`
  *
  * ## Usage examples
  *
  * *It is recommended you always create a parameter group, even if it exactly matches the defaults.*
  * Changing the parameter group in use requires a restart of the DB cluster, modifying parameters within a group
  * may not (depending on the parameter being altered)
  *
  * ### Aurora 1.x (MySQL 5.6)
  *
  * ```hcl
  * resource "aws_sns_topic" "db_alarms_56" {
  *   name = "aurora-db-alarms-56"
  * }
  * 
  * module "aurora_db_56" {
  *   source                          = "../.."
  *   name                            = "test-aurora-db-56"
  *   envname                         = "test56"
  *   envtype                         = "test"
  *   subnets                         = ["${module.vpc.private_subnets}"]
  *   azs                             = ["${module.vpc.availability_zones}"]
  *   security_groups                 = ["${aws_security_group.allow_all.id}"]
  *   username                        = "root"
  *   password                        = "changeme"
  *   backup_retention_period         = "5"
  *   final_snapshot_identifier       = "final-db-snapshot-prod"
  *   storage_encrypted               = "true"
  *   apply_immediately               = "true"
  *   monitoring_interval             = "10"
  *   cw_alarms                       = true
  *   cw_sns_topic                    = "${aws_sns_topic.db_alarms_56.id}"
  *   db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_56_parameter_group.id}"
  *   db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_cluster_56_parameter_group.id}"
  * }
  * 
  * resource "aws_db_parameter_group" "aurora_db_56_parameter_group" {
  *   name        = "test-aurora-db-56-parameter-group"
  *   family      = "aurora5.6"
  *   description = "test-aurora-db-56-parameter-group"
  * }
  * 
  * resource "aws_rds_cluster_parameter_group" "aurora_cluster_56_parameter_group" {
  *   name        = "test-aurora-56-cluster-parameter-group"
  *   family      = "aurora5.6"
  *   description = "test-aurora-56-cluster-parameter-group"
  * }
  * ```
  *
  * ### Aurora 2.x (MySQL 5.7)
  *
  * ```hcl
  * resource "aws_sns_topic" "db_alarms" {
  *   name = "aurora-db-alarms"
  * }
  * 
  * module "aurora_db_57" {
  *   source                          = "../.."
  *   engine_version                  = "5.7.12"
  *   name                            = "test-aurora-db-57"
  *   envname                         = "test-57"
  *   envtype                         = "test"
  *   subnets                         = ["${module.vpc.private_subnets}"]
  *   azs                             = ["${module.vpc.availability_zones}"]
  *   security_groups                 = ["${aws_security_group.allow_all.id}"]
  *   username                        = "root"
  *   password                        = "changeme"
  *   backup_retention_period         = "5"
  *   final_snapshot_identifier       = "final-db-snapshot-prod"
  *   storage_encrypted               = "true"
  *   apply_immediately               = "true"
  *   monitoring_interval             = "10"
  *   cw_alarms                       = true
  *   cw_sns_topic                    = "${aws_sns_topic.db_alarms.id}"
  *   db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_57_parameter_group.id}"
  *   db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id}"
  * }
  * 
  * resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  *   name        = "test-aurora-db-57-parameter-group"
  *   family      = "aurora-mysql5.7"
  *   description = "test-aurora-db-57-parameter-group"
  * }
  * 
  * resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  *   name        = "test-aurora-57-cluster-parameter-group"
  *   family      = "aurora-mysql5.7"
  *   description = "test-aurora-57-cluster-parameter-group"
  * }
  * ```
  *
  * ### Aurora PostgreSQL
  *
  * ```hcl
  * resource "aws_sns_topic" "db_alarms_postgres96" {
  *   name = "aurora-db-alarms-postgres96"
  * }
  *
  * module "aurora_db_postgres96" {
  *   source                          = "../.."
  *   engine                          = "aurora-postgresql"
  *   engine_version                  = "9.6.3"
  *   name                            = "test-aurora-db-postgres96"
  *   envname                         = "test-pg96"
  *   envtype                         = "test"
  *   subnets                         = ["${module.vpc.private_subnets}"]
  *   azs                             = ["${module.vpc.availability_zones}"]
  *   security_groups                 = ["${aws_security_group.allow_all.id}"]
  *   username                        = "root"
  *   password                        = "changeme"
  *   backup_retention_period         = "5"
  *   final_snapshot_identifier       = "final-db-snapshot-prod"
  *   storage_encrypted               = "true"
  *   apply_immediately               = "true"
  *   monitoring_interval             = "10"
  *   cw_alarms                       = true
  *   cw_sns_topic                    = "${aws_sns_topic.db_alarms_postgres96.id}"
  *   db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_postgres96_parameter_group.id}"
  *   db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_cluster_postgres96_parameter_group.id}"
  * }
  *
  * resource "aws_db_parameter_group" "aurora_db_postgres96_parameter_group" {
  *   name        = "test-aurora-db-postgres96-parameter-group"
  *   family      = "aurora-postgresql9.6"
  *   description = "test-aurora-db-postgres96-parameter-group"
  * }
  *
  * resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres96_parameter_group" {
  *   name        = "test-aurora-postgres96-cluster-parameter-group"
  *   family      = "aurora-postgresql9.6"
  *   description = "test-aurora-postgres96-cluster-parameter-group"
  * }
  * ```
  *
  *
  * ## Development
  *
  * Terraform modules on the Terraform Module Registry are open projects, and community contributions are essential for keeping them great. Please follow our guidelines when contributing changes.
  *
  * For more information, see our [module contribution guide](https://registry.terraform.io/modules/104corp/aurora-serverless/aws/).
  * 
  * ## Contributors
  *
  * To see who's already involved, see the list of [contributors](https://github.com/104corp/terraform-aws-aurora-serverless/graphs/contributors).
  */

// Create DB Cluster
resource "aws_rds_cluster" "default" {
  count              = "${var.enabled ? 1 : 0}"
  cluster_identifier = "${var.identifier_prefix != "" ? format("%s-cluster", var.identifier_prefix) : format("%s-aurora-cluster", var.envname)}"
  availability_zones = ["var.azs"]

  engine         = "aurora"
  engine_version = "${var.engine_version}"
  engine_mode    = "serverless"

  database_name                       = "${var.database_name}"
  master_username                     = "${var.username}"
  master_password                     = "${var.password}"
  final_snapshot_identifier           = "${var.final_snapshot_identifier}-${random_id.server[index.count].hex}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  backup_retention_period             = "${var.backup_retention_period}"
  preferred_backup_window             = "${var.preferred_backup_window}"
  preferred_maintenance_window        = "${var.preferred_maintenance_window}"
  port                                = "${var.port}"
  db_subnet_group_name                = "${aws_db_subnet_group.main.name}"
  vpc_security_group_ids              = ["${var.security_groups}"]
  snapshot_identifier                 = "${var.snapshot_identifier}"
  storage_encrypted                   = "${var.storage_encrypted}"
  apply_immediately                   = "${var.apply_immediately}"
  db_cluster_parameter_group_name     = "${var.db_cluster_parameter_group_name}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"

  scaling_configuration {
    auto_pause   = "${var.auto_pause}"
    max_capacity = "${var.max_capacity}"
    min_capacity = "${var.min_capacity}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// DB Subnet Group creation
resource "aws_db_subnet_group" "main" {
  count       = "${var.enabled ? 1 : 0}"
  name        = "${var.name}"
  description = "Group of DB subnets"
  subnet_ids  = ["var.subnets"]
}

// Geneate an ID when an environment is initialised
resource "random_id" "server" {
  count = "${var.enabled ? 1 : 0}"

  keepers = {
    id = "${aws_db_subnet_group.main.name}"
  }

  byte_length = 8
}

// IAM Role + Policy attach for Enhanced Monitoring
data "aws_iam_policy_document" "monitoring-rds-assume-role-policy" {
  count = "${var.enabled ? 1 : 0}"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds-enhanced-monitoring" {
  count              = "${var.enabled && var.monitoring_interval > 0 ? 1 : 0}"
  name_prefix        = "rds-enhanced-mon-${var.envname}-"
  assume_role_policy = "${data.aws_iam_policy_document.monitoring-rds-assume-role-policy[count.index].json}"
}

resource "aws_iam_role_policy_attachment" "rds-enhanced-monitoring-policy-attach" {
  count      = "${var.enabled && var.monitoring_interval > 0 ? 1 : 0}"
  role       = "${aws_iam_role.rds-enhanced-monitoring[count.index].name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
