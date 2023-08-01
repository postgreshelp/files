provider "aws" {
  region = "us-east-1"  # Change this to your desired region
  access_key = "AKIA3TW7NMABPCYM4WIC"
  secret_key = "B+qk6fKH20EGvRzS5a6IJq9XhU/0G+XVvZNIbbpE"
}
# Replace "vpc-12345678" with the ID of your existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0de8e66ff073f233d"
}


# Replace "sg-12345678" with the ID of your existing security group
data "aws_security_group" "existing_security_group" {
  id = "sg-0adbc9376d54ec844"
}

# Replace "subnet-group-name" with the name of your existing DB subnet group that includes the chosen subnet(s) for the RDS instance
data "aws_db_subnet_group" "existing_db_subnet_group" {
  name = "aws-b29-rds-sg"
}

# Create the PostgreSQL RDS instance
resource "aws_db_instance" "postgres" {
  identifier             = "my-postgres-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"  # Change this to your desired instance type
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "postgres"
  password               = "postgres"  # Change this to your desired database password
  parameter_group_name   = "default.postgres15"
  publicly_accessible    = true
  skip_final_snapshot    = true  # Set to false if you want to create a final snapshot on deletion

  # Use the existing VPC, subnet, and subnet group IDs/names
  vpc_security_group_ids = [data.aws_security_group.existing_security_group.id]
  db_subnet_group_name    = data.aws_db_subnet_group.existing_db_subnet_group.name

  # You can set the "availability_zone" attribute if you want to specify a specific AZ for the RDS instance
  # availability_zone = "us-east-1a"
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
