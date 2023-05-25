#EC2 RDS Zone A
resource "aws_instance" "EC2-maindbA" {
    ami             = "ami-0f5fce3c3f4d0330f"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-maindbA.key_name    # Key Pair utilizado
    tags            = {
        Name        = "EC2_maindbA"
    }

    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao1.id}"]    # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1a.id             # Id da Subrede
}

#EC2 RDS Zone B
resource "aws_instance" "EC2-maindbB" {
    ami             = "ami-0f5fce3c3f4d0330f"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-maindbB.key_name    # Key Pair utilizado
    tags            = {
        Name        = "EC2_maindbB"
    }

    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao2.id}"]    # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1b.id             # Id da Subrede
}

#EC2 Read RDS Zone A
resource "aws_instance" "EC2-readDB1" {
    ami             = "ami-0f5fce3c3f4d0330f"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-readdb1.key_name   # Key Pair utilizado
    tags            = {
        Name        = "EC2_readDB1"
    }

    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao1-read.id}"]   # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1a.id                 # Id da Subrede
}

#EC2 Read RDS Zone B
resource "aws_instance" "EC2-readDB2" {
    ami             = "ami-0f5fce3c3f4d0330f"               # Imagem ubuntu personalizada
    instance_type   = "t2.micro"                            # Tipo de instância EC2
    key_name        = aws_key_pair.chave-readdb2.key_name   # Key Pair utilizado
    tags            = {
        Name        = "EC2_readDB2"
    }

    availability_zone        = "us-east-1b"                 # Zona de disponibilidade da instância
    vpc_security_group_ids = ["${aws_security_group.acesso-ssh-Regiao2-read.id}"]   # Grupo de Segurança
    subnet_id              = aws_subnet.public_subnet_us_east_1b.id                 # Id da Subrede
}