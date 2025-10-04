# MOSIP DevOps Setup

Complete enterprise-grade DevOps setup for deploying MOSIP ID Authentication and Registration modules in Kubernetes.

## 🎯 Features

- **Infrastructure & Deployment**: Containerized MOSIP services on Kubernetes with Ingress
- **CI/CD Pipeline**: GitHub Actions with automated testing, security scanning, and deployment
- **Monitoring & Logging**: Prometheus metrics collection and Grafana dashboards
- **Security & Resilience**: Kubernetes Secrets, health checks, auto-recovery, rollback strategy
- **Database & Dependencies**: PostgreSQL and Redis with proper configuration

## 🚀 Quick Start

### Prerequisites
- Minikube
- kubectl
- Docker

### Local Deployment

1. **Clone and setup:**
   ```bash
   git clone <your-repo>
   cd mosip-devops-setup
   chmod +x scripts/setup.sh
   ./scripts/setup.sh