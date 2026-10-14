Template Terraform — AWS IAM
Objetivo
Criar uma policy IAM, uma role IAM e associar a policy à role, utilizando permissões configuráveis e uma trust policy restrita.

Estrutura
versions.tf: versões do Terraform e provider AWS.
main.tf: policy, role, trust policy e associação.
variables.tf: variáveis e validações.
outputs.tf: identificadores dos recursos.
README.md: documentação de uso.
Pré-requisitos
Terraform >= 1.5.0.
Credenciais AWS configuradas por um mecanismo seguro.
Permissões para criar policies, roles e associações IAM.
Variáveis
Variável	Tipo	Obrigatória	Descrição
policy_name	string	Sim	Nome-base da policy
role_name	string	Sim	Nome-base da role
environment	string	Sim	dev, hml, stg ou prod
trusted_principal_type	string	Não	Service, AWS ou Federated
trusted_principal_identifiers	list(string)	Sim	Principals autorizados
allowed_actions	list(string)	Sim	Ações IAM permitidas
allowed_resources	list(string)	Sim	ARNs dos recursos
max_session_duration	number	Não	Duração máxima da sessão
additional_tags	map(string)	Não	Tags adicionais
Exemplo de configuração
Crie um arquivo terraform.tfvars:

policy_name = "app-s3-read"
role_name   = "app-s3-reader"
environment = "dev"

trusted_principal_type = "Service"

trusted_principal_identifiers = [
  "ec2.amazonaws.com"
]

allowed_actions = [
  "s3:GetObject"
]

allowed_resources = [
  "arn:aws:s3:::meu-bucket/dados/*"
]

additional_tags = {
  Project = "Aplicacao"
  Owner   = "Plataforma"
}
O exemplo permite leitura de objetos no caminho indicado. Ajuste o principal e os ARNs à arquitetura real.

Outputs
policy_name
policy_arn
policy_id
role_name
role_arn
Execução
terraform init -backend=false
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
Análise de segurança
checkov -d . --framework terraform
trivy config .
Revise os resultados antes da implantação.

Considerações de segurança
Não utilize Action = "*".
Evite principals amplos, inclusive contas inteiras, quando uma role específica puder ser utilizada.
Curingas em ARNs podem ser necessários para recursos como objetos S3, mas devem limitar-se ao escopo necessário.
A validação sintática não comprova que todas as permissões são necessárias.
Para OIDC e federação, configure as condições de confiança específicas do provedor.
