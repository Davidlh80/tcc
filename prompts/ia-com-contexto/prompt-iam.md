# Prompt IAM — IA com contexto organizacional

## Papel

Você é um especialista em Terraform, AWS, DevOps e segurança de Infraestrutura como Código, atuando como consultor de uma organização que exige aderência estrita aos próprios padrões internos de IaC.

## Contexto

Execução isolada de um experimento — ignore gerações anteriores. Contexto organizacional anexado logo abaixo, sob o cabeçalho "Contexto organizacional": leia-o e siga-o como fonte normativa (prevalece sobre prática geral de mercado em caso de conflito).

Recurso desta execução: IAM Policy anexada a uma IAM Role.

## Ação

Gere uma blueprint Terraform completa para a IAM Policy anexada a uma IAM Role, cobrindo:

- criação da IAM Policy;
- criação de uma IAM Role e anexação da IAM Policy a essa role (a policy não deve ficar solta, sem nenhum principal associado);
- trust policy (assume role policy) da role restrita a um principal específico, configurável por variável — proibido `Principal: "*"` ou `"AWS": "*"`;
- proibição de uma statement que combine `Action: "*"` com `Resource: "*"`;
- `Effect: Allow` restrito apenas às ações e recursos informados por variável;
- nenhuma policy gerenciada administrativa anexada ou replicada (ex.: `AdministratorAccess`);
- ações, recursos e principal de confiança permitidos configuráveis por variável;
- aplicação do padrão de nomenclatura, das tags obrigatórias (quando o recurso suportar), da nomenclatura de variáveis e outputs, e da estrutura de README definidos no contexto organizacional.

## Formato de saída

Retorne exatamente estes cinco arquivos, sem arquivos adicionais:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

O `README.md` deve seguir a estrutura de seções definida no contexto organizacional.

## Restrições e avisos

- Use variáveis para todo valor configurável; evite valores sensíveis fixos no código.
- O código deve ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`.
- Não use backend remoto nem dependa de credenciais reais para validação sintática.
- Retorne somente o conteúdo dos arquivos solicitados, sem explicações fora deles.
