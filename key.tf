# Chave Privada 1
resource "tls_private_key" "rsa1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Key Pair EC2-maindbA
resource "aws_key_pair" "chave-maindbA" {
  key_name   = "chave-maindbA"
  public_key = tls_private_key.rsa1.public_key_openssh
}

# Chave Privada 1 - Salva em Arquivo Local
resource "local_file" "KEY-1" {
  content  = tls_private_key.rsa1.private_key_pem
  filename = "KEY1.pem"
}

# Chave Privada 2
resource "tls_private_key" "rsa2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Key Pair EC2-maindbB
resource "aws_key_pair" "chave-maindbB" {
  key_name   = "chave-maindbB"
  public_key = tls_private_key.rsa2.public_key_openssh
}

# Chave Privada 2 - Salva em Arquivo Local
resource "local_file" "KEY-2" {
  content  = tls_private_key.rsa2.private_key_pem
  filename = "KEY2.pem"
}

# Chave Privada 3
resource "tls_private_key" "rsa3" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Key Pair EC2-readdb1
resource "aws_key_pair" "chave-readdb1" {
  key_name   = "chave-readdb1"
  public_key = tls_private_key.rsa3.public_key_openssh
}

# Chave Privada 3 - Salva em Arquivo Local
resource "local_file" "KEY-3" {
  content  = tls_private_key.rsa3.private_key_pem
  filename = "KEY3.pem"
}

# Chave Privada 4
resource "tls_private_key" "rsa4" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Key Pair EC2-readdb2
resource "aws_key_pair" "chave-readdb2" {
  key_name   = "chave-readdb2"
  public_key = tls_private_key.rsa4.public_key_openssh
}

# Chave Privada 4 - Salva em Arquivo Local
resource "local_file" "KEY-4" {
  content  = tls_private_key.rsa4.private_key_pem
  filename = "KEY4.pem"
}