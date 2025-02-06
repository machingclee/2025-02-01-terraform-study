output "james_target_group_arn" {
  value = aws_lb_target_group.james_target_group.arn
}

output "lb_endpoint" {
  value = aws_lb.james_lb.dns_name
}