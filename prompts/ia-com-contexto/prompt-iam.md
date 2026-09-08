# Prompt IAM — IA com contexto organizacional

## Papel da execução

Sou um especialista em Terraform, AWS, DevOps, segurança e padronização corporativa. Devo gerar um template Terraform seguindo rigorosamente os requisitos técnicos deste prompt e o contexto organizacional fornecido separadamente.

Esta é uma execução independente do experimento. Ignore qualquer geração anterior e trate este prompt, junto com o contexto organizacional informado, como a única fonte de requisitos válida para esta execução — inclusive quando isso for mais restritivo do que a prática de mercado que você adotaria por padrão.

## Objetivo

Criar uma blueprint Terraform para provisionar uma IAM Policy em conformidade com a política interna de IaC da organização.

## Arquivos obrigatórios

A resposta deve permitir a criação dos seguintes arquivos:

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`
- `README.md`

## Requisitos obrigatórios

O template deve:

- criar uma IAM Policy;
- proibir uma statement que combine `Action: "*"` com `Resource: "*"`;
- restringir `Effect: Allow` apenas às ações e recursos informados por variável;
- não anexar nem replicar o efeito de policies gerenciadas administrativas (ex.: `AdministratorAccess`);
- permitir configuração das ações e dos recursos permitidos por variável;
- seguir exatamente o padrão de nomenclatura de recursos definido no contexto organizacional;
- aplicar as tags obrigatórias do contexto organizacional, quando o recurso suportar;
- nomear variáveis e outputs exatamente conforme a tabela de nomenclatura do contexto organizacional;
- estruturar o `README.md` conforme as seções definidas no contexto organizacional;
- utilizar variáveis para todo valor configurável;
- evitar valores sensíveis fixos no código;
- ser compatível com `terraform fmt`, `terraform init -backend=false` e `terraform validate`;
- evitar backend remoto;
- evitar dependência de credenciais reais para validação sintática.

## Diretriz de contexto

Trate o contexto organizacional como fonte normativa, não apenas estilística: nomenclatura, tags, estrutura de arquivos, seções do README, nomes de variáveis e outputs, e os controles de segurança específicos de IAM devem seguir exatamente o que está definido nele. Em caso de conflito entre uma prática geral de mercado e uma regra explícita do contexto organizacional, prevalece a regra do contexto organizacional.
