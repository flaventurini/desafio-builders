# Desafio Builders - DevSecOps

Repositório criado para entrega do desafio técnico da Builders de DevSecOps.

## :computer: Desafio

De acordo com o desafio proposto, foi escolhida a tecnologia Google Cloud Platform e foi desenvolvido um IAC com Terraform para criar uma máquina virtual e um bucket.

Nesta VM, foi criada uma aplicação simples em HTML, que irá subir e ser executada a cada hora via conteiner (dockerfile). A execução, a cada hora, da aplicação foi desenvolvido via IAC com Shell Script para automatizar, tanto a execução da aplicação, quanto a criação de um arquivo de texto contendo a hora de criação como conteúdo e o upload deste arquivo de texto para o bucket, via crontab.

## :information_source: Como executar

### Pré-requisitos

Para executar o projeto, você vai precisar:

1) Criar um projeto no Painel do GCP:
* [Criar Projeto](https://console.cloud.google.com/projectcreate)

2) Dentro do projeto anteriormente criado, você vai precisar habilitar a API do Compute Engine, para criação da VM via código:
* [Habilitar API Compute Engine](https://console.developers.google.com/apis/library/compute.googleapis.com)

3) Criar uma [conta de serviço](https://console.cloud.google.com/apis/credentials/serviceaccountkey) e fazer o download da chave JSON:
* Selecione o projeto criado anteriormente;
* Clique em "Criar conta de serviço" no topo da página;
* Dê qualquer nome que desejar e clique em "Criar";
* Para o Papel, escolha "Projeto -> Editor" e clique em "Continuar";
* Pule a etapa de conceder acessos extras e clique em "Criar";
* Após criação da conta de serviço, selecione essa conta criada na lista de contas que aparecem no painel;
* Selecione a aba "Chaves";
* Clique em "Adicionar chaves -> Criar nova chave"
* Deixe o tipo de chave como JSON, clique em "Criar" e faça o download do arquivo para o seu computador.

----------------------------------------------------------------
### Instalando a VM e o Bucket com Terraform

Para executar o código Terraform para criação da VM e do Bucket, você vai precisar usar um Shell. Pela facilidade de uso, eu recomendo o uso do [Cloud Shell](https://shell.cloud.google.com/?show=ide%2Cterminal) da Google.

Abra o Cloud Shell do GCP
* [Cloud Shell](https://shell.cloud.google.com/?show=ide%2Cterminal)

Clone este repositório para o Cloud Shell, vá para a pasta clonada e copie o conteúdo da chave JSON baixada na etapa 3 acima para o arquivo "serviceaccount.yaml":

```bash
# clone o repositório
$ git clone https://github.com/flaventurini/desafio-builders.git

# acesse a pasta do projeto e crie o arquivo serviceaccount.yaml com o conteúdo da chave JSON
$ cd desafio-builders && vi serviceaccount.yaml

# com o editor VIM aberto -> pressione a tecla "i" para editar -> cole o conteúdo da chave com "crtl+v" -> pressione ESC -> para salvar pressione ":wq" e ENTER

```

Será necessário alterar o ID do Projeto dentro do arquivo de "variables.tf". Faça isso através do editor do bash que preferir.

```bash
# altere o ID do Projeto nessa parte do código. O nome do seu projeto deve estar entre aspas após o "default"
$ vi variables.tf

  variable "project_id" {
    description = "Id do Projeto"
    type        = string
    default     = "teste-devsecops-builders" // substituir pelo id do projeto criado no GCP
  }

```
  
Uma vez copiada a chave JSON para dentro do arquivo "serviceaccount.yaml" e alterada a variável "project_id", é possível dar início a criação da VM e do Bucket via terraform:

```bash
# dentro da pasta /desafio-builders, execute terraform init e terraform apply
$ terraform init && terraform apply -auto-approve

```

Aguarde alguns minutos após a conclusão da criação da VM para dar continuidade para a próxima etapa.

----------------------------------------------------------------
### Configurando a autenticação do Gcloud CLI na VM

Após a configuração da VM e do Bucket via Terraform, criada a VM, vá até o [Painel das Instâncias do Compute Engine](https://console.cloud.google.com/compute/instances). Se todo o procedimento anterior rodou conforme o esperado, você deve observar que a máquina irá aparecer na listagem do painel. 

Clique no botão "SSH" da máquina criada para acessar o bash.

```bash
# verificar se as configurações de máquina foram todas concluídas, verifique se na raiz do filesystem aparece a pasta "app-builders"
$ ls /

# altere o usuário do bash para o root (e rode todos os comandos como root)
$ sudo su

# configure o gcloud cli -> confirme com "y"
$ gcloud auth login --cred-file=/app-builders/serviceaccount.yaml

# caso tenha dado erro, vai ser necessário editar o arquivo "serviceaccount.yaml"
& cd /app-builders && vi serviceaccount.yaml

# com o editor VIM aberto -> pressione "100dd" para apagar o conteúdo -> depois a tecla "i" para editar -> cole o conteúdo da chave JSON com "crtl+v" -> pressione ESC -> para salvar pressione ":wq" e ENTER

# tente novamente configurar o gcloud cli -> confirme com "y"
$ gcloud auth login --cred-file=/app-builders/serviceaccount.yaml

```

Para verificar se as tarefas estão funcionando ou se os arquivos de textos estão sendo criados:

```bash
# rode todos os comandos como root
$ sudo su

# verifique se existem tarefas agendadas para o cron job
$ crontab -l

# verifique se os arquivos de texto estão sendo gerados
$ ls /logs-app

# verifique se os arquivos de textos estão sendo enviados para o Bucket
$ gsutil ls gs://bucket-devsecops-builders

```

Caso seja necessário o envio manual dos arquivos para o Bucket, será necessário rodar o script:

```bash
# rode o comando como root
$ sudo su

# entre na pasta do app
$ cd /app-builders/app

# para testar o script de execução do app e gerar um arquivo de texto
$ ./exec_app.sh

# envie manualmente os arquivos de texto para o Bucket
$ ./bucket.sh

```
----------------------------------------------------------------
### Destruindo a VM e o Bucket

Caso você tenha fechado a janela do Cloud Shell usada para criação da VM e do Bucket, será necessário abrí-la novamente.

* [Cloud Shell](https://shell.cloud.google.com/?show=ide%2Cterminal)

```bash
# va para a pasta do projeto e inicie o terraform
$ cd desafio-builders && terraform init

# aplique o terraform destroy para deletar a VM e o Bucket
$ terraform destroy -auto-approve

# caso deseje, limpe o pasta usada no Cloud Shell
$ cd .. && rm -rf desafio-builders/

```

## :mailbox_with_mail: Contato

<a href="https://www.linkedin.com/in/flaviaventurini/" target="_blank" >
  <img alt="Linkedin - Flávia Venturini" src="https://img.shields.io/badge/Linkedin--%23F8952D?style=social&logo=linkedin">
</a>&nbsp;&nbsp;&nbsp;
<a href="mailto:flaviaventurini@msn.com" target="_blank" >
  <img alt="Email - Flávia Venturini" src="https://img.shields.io/badge/Email--%23F8952D?style=social&logo=gmail">
</a>

---

Made with :coffee: and ❤️ by Flávia Venturini.
