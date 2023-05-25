---
Título: Projeto Cloud - RDS
Autor: Tiago Vitorino Seixas

---

## Documentações das ferramentas de desenvolvimento utilizadas:

* [Terraform](https://www.terraform.io/docs/index.html)
* [AWS](https://docs.aws.amazon.com/index.html)
* [VScode](https://code.visualstudio.com/docs)

## Pré-requisitos

Para executar essa arquitetura, verifique se os seguintes requisitos foram cumpridos:

  * Terraform v1.4.6 ou mais recente instalado localmente (https://www.terraform.io/)
  * AWS CLI instalado (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)

## Material

  * Usuário IAM na conta do grupo H - devido ao uso de uma AMI personalizada
  * Chaves de acesso criadas para o usuário AWS CLI
  * Mantenha abertas abas das instâncias EC2 e RDS

    - https://console.aws.amazon.com/rds/

      - Selecione: Banco de Dados

    - https://console.aws.amazon.com/ec2/
        
      - Selecione: Instâncias

### <span style="color:red">Atenção!</span> NÃO continue sem ter um usuário na conta do grupo H! <span style="color:red">Atenção!</span>
### <span> Como mencionado antes, foi utilizada uma imagem AMI personalizada</span>
### <span> Caso a conta tenha sido perdida, mais abaixo no readme, após o destroy, tem um guia para criar uma nova imagem AMI usando ubuntu e uma instância EC2</span>

## Estrutura do Projeto

  * Clone o projeto do github, no qual se encontram os seguintes arquivos:
```sh
projeto_cloud/
├── rds.tf 
├── ec2.tf 
├── sg.tf
├── subnet.tf
├── key.tf
├── efs.tf
├── provisioner.tf
├── credentials.tf
├── .gitignore
└── readme.md
```

Relational Database Service
- rds.tf
  * provider "aws" - determina região do deploy
  * aws_db_instance "mainDB" - RDS DB instância principal e secundária em espera (Multi-AZ)
  * aws_db_instance "readDB1" - RDS DB instância de réplica de leitura (Zona us-east-1a)
  * aws_db_instance "readDB2" - RDS DB instância de réplica de leitura (Zona us-east-1b)

Elastic Compute Cloud
- ec2.tf
  * aws_instance "EC2-maindbA" - Servidor Web de Produção (Zona us-east-1a)
  * aws_instance "EC2-maindbB" - Servidor Web de Produção (Zona us-east-1b)
  * aws_instance "EC2-readDB1" - Servidor de Relatórios de Produção (Zona us-east-1a)
  * aws_instance "EC2-readDB2" - Servidor de Relatórios de Produção (Zona us-east-1b)

Security Group
- sg.tf
  * aws_security_group "acesso-ssh-Regiao1" - Grupo de Segurança Instância EC2-maindbA
  * aws_security_group "acesso-ssh-Regiao2" - Grupo de Segurança Instância EC2-maindbB
  * aws_security_group "acesso-ssh-DatabaseA" - Grupo de Segurança Instância RDS mainDB (conecta com EC2-maindbA)
  * aws_security_group "acesso-ssh-DatabaseB" - Grupo de Segurança Instância RDS mainDB (conecta com EC2-maindbB)
  * aws_security_group "acesso-ssh-Regiao1-read" - Grupo de Segurança Instância EC2-readDB1 
  * aws_security_group "acesso-ssh-Database-readDB1" - Grupo de Segurança Instância RDS readDB1 (conecta com EC2-readDB1)
  * aws_security_group "acesso-ssh-Regiao2-read" - Grupo de Segurança Instância EC2-readDB2
  * aws_security_group "acesso-ssh-Database-readDB2" - Grupo de Segurança Instância RDS readDB2 (conecta com EC2-readDB2)

Subnet
- subnet.tf
  * aws_vpc "vpc_database" - Nuvem Privada
  * aws_internet_gateway "internet_gateway" - Gateway entre vpc_database e Internet
  * aws_route_table "public_subnet_route_table" - Tabela para roteamento das sub-redes internas de vpc_database (permite conectá-las à Internet)
  * aws_subnet "public_subnet_us_east_1a" - Sub-rede pública (Zona us-east-1a)
  * aws_route_table_association "public_subnet_association_a" - Associação da sub-rede pública à aws_route_table (Zona us-east-1a)
  * aws_subnet "public_subnet_us_east_1b" - Sub-rede pública (Zona us-east-1b)
  * aws_route_table_association "public_subnet_association_b" - Associação da sub-rede pública à aws_route_table (Zona us-east-1b)
  * aws_subnet "private_subnet_us_east_1a" - Sub-rede privada (Zona us-east-1a)
  * aws_subnet "private_subnet_us_east_1b" - Sub-rede privada (Zona us-east-1b)
  * aws_db_subnet_group "subnet-database-group" - Grupo de sub-redes privadas (RDS Multi-AZ)

Key Pair
- key.tf
  * tls_private_key "rsa1" - Cria chave privada
  * aws_key_pair "chave-maindbA" - Cria Key Pair usando rsa1 e associa à uma instância EC2 (EC2-maindbA)
  * local_file "KEY-1" - Cria um arquivo local .pem para conexão remota com instância EC2 (EC2-maindbA)
  * tls_private_key "rsa2" - Cria chave privada
  * aws_key_pair "chave-maindbB" - Cria Key Pair usando rsa2 e associa à uma instância EC2 (EC2-maindbB)
  * local_file "KEY-2" - Cria um arquivo local .pem para conexão remota com instância EC2 (EC2-maindbB)
  * tls_private_key "rsa3" - Cria chave privada
  * aws_key_pair "chave-readdb1" - Cria Key Pair usando rsa3 e associa à uma instância EC2 (EC2-readDB1)
  * local_file "KEY-3" - Cria um arquivo local .pem para conexão remota com instância EC2 (EC2-readDB1)
  * tls_private_key "rsa4" - Cria chave privada
  * aws_key_pair "chave-readdb2" - Cria Key Pair usando rsa4 e associa à uma instância EC2 (EC2-readDB2)
  * local_file "KEY-4" - Cria um arquivo local .pem para conexão remota com instância EC2 (EC2-readDB2)

Elastic File System
- efs.tf
  * aws_efs_file_system "EFS" - Cria EFS
  * aws_efs_mount_target "EFS_A" - Monta Região de acesso na sub-rede pública (Zona us-east-1a)
  * aws_efs_mount_target "EFS_B" - Monta Região de acesso na sub-rede pública (Zona us-east-1b)

Provisioner
- provisioner.tf
  * null_resource "provisioner" - Atualiza arquivo createdb.sh com host, usuário e senha do RDS associado nas instâncias EC2 após apply
  * null_resource "provisioner2" - Atualiza arquivo creatEFS.sh com ID de aws_efs_file_system nas instâncias EC2 após apply

Credentials
- credentials.tf
  * variable "username" - Usuário RDS
  * variable "password" - Senha RDS

## Executando projeto

### <span style="color:red">Atenção!</span> Não saia copiando direto os comandos! <span style="color:red">Atenção!</span>
### Leia as instruções primeiro e preste atenção aos comandos em si!

  * Entre na pasta do projeto, e atribua as suas credenciais a um profile, usando o comando abaixo
```sh
/projeto_cloud # aws configure --profile [Inserir nome do usuário IAM]
```

### Ao rodar o comando anterior, preencha os campos de input conforme eles forem aparecendo, como exemplificado abaixo
```sh
AWS Access Key ID [****************XXXX]: # [Inserir Access Key ID]
AWS Secret Access Key [****************XXXX]:  # [Secret Access Key]
Default region name [None]: # us-east-1
Default output format [None]: # [Deixar em branco]

```

  * Após atribuir as credenciais ao profile que você criou, cheque se o mesmo foi criado (ou alterado)
  corretamente com os comandos abaixo:
```sh
/projeto_cloud # aws configure list-profiles
/projeto_cloud # aws configure list --profile [Inserir nome do usuário IAM]
```

  * Uma vez que você tenha confirmado que o profile foi criado, e que suas credenciais foram corretamente 
  atribuídas, exporte esse profile para ser usado como default:
```sh
/projeto_cloud # export AWS_PROFILE=[Inserir nome do usuário IAM]
```

  * Agora que já foi configurado o profile, ainda dentro da pasta 'projeto_cloud', dê o comando para iniciar a arquitetura
```sh
/projeto_cloud # terraform init
```

  * Valide que a infraestrutura está funcionando:
```sh
/projeto_cloud # terraform validate
```

  * Crie o plano no terraform:
```sh
/projeto_cloud # terraform plan -out plano
```

  * Execute o plano:
```sh
/projeto_cloud # terraform apply "plano"
```

## Demora cerca de 25~30 minutos para que todos os recursos sejam criados
## Espere até receber a mensagem <span style="color:green">Apply complete!</span>

 * Confira no AWS Management Console se a Zona de disponibilidade é us-east-1a ou us-east-1b, para depois fazer o teste de failover de Multi A-Z corretamente
 * Uma vez que todas as instâncias foram criadas, conecte-se à instância EC2_maindbA ou EC2-maindbB (dependendo da Zona) pelo AWS Management Console ou pelo terminal da sua máquina
 * Devido a problemas de copy paste no terminal de conexão fornecido pela AWS, esse projeto foi feito realizando a conexão pelo terminal do computador
 * Para conectar-se pelo terminal do seu computador, será necessário pegar o DNS IPv4 público dessa instância na AWS, e usá-lo em um dos comandos que seguem:

Caso queira entrar na Instância EC2_maindbA:
```sh
/projeto_cloud # ssh -i KEY1.pem ubuntu@[Inserir IPV4 EC2_maindbA]
```
Caso queira entrar na Instância EC2_maindbB:
```sh
/projeto_cloud # ssh -i KEY2.pem ubuntu@[Inserir IPV4 EC2_maindbB]
```

### <span style="color:red">Atenção!</span> Note que a chave .pem muda dependendo do EC2! <span style="color:red">Atenção!</span>
### As chaves existentes foram mencionadas anteriormente quando o arquivo key.tf foi explicado

  * Assim que se conectar à instância, entre na pasta portfolio, dentro da pasta tasks, e crie a database na instância
  RDS gerada pelo terraform que será usada pelo Django, e configure o settings.py
  * Para facilitar, foi criado um executável 'createdb.sh', que foi atualizado com o provisioner, você só precisa rodá-lo
  * Tenha aberto o arquivo credentials.tf para pegar a senha da sua database
```sh
/~/ # cd tasks/portfolio
/~/tasks/portfolio/ # ./createdb.sh
```
### Lembre-se, é necessário colocar a senha do arquivo credentials.tf, que é a senha do RDS, para poder acessá-lo
```sh
Password: #[Insira senha]
```
  * Se você não colocou a senha, ou recebeu uma mensagem de que não conseguiu se conectar ao mysql, rode o executável novamente e coloque a senha corretamente dessa vez
  * Se estiver conectado ao EC2 pelo conector da própria AWS, você terá que digitar manualmente a senha
  * Por isso foi recomendado anteriormente que você realizasse a conexão pelo terminal da sua máquina
  * Caso tenha dado tudo certo, você não receberá nenhuma mensagem de output
  * Se você rodar o executável de novo, e preencher o campo de senha corretamente mais uma vez, você receberá uma mensagem de alerta de que a database que você está tentando criar já existe

## Testando django

  * Agora que o seu django tem uma database para utilizar, volte para a pasta tasks, crie o superuser e realize as migrações necessárias
  * Há um executável que faz isso
```sh
/~/tasks/portfolio/ # cd ..
/~/tasks/ # ./install.sh
```
  * Agora use o comando a seguir para rodar o app django:
```sh
/~/tasks/ # python3 manage.py runserver 0.0.0.0:8000
```
  * Com o django rodando, pegue o IPv4 público da instância EC2, no mesmo dashboard onde pegou o DNS
  * Com o IP, acesse os seguintes links em abas diferentes no seu navegador
```sh
http://[IPv4]:8000
http://[IPv4]:8000/admin
```
  * No caso desse projeto, foi usado o usuário 'cloud' e a senha 'cloud' para criar o superuser do django no executável 'install.sh' 
  * Quando você adicionar uma task ao django pela aba admin, você pode ver que ela foi criada dando refresh na outra aba

## Testando Failover Zona Main (Multi A-Z)
  * Selecione o RDS mainDB no AWS Management Console e, em ações, dê um reboot, selecionando a opção com failover
### <span style="color:red">Atenção!</span> Espere de 1 a 3 minutos APÓS a reinicialização terminar! <span style="color:red">Atenção!</span>
  * Ao checar a Zona de Disponibilidade, você verá que ela mudou
  * Caso você tenha seguido corretamente os passos anteriores, a EC2 na qual você está conectado se encontra na mesma Zona que a RDS Primária
  * Mude para a instância EC2_maindb (EC2_maindbA ou EC2_maindbB, dependendo da região original do seu mainDB) na outra Zona usando os comandos fornecidos anteriormente, mas com o DNS da nova instância EC2 na qual você está tentando se conectar
Caso queira entrar na Instância EC2_maindbA:
```sh
/projeto_cloud # ssh -i KEY1.pem ubuntu@[Inserir IPV4 EC2_maindbA]
```
Caso queira entrar na Instância EC2_maindbB:
```sh
/projeto_cloud # ssh -i KEY2.pem ubuntu@[Inserir IPV4 EC2_maindbB]
```
### Importante lembrar que a chave .pem para acessar essa nova instância é diferente em cada EC2

## Testando EFS
  * Entre em duas instâncias EC2 quaisquer
  Caso queira entrar na Instância EC2_maindbA:
```sh
/projeto_cloud # ssh -i KEY1.pem ubuntu@[Inserir IPV4 EC2_maindbA]
```
Caso queira entrar na Instância EC2_maindbB:
```sh
/projeto_cloud # ssh -i KEY2.pem ubuntu@[Inserir IPV4 EC2_maindbB]
```
Caso queira entrar na Instância EC2_readDB1:
```sh
/projeto_cloud # ssh -i KEY3.pem ubuntu@[Inserir IPV4 EC2_readDB1]
```
Caso queira entrar na Instância EC2_readDB2:
```sh
/projeto_cloud # ssh -i KEY4.pem ubuntu@[Inserir IPV4 EC2_readDB2]
```
### Importante lembrar que a chave .pem para acessar essa nova instância é diferente em cada EC2

  * Caso esteja na pasta tasks ou portfolio em alguma das conexões, volte para a pasta inicial onde está o arquivo creatEFS.sh e a pasta task
```sh
/~/tasks/ # cd ..
/~/ # ls
tasks creatEFS.sh
```
  * Execute o arquivo de montagem do EFS nas duas Instâncias EC2
```sh
/~/ # sudo ./creatEFS.sh
```
  * Entre na pasta EFS criada nas duas Instâncias EC2, e veja o conteúdo delas
```sh
/~/ # cd EFS
/~/EFS/ # ls
```
  * Em uma das instâncias, crie um arquivo qualquer
```sh
/~/EFS/ # sudo touch teste.txt
```
  * Na outra instância EC2, confirme se esse arquivo foi criado
```sh
/~/EFS/ # ls
```

## Destruindo Recursos

### <span style="color:red">Atenção!</span> NÃO dê terraform destroy direto! <span style="color:red">Atenção!</span>
### Se você fizer isso, tem altas chances de ficar esperando a destruição dos recursos para sempre!

  * Para destruir os recursos, rode primeiro o seguinte comando:
```sh
terraform destroy -target=aws_instance.EC2-readDB1 -target=aws_instance.EC2-readDB2 -target=aws_instance.EC2-maindbA -target=aws_instance.EC2-maindbB
```
## Demora cerca de 10~15 minutos para que os recursos sejam destruídos
## Espere até receber a mensagem <span style="color:green">Destroy complete!</span>

  * Por fim, destrua o resto dos recursos

```sh
terraform destroy
```
## Demora cerca de 5~10 segundos para que o resto dos recursos sejam destruídos
## Espere até receber a mensagem <span style="color:green">Destroy complete!</span>