output "instance" {
  value     = aws_instance.james_node[*]
  sensitive = true
}