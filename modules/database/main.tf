resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.environment}-db-subnet-group"
  subnet_ids = [ var.private_subnet_id ]

  tags = {
    Environment = var.environment
    Name = "${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  identifier = "${var.environment}-db"
  allocated_storage = var.storage_size
  engine = var.db_engine
  instance_class = var.db_instance_class
  name = var.db_name
  username = var.db_user
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [ var.security_group_id ]
  publicly_accessible = false
  skip_final_snapshot = true 

  tags = {
    Environment = var.environment
    Name = "${var.environment}-db"
  }
}
