Blueprint Terraform: AWS IAM Policy

Visão geral
- Este template provisiona uma IAM Policy gerenciada (Customer Managed) na AWS.
- Por padrão, cria uma política de leitura para S3 (Get/List).
- É possível fornecer um JSON de política completo via variável policy_json para controle total.

Arquivos
- versions.tf: versões mínimas do Terraform e do provider AWS.
- variables.tf: definição e validação das variáveis de entrada.
- main.tf: recursos Terraform para compor e criar a IAM Policy.
- outputs.tf: saídas úteis como ARN e documento final da política.
- README.md: instruções de uso.

Pré-requisitos
- Terraform 1.3+.
- Provider AWS 5.0+.
- Credenciais AWS válidas no ambiente (por exemplo, via AWS_PROFILE, AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY). A validação sintática não requer acesso às APIs.

Como usar (exemplo mínimo)
1) Ajuste as variáveis conforme necessário (por exemplo, em um arquivo terraform.tfvars):
aws_region = "us-east-1"
policy_name = "myapp-s3-readonly"
actions = ["s3:GetObject", "s3:ListBucket"]
resources = [
  "arn:aws:s3:::my-bucket",
  "arn:aws:s3:::my-bucket/*"
]
tags = {
  project = "myapp"
  env     = "dev"
}

2) Inicialize e valide:
terraform init -backend=false
terraform validate
terraform plan
terraform apply

Sobre o controle do documento da política
- Modo simples (padrão): use as variáveis actions e resources para gerar automaticamente o documento. O effect padrão é Allow.
- Modo avançado: defina policy_json com um documento JSON válido de IAM. Quando policy_json é fornecido, as variáveis actions e resources são ignoradas.

Exemplo de policy_json (resumo em uma linha para facilitar colagem)
{ "Version":"2012-10-17","Statement":[{ "Sid":"ReadS3Specific","Effect":"Allow","Action":["s3:GetObject","s3:ListBucket"],"Resource":["arn:aws:s3:::my-bucket","arn:aws:s3:::my-bucket/*"] }] }

Boas práticas e padrões seguros
- Evite incluir segredos em descrições, nomes ou tags.
- Prefira restringir resources a ARNs específicos em vez de usar "*".
- Validações ajudam a evitar entradas inválidas (ex.: policy_json precisa ser JSON válido).
- Tags padrão incluem ManagedBy=Terraform; você pode adicionar as suas via a variável tags. Chaves que começam com aws: são bloqueadas.

Saídas
- iam_policy_arn: ARN da política criada.
- iam_policy_name: Nome da política.
- iam_policy_id: ID interno do recurso.
- iam_policy_path: Caminho da política.
- iam_policy_document: Documento JSON final da política (decodificado).
- iam_policy_tags: Tags efetivas aplicadas.

Notas
- Não é configurado backend remoto neste template (state local).
- Nenhuma dependência de credenciais reais é necessária para terraform init -backend=false e terraform validate.
