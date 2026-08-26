# Como Executar Validações Localmente

Dentro da pasta de cada template:

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

As mesmas validações serão executadas pelo GitHub Actions. As análises de segurança utilizam Checkov e Trivy.
