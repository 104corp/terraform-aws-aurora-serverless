resource "aws_cloudwatch_metric_alarm" "alarm_rds_DatabaseConnections_writer" {
  count               = "${var.enabled && var.cw_alarms ? 1 : 0}"
  alarm_name          = "${aws_rds_cluster.default[count.index].id}-alarm-rds-writer-DatabaseConnections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.cw_eval_period_connections}"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Sum"
  threshold           = "${var.cw_max_conns}"
  alarm_description   = "RDS Maximum connection Alarm for ${aws_rds_cluster.default[count.index].id} writer"
  alarm_actions       = ["${var.cw_sns_topic}"]
  ok_actions          = ["${var.cw_sns_topic}"]

  dimensions {
    DBClusterIdentifier = "${aws_rds_cluster.default[count.index].id}"
    Role                = "WRITER"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_CPU_writer" {
  count               = "${var.enabled && var.cw_alarms ? 1 : 0}"
  alarm_name          = "${aws_rds_cluster.default[count.index].id}-alarm-rds-writer-CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.cw_eval_period_cpu}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "${var.cw_max_cpu}"
  alarm_description   = "RDS CPU Alarm for ${aws_rds_cluster.default[count.index].id} writer"
  alarm_actions       = ["${var.cw_sns_topic}"]
  ok_actions          = ["${var.cw_sns_topic}"]

  dimensions {
    DBClusterIdentifier = "${aws_rds_cluster.default[count.index].id}"
    Role                = "WRITER"
  }
}
