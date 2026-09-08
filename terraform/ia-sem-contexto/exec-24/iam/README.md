Blueprint Terraform: IAM Policy (AWS)

Descrição
- Cria uma IAM Policy (Customer Managed) na AWS usando Terraform.
- Por padrão, quando nenhum statement é informado, cria uma policy mínima com a permissão sts:GetCallerIdentity para facilitar validação e testes sem conceder privilégios elevados.

Requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas no ambiente de execução (para apply). Para terraform validate não são necessárias.

Entradas (variables)
- aws_region (string, default: us-east-1): Região AWS.
- policy_name (string, default: custom-iam-policy): Nome da policy.
- policy_description (string, default: Managed by Terraform - Customer managed policy.): Descrição.
- policy_path (string, default: "/"): Path da policy. Deve ser "/" ou iniciar e terminar com "/".
- policy_statements (list(object), default: []): Lista de statements. Campos:
  - effect: "Allow" ou "Deny"
  - actions: lista de ações (ex.: ["s3:ListBucket"])
  - resources: lista de ARNs ou "*" (ex.: ["arn:aws:s3:::meu-bucket"])
  - condition (opcional): lista de condições com campos test, variable, values
- tags (map(string), default: {}): Tags aplicadas ao recurso.

Saídas (outputs)
- iam_policy_arn: ARN da policy criada.
- iam_policy_name: Nome da policy.
- iam_policy_id: ID exclusivo da policy.
- iam_policy_default_version_id: Versão padrão da policy.
- iam_policy_document_json: Documento JSON efetivo gerado.

Exemplo de uso
# Definindo uma policy de leitura em S3
aws_region = "us-east-1"

policy_name        = "example-readonly-s3"
policy_description = "Exemplo de policy de somente leitura no S3"
policy_path        = "/teamA/"

policy_statements = [
  {
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets", "s3:ListBucket"]
    resources = ["*"]
  },
  {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::meu-bucket/*"]
  }
]

tags = {
  Project = "example"
  Owner   = "devops"
}

Como validar localmente
- terraform init -backend=false
- terraform validate
- terraform plan (requer credenciais AWS configuradas)

Boas práticas
- Use recursos e ações o mais específicos possível, evitando curingas quando não necessários.
- Utilize tags para facilitar governança e auditoria.
- Revise cuidadosamente os statements antes de aplicar em ambientes produtivos.
