Visão geral do recurso
- Este template cria uma AWS IAM Policy com nome padronizado <ambiente>-<sistema>-iam-<policy_name>, aplicando tags obrigatórias e seguindo o princípio do menor privilégio.
- A policy contém apenas um bloco Effect: Allow com as ações e recursos explicitamente informados por variável.
- Controle de segurança: é proibido combinar Action "*" com Resource "*" na mesma statement. A validação das variáveis impede essa configuração.
- O template não anexa a policy a entidades IAM e não replica efeitos de policies administrativas gerenciadas (ex.: AdministratorAccess).

Tabela de variáveis
- environment (string, obrigatório): Ambiente alvo. Valores permitidos: dev, hml, prd.
- system (string, obrigatório): Identificador do sistema/produto (minúsculo, números e hífen), usado na composição do nome.
- region (string, obrigatório): Região AWS (ex.: us-east-1) usada pelo provider.
- policy_name (string, obrigatório): Finalidade/nome lógico da policy, parte final do padrão de nomenclatura.
- allowed_actions (set(string), obrigatório): Lista de ações explícitas permitidas (ex.: s3:GetObject, s3:ListBucket, ec2:*). Regra: não pode ser "*" ao mesmo tempo que allowed_resources contenha "*".
- allowed_resources (set(string), obrigatório): Lista de recursos explícitos (ARNs). Pode usar "*" desde que allowed_actions não seja "*".
- description (string, opcional): Descrição da IAM Policy. Padrão: texto informativo gerado pelo template.
- additional_tags (map(string), opcional): Tags adicionais para complementar as obrigatórias.

Tabela de outputs
- policy_name: Nome final da IAM Policy criada.
- policy_arn: ARN da IAM Policy criada.
- policy_id: ID interno da IAM Policy criada.

Exemplo de uso
module "iam_policy_readonly" {
  source = "./"

  region       = "us-east-1"
  environment  = "dev"
  system       = "tcc"
  policy_name  = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  additional_tags = {
    Team = "platform"
  }
}
