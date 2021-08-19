resource "aws_cloudwatch_log_group" "vpn" {
  name              = "/aws/${var.name}/logs"
  retention_in_days = var.logs_retention

  tags = merge(
    var.tags,
    map(
      "Name", "${var.name}-client-vpn-log-group",
      "EnvName", var.name
    )
  )
}

resource "aws_cloudwatch_log_stream" "vpn" {
  name           = "${var.name}-usage"
  log_group_name = aws_cloudwatch_log_group.vpn.name
}
