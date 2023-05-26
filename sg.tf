# Grupo de Segurança EC2 Zona A
resource "aws_security_group" "acesso-ssh-Regiao1" {
  depends_on = [aws_vpc.vpc_database]
  name        = "acesso-ssh1"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    #EFS
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Conexão com django app
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh1"
  }
}

# Grupo de Segurança EC2 Zona B
resource "aws_security_group" "acesso-ssh-Regiao2" {
  depends_on = [aws_vpc.vpc_database]
  name        = "acesso-ssh2"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    #EFS
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Conexão com django app
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh2"
  }
}

# Grupo de Segurança RDS Principal Zona A
resource "aws_security_group" "acesso-ssh-DatabaseA" {
  depends_on = [aws_vpc.vpc_database, aws_instance.EC2-maindbA]
  name        = "acesso-ssh-dbA"
  description = "Allow EC2 instance to connect to RDS instance"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # Mysql connection
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.EC2-maindbA.private_ip}/32"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh1-maindbA"
  }
}

# Grupo de Segurança RDS Principal Zona B
resource "aws_security_group" "acesso-ssh-DatabaseB" {
  depends_on = [aws_vpc.vpc_database, aws_instance.EC2-maindbB]
  name        = "acesso-ssh-dbB"
  description = "Allow EC2 instance to connect to RDS instance"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # Mysql connection
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.EC2-maindbB.private_ip}/32"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh1-maindbB"
  }
}

# Grupo de Segurança EC2 Réplica de Leitura Zona A
resource "aws_security_group" "acesso-ssh-Regiao1-read" {
  depends_on = [aws_vpc.vpc_database]
  name        = "acesso-ssh1-read"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # SSH 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    #EFS
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Conexão com django app
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh1-read"
  }
}

# Grupo de Segurança RDS Réplica de Leitura Zona A
resource "aws_security_group" "acesso-ssh-Database-readDB1" {
  depends_on = [aws_vpc.vpc_database, aws_instance.EC2-readDB1]
  name        = "acesso-ssh-dbread1"
  description = "Allow EC2 instance to connect to RDS instance"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # MySQL
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.EC2-readDB1.private_ip}/32"] 
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh1-readDB1"
  }
}

# Grupo de Segurança EC2 Réplica de Leitura Zona B
resource "aws_security_group" "acesso-ssh-Regiao2-read" {
  depends_on = [aws_vpc.vpc_database]
  name        = "acesso-ssh2-read"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # SSH 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    #EFS
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # Conexão com django app
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh2-read"
  }
}

# Grupo de Segurança RDS Réplica de Leitura Zona B
resource "aws_security_group" "acesso-ssh-Database-readDB2" {
  depends_on = [aws_vpc.vpc_database, aws_instance.EC2-readDB2]
  name        = "acesso-ssh-dbread2"
  description = "Allow EC2 instance to connect to RDS instance"
  vpc_id = aws_vpc.vpc_database.id

  ingress {
    # MySQL
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.EC2-readDB2.private_ip}/32"] 
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh2-readDB2"
  }
}

