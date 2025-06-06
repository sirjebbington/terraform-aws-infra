resource "aws_instance" "bastion" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [ var.security_group_id ]
  key_name = var.key_pair

  user_data = file("${path.module}/scripts/init_bastion.sh")

  tags = {
    Environment = var.environment
    Name = "${var.environment}-bastion"
  }
}