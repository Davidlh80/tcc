Visão geral
- Este template Terraform cria uma IAM Policy gerenciada pelo cliente (customer managed) na AWS, com configurações seguras por padrão.
- A policy padrão permite apenas a ação sts:GetCallerIdentity no recurso "*", garantindo privilégio mínimo inicial.

Como usar
1) Ajuste as variáveis necessárias em variables.tf ou via -var/-var-file.
2) Inicialize o diretório:
   terraform init -backend=false
3) Visualize o plano:
   terraform plan
4) Aplique:
   terraform apply
5) Para destruir (se necessário), primeiro defina prevent_destroy=false:
   terraform apply -var="prevent_destroy=false"
   terraform destroy

Variáveis principais
- region (string): Região AWS. Padrão: us-east-1
- enabled (bool): Controla a criação do recurso. Padrão: true
- policy_name (string): Nome da policy. Padrão: tf-managed-iam-policy
- policy_description (string): Descrição da policy.
- policy_path (string): Caminho da policy (inicia e termina com /). Padrão: /
- policy_effect (string): Allow ou Deny. Padrão: Allow
- policy_actions (list(string)): Ações da declaração. Padrão: ["sts:GetCallerIdentity"]
- policy_resources (list(string)): Recursos da declaração. Padrão: ["*"]
- tags (map(string)): Tags adicionais.
- prevent_destroy (bool): Evita destruição acidental. Padrão: true

Outputs
- policy_arn: ARN da policy criada.
- policy_name: Nome da policy criada.
- policy_id: ID interno da policy.
- policy_document_json: Documento JSON efetivo da policy.

Boas práticas
- Ajuste policy_actions e policy_resources para refletir o menor privilégio necessário.
- Mantenha prevent_destroy=true em ambientes produtivos e altere apenas quando for destruir conscientemente.
- Utilize tags para facilitar o rastreamento e governança.

Notas
- Não há backend remoto configurado neste template.
- A validação sintática não requer credenciais reais.
