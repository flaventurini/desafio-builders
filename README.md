# Desafio Builders
Repositório criado para entrega do desafio técnico da Builders

Pré-requisitos:

Criação de um projeto no GCP - https://console.cloud.google.com/projectcreate
Habilitação do Google Compute Engine no projeto anteriormente criado - https://console.developers.google.com/apis/library/compute.googleapis.com
Criação de uma conta de serviço e download da chave - https://console.cloud.google.com/apis/credentials/serviceaccountkey
•	Select the project you created in the previous step.
•	Click "Create Service Account".
•	Give it any name you like and click "Create".
•	For the Role, choose "Project -> Editor", then click "Continue".
•	Skip granting additional users access, and click "Done".
After you create your service account, download your service account key.
•	Select your service account from the list.
•	Select the "Keys" tab.
•	In the drop down menu, select "Create new key".
•	Leave the "Key Type" as JSON.
•	Click "Create" to create the key and save the key file to your system.

// Instalação do Bucket e da VM
Abra o Cloud Shell do GCP - https://shell.cloud.google.com/?show=ide%2Cterminal
Git clone (main.tf)
Cd desafio-builders
Terraform init
Terraform apply
Type yes

// Criação da aplicação via dockerfile
Abra o Cloud Shell do GCP, igual na etapa anterior
Execute o comando:
gcloud compute ssh --project=PROJECT_ID --zone=ZONE VM_NAME
Substitua:
•	PROJECT_ID: o ID do projeto que contém a instância.
•	ZONE: o nome da zona em que a instância está localizada.
•	VM_NAME: o nome da instância.
Ao usar o comando, o shell vai precisar criar uma chave ssh. Confirme que deseja continuar digitando “y” e aperte enter.
Vai pedir uma senha para a chave ssh. É desejável que a mesma seja definida, para maior segurança.

Usando o SSH direto do Compute Engine
"""
Sudo su
"""
Instalar o git
Git clone vm_script.sh
chmod ugo+x vm_script.sh
./vm_script.sh


