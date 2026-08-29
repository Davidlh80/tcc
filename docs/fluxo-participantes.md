# Fluxo dos Participantes

## Estrutura de organização do experimento

O repositório usa a seguinte convenção para manter os 270 templates rastreáveis e auditáveis:

```text
terraform/
├── manual/
│   ├── p01/
│   │   ├── s3/
│   │   ├── iam/
│   │   └── security-group/
│   └── p30/
│       ├── s3/
│       ├── iam/
│       └── security-group/
├── ia-sem-contexto/
│   ├── exec-01/
│   │   ├── s3/
│   │   ├── iam/
│   │   └── security-group/
│   └── exec-30/
│       ├── s3/
│       ├── iam/
│       └── security-group/
└── ia-com-contexto/
    ├── exec-01/
    │   ├── s3/
    │   ├── iam/
    │   └── security-group/
    └── exec-30/
        ├── s3/
        ├── iam/
        └── security-group/
```

A contagem esperada é:

- manual: 30 participantes × 3 recursos = 90 templates
- ia-sem-contexto: 30 execuções × 3 recursos = 90 templates
- ia-com-contexto: 30 execuções × 3 recursos = 90 templates
- total: 270 templates

## Padrão de cada template

Cada pasta final deve conter sempre:

```text
main.tf
variables.tf
outputs.tf
versions.tf
README.md
metadata.yml
```

Exemplo:

```text
terraform/manual/p01/s3/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── README.md
└── metadata.yml
```

O arquivo `metadata.yml` registra informações relevantes da execução para consolidação posterior.

## Padrão de branch

### Participantes manuais

```text
manual/pXX
```

Exemplos: `manual/p01`, `manual/p02`, `manual/p30`.

Cada participante deve trabalhar somente dentro da sua pasta:

```text
terraform/manual/pXX/s3/
terraform/manual/pXX/iam/
terraform/manual/pXX/security-group/
```

### Execuções de IA

```text
ia-sem-contexto/exec-XX
ia-com-contexto/exec-XX
```

Exemplos: `ia-sem-contexto/exec-01`, `ia-com-contexto/exec-02`.

## Padrão de Pull Request

### Manual

```text
manual: adiciona templates do participante pXX
```

### IA sem contexto

```text
ia-sem-contexto: adiciona execucao XX
```

### IA com contexto

```text
ia-com-contexto: adiciona execucao XX
```

## Etapas do fluxo

1. Ler os requisitos gerais e específicos.
2. Criar a branch conforme o padrão do cenário.
3. Implementar os três templates do recurso em questão.
4. Registrar início, término, pausas e metadados no `metadata.yml`.
5. Abrir Pull Request seguindo o padrão de título.
6. Aguardar as validações automatizadas.

## Contribuição e permissões

Você pode usar uma destas duas opções:

### Opção 1 — colaboradores do repositório

- o participante clona o repositório;
- cria a branch `manual/pXX`;
- edita apenas a pasta `terraform/manual/pXX`;
- abre PR para `main`;
- o pipeline valida os templates.

### Opção 2 — fork + pull request

- o participante faz fork do repositório;
- cria a branch no fork;
- abre PR para o repositório original;
- o pipeline valida os templates.

Para este TCC, a opção mais prática costuma ser a de colaboradores quando o grupo for pequeno e próximo.

## Formulário de coleta

Registrar recurso, horários, pausas, dificuldade percebida, experiência prévia com Terraform/IaC e observações relevantes para a análise comparativa.
