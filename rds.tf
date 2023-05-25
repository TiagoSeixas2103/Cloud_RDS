provider "aws" {
    region = "us-east-1" # Região da arquitetura
}

#Instância RDS Principal
resource "aws_db_instance" "mainDB" {
    identifier               = "db-01"          # Nome de identificação do RDS
    engine                   = "mysql"          # Engine usada
    engine_version           = "8.0.32"         # Versão da engine
    instance_class           = "db.t2.micro"    # Classe da instância
    username                 = var.username     # Usuário da conexão RDS
    password                 = var.password     # Senha da conexão RDS
    multi_az                 = true             # Define se RDS tem cópia reserva em outra Zona de Disponibilidade
    allocated_storage        = 20               # Quantidade de armazenamento alocado
    backup_retention_period  = 1                # Período de retenção do backup automático do RDS (dias)
    skip_final_snapshot      = true             # Indica se deve pular a criação de um snapshot do RDS para restauração do mesmo

    vpc_security_group_ids   = [aws_security_group.acesso-ssh-DatabaseA.id, aws_security_group.acesso-ssh-DatabaseB.id]      # Grupo de Segurança
    db_subnet_group_name     = aws_db_subnet_group.subnet-database-group.name   # Grupo de subredes
}

#Instância RDS Réplica de Leitura Zona A
resource "aws_db_instance" "readDB1" {
    identifier               = "db-read-01"     # Nome de identificação do RDS
    engine                   = "mysql"          # Engine usada
    engine_version           = "8.0.32"         # Versão da engine
    instance_class           = "db.t2.micro"    # Classe da instância
    replicate_source_db      = aws_db_instance.mainDB.identifier    # Recurso RDS usado como fonte de replicação
    skip_final_snapshot      = true             # Indica se deve pular a criação de um snapshot do RDS para restauração do mesmo

    availability_zone        = "us-east-1a"     # Zona de disponibilidade da instância
    vpc_security_group_ids   = [aws_security_group.acesso-ssh-Database-readDB1.id]      # Grupo de Segurança
}

#Instância RDS Réplica de Leitura Zona B
resource "aws_db_instance" "readDB2" {
    identifier               = "db-read-02"     # Nome de identificação do RDS
    engine                   = "mysql"          # Engine usada
    engine_version           = "8.0.32"         # Versão da engine
    instance_class           = "db.t2.micro"    # Classe da instância
    replicate_source_db      = aws_db_instance.mainDB.identifier    # Recurso RDS usado como fonte de replicação
    skip_final_snapshot      = true             # Indica se deve pular a criação de um snapshot do RDS para restauração do mesmo

    availability_zone        = "us-east-1b"     # Zona de disponibilidade da instância
    vpc_security_group_ids   = [aws_security_group.acesso-ssh-Database-readDB2.id]      # Grupo de Segurança
}
