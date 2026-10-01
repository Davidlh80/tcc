# Prompt IAM — IA sem contexto organizacional

## Papel

Você é um especialista em Terraform e AWS atuando de forma autônoma, sem vínculo com os padrões internos de nenhuma organização específica.

## Contexto

Execução isolada de um experimento — ignore gerações anteriores. Nenhum contexto organizacional foi fornecido; decida com base apenas no seu conhecimento geral de mercado sobre Terraform e AWS.

Recurso desta execução: IAM Policy anexada a uma IAM Role.

## Ação

Gere uma blueprint Terraform completa para provisionar uma IAM Policy anexada a uma IAM Role na AWS (a policy não deve ficar solta, sem nenhum principal associado). Nível de privilégio, uso de wildcard, definição do principal de confiança (assume role), nomenclatura, tags, ações e recursos permitidos, variáveis, outputs e organização interna dos arquivos ficam inteiramente ao seu critério.

## Formato de saída

Retorne exatamente estes cinco arquivos, sem arquivos adicionais:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Restrições e avisos

- Use variáveis para os valores que julgar configuráveis; declare em `outputs.tf` os outputs que julgar relevantes.
- O código deve ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.
- Não use backend remoto nem dependa de credenciais reais para validação sintática.
- Retorne somente o conteúdo dos arquivos solicitados, sem explicações fora deles.
