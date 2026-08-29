# Como Executar Validações Localmente

Dentro da pasta de cada template:

```bash
# Carregue as variaveis locais antes das validacoes.
# PowerShell:
Get-Content .env | Where-Object { $_ -and $_ -notmatch '^#' } | ForEach-Object { $name, $value = $_ -split '=', 2; Set-Item -Path "Env:$name" -Value $value }

terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

Use `.env.example` como referencia e mantenha credenciais reais somente no `.env` local.

As mesmas validações serão executadas pelo GitHub Actions. As análises de segurança utilizam Checkov e Trivy.
