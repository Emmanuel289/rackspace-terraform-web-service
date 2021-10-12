# Cloud watch metric alarm for scaling up
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = "${var.name}-scaleup"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.dev_web.id
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}


# Cloud watch metric alarm for scaling down
resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "${var.name}-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.dev_web.id
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
