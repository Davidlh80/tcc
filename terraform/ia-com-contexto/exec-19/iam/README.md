1. Visão geral do recurso
Este template provisiona uma AWS IAM Policy alinhada ao contexto organizacional. Ele:
- segue o padrão de nomenclatura <ambiente>-<sistema>-iam-<finalidade>;
- aplica as tags obrigatórias de governança;
- restringe Effect: Allow apenas às ações e recursos fornecidos via variáveis;
- proíbe a combinação Action "*" com Resource "*" na mesma statement;
- evita replicar permissões administrativas amplas (ex.: AdministratorAccess), pois não cria anexos nem permite "*" em Action com "*" em Resource.

2. Tabela de variáveis (nome, tipo, obrigatória, descrição)
- environment (string, sim): Ambiente alvo. Valores permitidos: dev, hml, prd.
- system (string, sim): Identificador do sistema (minúsculas, números e hífens).
- region (string, sim): Região AWS para o provider (ex.: us-east-1).
- policy_name (string, sim): Finalidade/nome da policy. Compoe o nome final conforme padrão.
- allowed_actions (list(string), sim): Ações permitidas (ex.: s3:GetObject, ec2:DescribeInstances). Pode conter "*", mas não com Resource "*".
- allowed_resources (list(string), sim): ARNs dos recursos permitidos. Pode conter "*", mas não com Action "*".
- description (string, não): Descrição da policy. Padrão: IAM policy for <system> managed by Terraform.
- additional_tags (map(string), não): Tags adicionais. As tags obrigatórias sempre prevalecem sobre valores conflitantes.

3. Tabela de outputs (nome, descrição)
- policy_name: Nome da IAM Policy criada.
- policy_arn: ARN da IAM Policy criada.
- policy_id: ID único da IAM Policy criada.

4. Exemplo de uso do módulo/recurso
module "iam_policy" {
  source         = "./"
  environment    = "dev"
  system         = "tcc"
  region         = "us-east-1"
  policy_name    = "readonly"
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

Saídas de exemplo:
- policy_name = module.iam_policy.policy_name
- policy_arn  = module.iam_policy.policy_arn
- policy_id   = module.iam_policy.policy_id
