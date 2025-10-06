# MOSIP DevOps Assessment - Enterprise Deployment

## 📋 Project Overview

This project demonstrates an enterprise-grade DevOps setup for deploying MOSIP (Modular Open Source Identity Platform) ID Authentication and Registration Client modules in a Kubernetes environment. The implementation focuses on cloud-native principles, security, monitoring, and automation.

## 🎯 Assessment Requirements Met

### ✅ Infrastructure & Deployment
- **Containerized Modules**: Deploys official MOSIP Docker images directly
- **Kubernetes Cluster**: Full Minikube-based local Kubernetes environment
- **API Gateway**: NGINX Ingress with path-based routing
- **High Availability**: Multi-replica deployments with rolling updates

### ✅ CI/CD Pipeline
- **GitHub Actions**: Automated testing, security scanning, and deployment
- **Automated Rollback**: Built-in rollback strategy for failed deployments
- **Quality Gates**: Validation, security scanning, and smoke testing
- **Zero-Downtime**: Rolling update strategy with health checks

### ✅ Monitoring & Logging
- **Prometheus**: Comprehensive metrics collection
- **Grafana**: Visualization dashboards and alerting
- **ELK Stack**: Centralized logging with Elasticsearch, Kibana, and Filebeat
- **Health Monitoring**: Application and infrastructure health tracking

### ✅ Security & Resilience
- **Kubernetes Secrets**: Secure credential management
- **Resource Limits**: CPU and memory constraints
- **Health Checks**: Liveness, readiness, and startup probes
- **Security Scanning**: Trivy and Checkov integration
- **Non-root Execution**: Enhanced security context

### ✅ Documentation & Delivery
- **Comprehensive README**: Complete setup and operational guide
- **Scripted Automation**: One-command setup and teardown
- **Operational Procedures**: Monitoring, troubleshooting, and maintenance

## 🏗️ Architecture
├── Applications
│ ├── ID Authentication Service (Official MOSIP Image)
│ └── Registration Client Service (Official MOSIP Image)
├── Kubernetes Infrastructure
│ ├── Deployments with health checks
│ ├── Services & Ingress routing
│ ├── Resource limits and security
│ └── Rolling update strategy
├── Monitoring Stack
│ ├── Prometheus (metrics collection)
│ └── Grafana (visualization)
├── Logging Stack
│ ├── Elasticsearch (log storage)
│ ├── Kibana (log visualization)
│ └── Filebeat (log shipping)
└── CI/CD Pipeline
├── GitHub Actions workflow
├── Automated testing
└── Rollback strategy


## 📁 Project Structure
mosip-devops-assessment/
├── .github/workflows/
│ └── ci-cd.yaml # CI/CD Pipeline
├── k8s/
│ ├── namespace.yaml # Kubernetes namespace
│ ├── ida/
│ │ ├── deployment.yaml # ID Authentication deployment
│ │ └── service.yaml # ID Authentication service
│ ├── regclient/
│ │ ├── deployment.yaml # Registration Client deployment
│ │ └── service.yaml # Registration Client service
│ ├── ingress.yaml # API Gateway configuration
│ ├── monitoring/
│ │ ├── prometheus.yaml # Prometheus deployment
│ │ └── grafana.yaml # Grafana deployment
│ └── logging/
│ ├── elasticsearch.yaml # Elasticsearch deployment
│ ├── kibana.yaml # Kibana deployment
│ └── filebeat.yaml # Filebeat daemonset
├── scripts/
│ ├── setup.sh # Complete environment setup
│ ├── smoke-tests.sh # Service validation tests
│ ├── test-resilience.sh # Failure recovery tests
│ └── rollback.sh # Automated rollback procedure
└── README.md # This file


## 🚀 Quick Start

### Prerequisites

- **Minikube** (v1.26.0 or later)
- **kubectl** (v1.26.0 or later)
- **Docker** (20.10 or later)

### Installation & Setup

1. **Clone the repository**:
   git clone <repository-url>
   cd mosip-devops-assessment

2. **Run the setup script**:
chmod +x scripts/setup.sh
./scripts/setup.sh

3. **Access the services**:
🌐 Access URLs:
   ID Authentication: http://<minikube-ip>/idauthentication
   Registration: http://<minikube-ip>/registration
   Prometheus: http://<minikube-ip>:30900
   Grafana: http://<minikube-ip>:30500
   Kibana: http://<minikube-ip>:30601
   

### Access Monitoring Tools

1. **Prometheus (Metrics)**:
minikube service prometheus-service -n mosip
Or directly: http://<minikube-ip>:30900

2. **Grafana (Dashboards)**:
minikube service grafana-service -n mosip
directly: http://<minikube-ip>:30500
Credentials: admin/admin

3. **Kibana (Logs)**:
minikube service kibana -n mosip
Or directly: http://<minikube-ip>:30601