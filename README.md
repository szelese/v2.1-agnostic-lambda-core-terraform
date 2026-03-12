# v2.1 – Terraform IaC for Agnostic Lambda Core

[![Status: Fully Automated IaC](https://img.shields.io/badge/Status-Fully%20Automated%20IaC-green?style=flat-square)](https://github.com/szelese/v2.1-agnostic-lambda-core-terraform/actions/)
[![Latency: 44ms preserved](https://img.shields.io/badge/Latency-44ms%20preserved-blue?style=flat-square)](https://szelese.github.io/v2-agnostic-lambda-core/docs/v2_performance_report.html)  
[![Security: OWASP ZAP 0-Alert](https://img.shields.io/badge/Security-0--Alert-brightgreen?style=flat-square)](https://github.com/szelese/v2-agnostic-lambda-core/blob/main/docs/v2-tests.pdf)
[![Deployment: Zero Manual Steps](https://img.shields.io/badge/Deployment-Zero%20Manual%20Steps-success?style=flat-square)](./.github/workflows/deploy.yml)

**From manual deployment → full Infrastructure as Code (IaC) evolution**

This repository contains the **Terraform-based infrastructure layer** for the **v2-agnostic-lambda-core** project.  
After the technical validation of the original v1 project — selected by the Hungarian National Innovation Agency (NIÜ) — the architecture evolved into the serverless v2 implementation, achieving a 63% latency improvement and a 44 ms median response time. This version delivers a **fully automated, duplication-free** CI/CD pipeline with Terraform managing all AWS resources declaratively.

---

## 🏛️ Architectural Evolution – v2 → v2.1

| Aspect | v2 | v2.1 | Improvement |
|---|---|---|---|
| **Infrastructure** | manual AWS setup | Terraform IaC | reproducible |
| **Deployment** | partial automation | fully automated | zero manual |
| **Versioning** | implicit | git-managed | traceability |

---

## ⚡ Technical Highlights – v2.1

### 1. Zero-Duplication Architecture
- The **core business logic** (`core.py`) and the entire application code live exclusively in the original repository:  
  https://github.com/szelese/v2-agnostic-lambda-core
- This infra repo contains **only Terraform files and the workflow** → no src/, tests/, Dockerfile duplication.

### 2. Fully Automated CI/CD Pipeline
![AWS Infrastructure Architecture](https://github.com/szelese/v2-agnostic-lambda-core/raw/main/docs/v2-architecture.drawio.png)

- Push to main → GitHub Actions trigger
- Checkout original app repo (`szelese/v2-agnostic-lambda-core`)
- Quality gate (flake8, bandit, pytest) runs only on app code
- Docker build & push to ECR
- Lambda function code update + VERSION env var refresh
- Smart smoke test (version check within 40 seconds)

### 3. Infrastructure as Code – Key Resources
- ECR repository + lifecycle policy
- Lambda function (container image)
- Lambda Function URL (public (no auth), public invoke permission)
- IAM roles (least-privilege + GitHub OIDC)
- CloudWatch alarm (Errors ≥ 1 → SNS)
- SNS topic + email subscription
- GitHub Secrets auto-update (LAMBDA_URL, SNS_TOPIC_ARN)

### 4. 🔐 Infrastructure → GitHub Secrets Sync

Terraform automatically writes the deployed `LAMBDA_URL` and `SNS_TOPIC_ARN`  
back to GitHub Secrets via the [GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs),  
completing the zero-manual-step loop. This ensures the deployed infrastructure automatically feeds runtime configuration back into the CI/CD pipeline.

> **Local run requirement:** Provide GitHub App credentials (`github_app_id`, `github_app_installation_id`, `github_app_pem_file_path`) via a local `terraform.tfvars` file before running `terraform apply`.

### 5. Performance & Security Preservation
- **Median latency**: 44 ms (unchanged from v2)
- **Security**: OWASP ZAP 0-alert, hardened response headers preserved
- **Observability**: automated error alerts via email

---

## 📖 Documentation & Reproduction

- **[Original v2 documentation](https://szelese.github.io/v2-agnostic-lambda-core/)** – full performance & security validation

Performance test reports from the original v2 implementation:

- **[Locust report – 150 users](https://szelese.github.io/v2-agnostic-lambda-core/docs/v2_performance_report_150.html)**
- **[Locust report – 1000 users](https://szelese.github.io/v2-agnostic-lambda-core/docs/v2_performance_report.html)**

- Terraform apply command: `terraform init && terraform plan && terraform apply`
- GitHub Actions workflow: `.github/workflows/deploy.yml`

---

## 🚀 Future Roadmap: v3

- Multi-environment infrastructure (dev / staging / prod)
- Progressive delivery (Blue-Green or Canary deployments)
- Custom domain with ACM + Route53
- Security hardening and automated vulnerability scanning
- DORA metrics automation (Deployment Frequency, MTTR)
- Multi-cloud deployment abstraction (AWS / GCP / Azure)

---

## 🛠️ Prerequisites
- Terraform >= 1.5
- AWS credentials configured
- AWS OIDC setup (check my v1 project: [Original v1 documentation](https://szelese.github.io/ci-cd-gha-aws/))
- GitHub App configured with secret modification permissions (requires `.pem` private key)

---

## ✍️ Author & Legal
**Ervin Wallin** © 2026.  
This repository is the **infrastructure extension** of v2-agnostic-lambda-core.  
This project is provided for educational and portfolio purposes.
