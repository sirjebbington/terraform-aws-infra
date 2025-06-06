environment = "production"

vpc_cidr = "10.10.0.0/16"
public_subnet_cidr = "10.10.1.0/24"
private_subnet_cidr = "10.10.2.0/24"
availability_zone = "ap-south-1b"

allowed_ssh_cidr = "192.168.31.9/32"
db_port = 5433

ami = "ami-0d3611c6f2adcd778"
instance_type = "t2.micro"
key_pair = "sshkey_prod"

db_engine = "postgres"
db_instance_class = "db.t3.micro"
storage_size = 20
db_name = "productiondb"
db_user = "admin"