# Blueprints Terraform - P31

Este projeto contem tres blueprints independentes, cada uma em sua propria pasta:

- `iam/`: role de servico com policy customer-managed anexada;
- `s3/`: bucket privado com criptografia e versionamento configuravel;
- `security-group/`: grupo de seguranca com regras TCP explicitas.

Cada pasta e uma raiz Terraform separada e possui seu proprio estado. Execute
`terraform init`, `terraform fmt -check` e `terraform validate` dentro da pasta
da blueprint que deseja validar. Os arquivos `terraform.tfvars` nao estao
incluidos; forneca os valores requeridos por variaveis ou por um arquivo local
que nao contenha credenciais.

As regras de rede nao abrem portas nem liberam trafego de saida por padrao. A
policy IAM requer a declaracao explicita de acoes e recursos, e o principal de
confianca e um servico AWS configuravel, nunca um principal universal.
