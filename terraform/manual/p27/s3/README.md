Template Terraform — Amazon S3
Objetivo
Criar um bucket S3 com bloqueio de acesso público, criptografia padrão, versionamento configurável e tags de governança.

Estrutura
versions.tf: versões do Terraform e provider AWS.
main.tf: bucket e configurações de segurança.
variables.tf: parâmetros configuráveis.
outputs.tf: identificadores do bucket.
README.md: documentação.
Pré-requisitos
Terraform >= 1.5.0.
Provider AWS configurado.
Permissões para criar e configurar buckets S3.
Variáveis
Variável	Tipo	Obrigatória	Descrição
bucket_name	string	Sim	Nome globalmente exclusivo
environment	string	Sim	dev, hml, stg ou prod
versioning_enabled	bool	Não	Habilita o versionamento; padrão true
additional_tags	map(string)	Não	Tags adicionais
Exemplo de configuração
Crie terraform.tfvars:

bucket_name        = "empresa-app-dados-dev-123456"
environment        = "dev"
versioning_enabled = true

additional_tags = {
  Project    = "AplicacaoDados"
  Owner      = "Plataforma"
  CostCenter = "CC-123"
}
Escolha um nome disponível e compatível com as regras do S3.

Outputs
bucket_name
bucket_arn
bucket_id
Execução
terraform init -backend=false
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
Análise automatizada
checkov -d . --framework terraform
trivy config .
Segurança e governança
Os quatro controles de bloqueio de acesso público estão habilitados.
A criptografia padrão utiliza SSE-S3 com AES-256.
O versionamento é habilitado por padrão.
As tags Environment, ManagedBy e Component são obrigatórias e protegidas contra sobrescrita.
A configuração não cria políticas de bucket nem concede acesso a usuários ou roles.
Para dados sensíveis, avalie SSE-KMS, políticas organizacionais e controles de auditoria.
Para reduzir custos, avalie lifecycle e expiração de versões não atuais.
O versionamento suspenso não exclui versões antigas. O bloqueio público também não substitui políticas IAM adequadas.
