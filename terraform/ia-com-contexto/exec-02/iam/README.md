1. Visao geral do recurso
Este template provisiona uma IAM Policy gerenciada no AWS IAM, seguindo os padroes organizacionais de nomenclatura, tags e seguranca. A policy:
- segue a padronizacao de nome: <environment>-<system>-iam-<policy_name>;
- aplica as tags obrigatorias da organizacao;
- restringe Effect: Allow apenas as acoes e recursos informados por variavel;
- proibe a combinacao Action: "*" com Resource: "*" na mesma statement;
- nao anexa nem replica policies administrativas (ex.: AdministratorAccess).

2. Tabela de variaveis
- environment (string) [Obrigatoria]: Ambiente alvo. Valores permitidos: dev, hml, prd.
- system (string) [Obrigatoria]: Identificador do sistema/produto. Permitidos [a-z0-9-].
- region (string) [Obrigatoria]: Regiao AWS (ex.: us-east-1).
- additional_tags (map(string)) [Opcional]: Tags adicionais a serem mescladas com as tags obrigatorias.
- policy_name (string) [Obrigatoria]: Finalidade/nome curto da policy (compora o padrao de nome).
- allowed_actions (list(string)) [Obrigatoria]: Lista das acoes IAM permitidas (principio do menor privilegio). Validacao impede Action="*" com Resource="*".
- allowed_resources (list(string)) [Obrigatoria]: Lista de ARNs de recursos permitidos.
- allowed_conditions (list(object({ test=string, variable=string, values=list(string) }))) [Opcional]: Condicoes adicionais aplicadas a statement Allow.
- description (string) [Opcional]: Descricao da policy. Padrao: Managed IAM policy with scoped permissions aligned to organizational standards.
- path (string) [Opcional]: Caminho da policy. Padrao: /.

3. Tabela de outputs
- policy_name: Nome final da IAM Policy criada.
- policy_arn: ARN da IAM Policy criada.
- policy_id: ID da IAM Policy criada.

4. Exemplo de uso do modulo/recurso
module "iam_policy_scoped" {
  source = "."

  region      = "us-east-1"
  environment = "dev"
  system      = "tcc"
  policy_name = "readonly"

  allowed_actions = [
    "s3:GetObject",
    "s3:ListBucket"
  ]

  allowed_resources = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  allowed_conditions = [
    {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  ]

  additional_tags = {
    Squad = "platform"
  }
}
