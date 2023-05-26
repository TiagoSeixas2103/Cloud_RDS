#EC2 RDS Zone A
resource "aws_instance" "EC2-maindbA" {
    depends_on = [aws_key_pair.chave-maindbA, aws_security_group.acesso-ssh-Regiao1, aws_subnet.public_subnet_us_east_1a]
    ami             = "ami-059c9094eadbcd5ca"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-maindbA.key_name    # Key Pair utilizado
    tags            = {
        Name        = "EC2_maindbA"
    }

    availability_zone        = "us-east-1a"                 # Zona de disponibilidade da instância
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao1.id}"]    # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1a.id             # Id da Subrede
}

#EC2 RDS Zone B
resource "aws_instance" "EC2-maindbB" {
    depends_on = [aws_key_pair.chave-maindbB, aws_security_group.acesso-ssh-Regiao2, aws_subnet.public_subnet_us_east_1b]
    ami             = "ami-059c9094eadbcd5ca"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-maindbB.key_name    # Key Pair utilizado
    tags            = {
        Name        = "EC2_maindbB"
    }

    availability_zone        = "us-east-1b"                 # Zona de disponibilidade da instância
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao2.id}"]    # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1b.id             # Id da Subrede
}

#EC2 Read RDS Zone A
resource "aws_instance" "EC2-readDB1" {
    depends_on = [aws_key_pair.chave-readdb1, aws_security_group.acesso-ssh-Regiao1-read, aws_subnet.public_subnet_us_east_1a]
    ami             = "ami-059c9094eadbcd5ca"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-readdb1.key_name   # Key Pair utilizado
    tags            = {
        Name        = "EC2_readDB1"
    }

    availability_zone        = "us-east-1a"                 # Zona de disponibilidade da instância
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao1-read.id}"]   # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1a.id                 # Id da Subrede
}

#EC2 Read RDS Zone B
resource "aws_instance" "EC2-readDB2" {
    depends_on = [aws_key_pair.chave-readdb2, aws_security_group.acesso-ssh-Regiao2-read, aws_subnet.public_subnet_us_east_1b]
    ami             = "ami-059c9094eadbcd5ca"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-readdb2.key_name   # Key Pair utilizado
    tags            = {
        Name        = "EC2_readDB2"
    }

    availability_zone        = "us-east-1b"                 # Zona de disponibilidade da instância
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao2-read.id}"]   # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1b.id                 # Id da Subrede
}