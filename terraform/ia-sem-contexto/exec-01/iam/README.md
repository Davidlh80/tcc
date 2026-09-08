Nome
Blueprint Terraform: AWS IAM Policy

Descricao
Este template cria uma IAM Policy gerenciada (customer managed) na AWS a partir de declaracao de statements configuraveis via variaveis. Segue o principio de configuracao segura por padrao (sem permissoes implicitas) exigindo que voce defina os statements de acordo com sua necessidade.

Arquivos
- main.tf: Provider, documento da policy (data aws_iam_policy_document) e recurso aws_iam_policy.
- variables.tf: Variaveis de configuracao, com validacoes basicas.
- outputs.tf: Informacoes uteis da policy criada (ARN, nome, versao padrao, etc.).
- versions.tf: Versoes minimas do Terraform e provider AWS.
- README.md: Instrucoes de uso.

Requisitos
- Terraform >= 1.3.0
- Provider AWS ~> 5.x
- Credenciais AWS configuradas no ambiente (para apply)

Como usar (exemplo)
1) Ajuste as variaveis em terraform.tfvars ou via -var/-var-file.
2) Execute:
   terraform init -backend=false
   terraform validate
   terraform plan
   terraform apply

Exemplo de terraform.tfvars (cria uma policy somente-leitura de S3 e CloudWatch Logs):
aws_region = "us-east-1"
policy_name_prefix = "example-ro-"
policy_description = "Acesso somente-leitura a S3 e CloudWatch Logs."
policy_path = "/customer-managed/"
tags = {
  Project = "demo"
  Env     = "dev"
}
statements = [
  {
    sid       = "S3ReadOnly"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
  },
  {
    sid       = "LogsReadOnly"
    effect    = "Allow"
    actions   = ["logs:Describe*", "logs:Get*", "logs:List*"]
    resources = ["*"]
  }
]

Variaveis
- aws_region (string, padrao: us-east-1)
  Regiao AWS.

- policy_name (string, padrao: null)
  Nome exato da policy. Se definido, tem precedencia sobre policy_name_prefix.

- policy_name_prefix (string, padrao: custom-)
  Prefixo do nome quando policy_name nao for definido.

- policy_description (string, padrao: "Policy gerenciada pelo Terraform.")
  Descricao da policy.

- policy_path (string, padrao: /customer-managed/)
  Deve iniciar e terminar com "/".

- tags (map(string), padrao: {})
  Tags adicionais aplicadas ao recurso.

- statements (list(object), padrao: [])
  Lista de statements. Campos:
  - sid (opcional, string)
  - effect (opcional, string: Allow ou Deny; padrao: Allow)
  - actions (obrigatorio, set(string))
  - resources (obrigatorio, set(string))
  - conditions (opcional, list(object)):
    - test (string, ex.: StringEquals, ArnLike)
    - variable (string, ex.: aws:PrincipalOrgID)
    - values (set(string))

Observacoes de seguranca
- Por padrao, nenhuma permissao e concedida (statements vazio). Defina explicitamente os acessos necessarios (principio do menor privilegio).
- Evite o uso de recursos "*" quando possivel; restrinja a ARNs especificos.
- Revise cuidadosamente as actions e conditions antes de aplicar em ambientes produtivos.

Outputs
- policy_id: ID da policy.
- policy_arn: ARN da policy.
- policy_name: Nome final da policy.
- policy_path: Path da policy.
- policy_default_version_id: Versao padrao da policy.
- policy_document_json: Documento JSON gerado.

Licenca
Uso livre como exemplo de IaC. Ajuste conforme suas necessidades.
