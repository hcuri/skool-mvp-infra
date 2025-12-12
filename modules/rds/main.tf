resource "aws_security_group" "db" {
  name        = "skool-mvp-db-sg"
  description = "Allow Postgres access from allowed security groups"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
    description     = "Postgres from allowed SGs"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "skool-mvp-db-sg"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "skool-mvp-db-subnets"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "skool-mvp-db-subnets"
  })
}

resource "aws_db_instance" "this" {
  identifier             = "skool-mvp-db"
  engine                 = "postgres"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = merge(var.tags, {
    Name = "skool-mvp-db"
  })
}
