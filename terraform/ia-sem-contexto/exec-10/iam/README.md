Nome
- IAM Policy Terraform Blueprint (AWS)

Descrição
- Blueprint Terraform para criar uma AWS IAM Managed Policy.
- Por padrão, cria uma policy mínima e segura que permite apenas sts:GetCallerIdentity.
- É possível fornecer uma policy JSON completa (policy_json) ou compor via policy_statements.

Arquivos
- versions.tf: versões mínimas do Terraform e provider AWS.
- variables.tf: variáveis configuráveis com validações.
- main.tf: provider, construção do documento de policy e recurso aws_iam_policy.
- outputs.tf: ARNs e metadados úteis da policy.
- README.md: instruções de uso.

Pré-requisitos
- Terraform >= 1.3.0
- Provider AWS >= 5.0
- Credenciais AWS válidas exportadas no ambiente ou via mecanismo padrão do provider.

Como usar (exemplo rápido)
1) Ajuste as variáveis principais:
- policy_name: nome único da policy.
- opcionalmente altere aws_region, policy_path, policy_description e tags.
- para personalizar permissões, use uma das abordagens:
  a) Forneça policy_json com o JSON completo da policy.
  b) Edite policy_statements (lista de declarações).

2) Comandos:
- terraform init -backend=false
- terraform validate
- terraform plan
- terraform apply

Variáveis principais
- aws_region (string, padrão us-east-1): região do provider AWS.
- policy_name (string, obrigatório): nome da IAM Managed Policy.
- policy_path (string, padrão /): deve começar e terminar com /.
- policy_description (string, padrão “Managed policy created by Terraform.”).
- tags (map(string), padrão {}).
- policy_json (string, opcional): JSON bruto da policy. Quando definido, tem precedência sobre policy_statements.
- policy_statements (list(any), com default mínimo): lista de statements para compor a policy quando policy_json não for usado.

Estrutura de policy_statements
- Cada item é um mapa com as chaves:
  - sid (opcional, string)
  - effect (string: Allow ou Deny)
  - actions (lista de strings, obrigatório)
  - resources (lista de strings, obrigatório)
  - conditions (lista opcional de objetos: { test, variable, values })

Saídas
- iam_policy_arn: ARN da policy criada.
- iam_policy_id: ID (normalmente o próprio ARN).
- iam_policy_name: nome.
- iam_policy_path: path.
- iam_policy_document_json: JSON efetivo da policy.

Notas
- Se policy_json for fornecido, ele deve ser um JSON válido (validado via jsondecode).
- Caso não forneça policy_json, ao menos um statement em policy_statements é necessário (verificado via precondition).
- Evite credenciais e valores sensíveis hardcoded; use variáveis de ambiente do provider AWS.
