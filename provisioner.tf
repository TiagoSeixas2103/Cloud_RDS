# Adiciona variáveis geradas na criação dos recursos ao arquivo executável
# que cria a database usada pela aplicação Django 
resource "null_resource" "provisioner" {
  depends_on = [aws_instance.EC2-maindbA, aws_instance.EC2-maindbB, aws_db_instance.mainDB]

  provisioner "remote-exec" {
    inline = [
      "cd tasks/portfolio",
      "echo Current directory: $(pwd)",
      "sed -i 's/endereco/${aws_db_instance.mainDB.address}/g' createdb.sh",
      "sed -i 's/usuario/${var.username}/g' createdb.sh",
      "sed -i 's/senha/${var.password}/g' createdb.sh",
    ]

    connection {
      host        = aws_instance.EC2-maindbA.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-1.content
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd tasks/portfolio",
      "echo Current directory: $(pwd)",
      "sed -i 's/endereco/${aws_db_instance.mainDB.address}/g' createdb.sh",
      "sed -i 's/usuario/${var.username}/g' createdb.sh",
      "sed -i 's/senha/${var.password}/g' createdb.sh",
    ]

    connection {
      host        = aws_instance.EC2-maindbB.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-2.content
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd tasks/portfolio",
      "echo Current directory: $(pwd)",
      "sed -i 's/endereco/${aws_db_instance.readDB1.address}/g' createdb.sh",
      "sed -i 's/usuario/${var.username}/g' createdb.sh",
      "sed -i 's/senha/${var.password}/g' createdb.sh",
    ]

    connection {
      host        = aws_instance.EC2-readDB1.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-3.content
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd tasks/portfolio",
      "echo Current directory: $(pwd)",
      "sed -i 's/endereco/${aws_db_instance.readDB2.address}/g' createdb.sh",
      "sed -i 's/usuario/${var.username}/g' createdb.sh",
      "sed -i 's/senha/${var.password}/g' createdb.sh",
    ]

    connection {
      host        = aws_instance.EC2-readDB2.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-4.content
    }
  }

}

# Andiciona ID de EFS no arquivo de montagem de EFS nas Instâncias EC2
resource "null_resource" "provisioner2" {
  depends_on = [aws_instance.EC2-maindbA, aws_instance.EC2-maindbB, aws_instance.EC2-readDB1, aws_instance.EC2-readDB2,
  aws_efs_file_system.EFS, aws_efs_mount_target.EFS_A, aws_efs_mount_target.EFS_B]

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/ID_EFS/${aws_efs_file_system.EFS.id}/g' creatEFS.sh",
    ]

    connection {
      host        = aws_instance.EC2-maindbA.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-1.content
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/ID_EFS/${aws_efs_file_system.EFS.id}/g' creatEFS.sh",
    ]

    connection {
      host        = aws_instance.EC2-maindbB.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-2.content
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/ID_EFS/${aws_efs_file_system.EFS.id}/g' creatEFS.sh",
    ]

    connection {
      host        = aws_instance.EC2-readDB1.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-3.content
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/ID_EFS/${aws_efs_file_system.EFS.id}/g' creatEFS.sh",
    ]

    connection {
      host        = aws_instance.EC2-readDB2.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = local_file.KEY-4.content
    }
  }
}