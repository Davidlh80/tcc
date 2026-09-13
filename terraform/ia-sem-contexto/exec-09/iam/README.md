# IAM Policy — Terraform Blueprint

Blueprint Terraform para provisionamento de uma IAM Policy na AWS, gerada de forma independente, sem vínculo com padrões organizacionais específicos, seguindo boas práticas gerais de mercado de segurança em IAM.

## Objetivo

Criar uma `aws_iam_policy` com uma statement construída via `aws_iam_policy_document`, permitindo configurar actions, resources, effect e uma condição opcional de transporte seguro (`aws:SecureTransport`).

## Decisões de segurança adotadas

- **Sem wildcard total**: as variáveis `allowed_actions` e `allowed_resources` possuem validações que rejeitam o valor `"*"`, forçando a definição explícita de actions e recursos.
- **Least privilege por padrão**: os valores default concedem apenas `s3:GetObject` e `s3:ListBucket` sobre um bucket de exemplo, evitando privilégios administrativos por padrão.
- **Transporte seguro**: por padrão (`enforce_secure_transport = true`), é adicionada uma condição exigindo `aws:SecureTransport = true`, bloqueando chamadas via HTTP não criptografado quando aplicável ao serviço.
- **Sem credenciais reais**: o blueprint não depende de credenciais, backends remotos ou dados sensíveis fixos no código.

## Uso

```
terraform init -backend=false
terraform validate
terraform plan \
  -var="policy_name=my-app-read-policy" \
  -var='allowed_actions=["s3:GetObject","s3:ListBucket"]' \
  -var='allowed_resources=["arn:aws:s3:::my-bucket","arn:aws:s3:::my-bucket/*"]'
```

## Variáveis principais

| Nome | Descrição | Default |
|---|---|---|
| `aws_region` | Região do provider AWS | `us-east-1` |
| `policy_name` | Nome da IAM Policy | `example-least-privilege-policy` |
| `policy_description` | Descrição da policy | texto padrão |
| `path` | Path IAM da policy | `/` |
| `effect` | `Allow` ou `Deny` | `Allow` |
| `allowed_actions` | Actions IAM permitidas (sem `*`) | `["s3:GetObject", "s3:ListBucket"]` |
| `allowed_resources` | ARNs de recursos (sem `*`) | ARNs de bucket de exemplo |
| `enforce_secure_transport` | Adiciona condição SecureTransport | `true` |
| `tags` | Tags aplicadas à policy | `{}` |

## Outputs

| Nome | Descrição |
|---|---|
| `policy_arn` | ARN da IAM Policy criada |
| `policy_id` | ID da IAM Policy criada |
| `policy_name` | Nome da IAM Policy criada |
| `policy_document_json` | Documento JSON gerado da policy |

## Observações

- Ajuste `allowed_actions` e `allowed_resources` conforme o caso de uso real antes de aplicar em produção.
- Para anexar esta policy a uma role ou usuário, utilize `aws_iam_role_policy_attachment` ou `aws_iam_user_policy_attachment` referenciando `aws_iam_policy.this.arn` (fora do escopo deste blueprint).
- Este blueprint não cria roles, grupos ou usuários — apenas o recurso de policy gerenciada.
