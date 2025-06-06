resource "aws_security_group" "bastion" {
  name = "${var.environment}-bastion-sg"
  description = "Allow SSH from specific Machine IPs"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database" {
  name = "${var.environment}-db-sg"
  description = "Allow DB traffic from Bastion"
  vpc_id = var.vpc_id

  ingress {
    from_port = var.db_port
    to_port = var.db_port
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}