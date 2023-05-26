resource "aws_efs_file_system" "EFS" {
  creation_token = "EFS-MAIN"           # Nome EFS
  encrypted      = false                # Sem criptografia
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"  # Após 30 dias, dados sem uso frequente são armazenados em uma classe diferente (reduz custo)
  }
}

resource "aws_efs_mount_target" "EFS_A" {
  depends_on = [aws_efs_file_system.EFS, aws_subnet.public_subnet_us_east_1a, aws_security_group.acesso-ssh-Regiao1]
  file_system_id  = aws_efs_file_system.EFS.id                  # ID do EFS
  subnet_id       = aws_subnet.public_subnet_us_east_1a.id      # ID da Sub-rede
  security_groups = [aws_security_group.acesso-ssh-Regiao1.id]  # Grupo de Segurança
}

resource "aws_efs_mount_target" "EFS_B" {
  depends_on = [aws_efs_file_system.EFS, aws_subnet.public_subnet_us_east_1b, aws_security_group.acesso-ssh-Regiao2]
  file_system_id  = aws_efs_file_system.EFS.id                  # ID do EFS
  subnet_id       = aws_subnet.public_subnet_us_east_1b.id      # ID da Sub-rede          
  security_groups = [aws_security_group.acesso-ssh-Regiao2.id]  # Grupo de Segurança  
}