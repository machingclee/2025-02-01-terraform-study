output "vpc_id" {
  value = aws_vpc.james_vpc.id
}

output "db_subnet_group_names" {
  value = aws_db_subnet_group.james_rds_subnet_group.*.name
}

output "db_security_group_id" {
  value = aws_security_group.james_private_rds.id
}

output "public_subnet_ids" {
  value = aws_subnet.james_public_subnet.*.id
}

output "public_http_sg" {
  value = aws_security_group.james_http_sg
}

output "public_ssh_sg" {
  value = aws_security_group.james_ssh_sg
}

output "james_ec2_sg" {
  value = aws_security_group.ec2_security_group
}