output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}
output "db_sg_id" {
  value = aws_security_group.database.id
}