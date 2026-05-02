# EasyTravel Kubernetes Deployment

Complete Kubernetes deployment for EasyTravel application with multi-environment support using Helm, ArgoCD, and CI/CD pipelines.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Deployment Methods](#deployment-methods)
- [Environment Configuration](#environment-configuration)
- [CI/CD Pipeline Setup](#cicd-pipeline-setup)
- [Monitoring and Observability](#monitoring-and-observability)
- [Troubleshooting](#troubleshooting)

## Architecture Overview

### Components
- **MongoDB**: Database service
- **Backend**: Java-based backend service
- **Frontend**: Traditional web frontend
- **Angular Frontend**: Modern Angular-based frontend
- **Nginx**: Reverse proxy and load balancer
- **Load Generator**: Traffic simulation tool

### Multi-Environment Strategy
- **Dev Environment**: `easytravel-dev` namespace
- **Staging Environment**: `easytravel-staging` namespace
- **Production Environment**: `easytravel-prod` namespace

All environments run on the same Azure Kubernetes cluster but are isolated using Kubernetes namespaces.

## Prerequisites

### Required Tools
```bash
# Kubectl
curl -LO "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# ArgoCD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
```

### Azure Kubernetes Cluster Setup

#### 1. Create Resource Group
```bash
az group create --name easytravel-rg --location eastus
```

#### 2. Create AKS Cluster
```bash
az aks create \
  --resource-group easytravel-rg \
  --name easytravel-aks \
  --node-count 3 \
  --node-vm-size Standard_D4s_v3 \
  --enable-managed-identity \
  --generate-ssh-keys \
  --kubernetes-version 1.28.0 \
  --network-plugin azure \
  --enable-addons monitoring
```

#### 3. Get AKS Credentials
```bash
az aks get-credentials \
  --resource-group easytravel-rg \
  --name easytravel-aks
```

#### 4. Verify Cluster Connection
```bash
kubectl cluster-info
kubectl get nodes
```

## Project Structure

```
easytravel-k8s/
├── helm-charts/
│   └── easytravel/
│       ├── Chart.yaml
│       ├── values.yaml              # Default values
│       ├── values-dev.yaml          # Dev environment overrides
│       ├── values-staging.yaml      # Staging environment overrides
│       ├── values-prod.yaml         # Production environment overrides
│       └── templates/
│           ├── namespace.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── mongodb.yaml
│           ├── backend.yaml
│           ├── frontend.yaml
│           ├── angular-frontend.yaml
│           ├── nginx.yaml
│           ├── loadgen.yaml
│           └── ingress.yaml
├── argocd/
│   ├── application-dev.yaml
│   ├── application-staging.yaml
│   └── application-prod.yaml
├── github-actions/
│   └── .github/
│       └── workflows/
│           └── ci-cd-pipeline.yml
└── docs/
    ├── README.md
    ├── DEPLOYMENT.md
    └── TROUBLESHOOTING.md
```

## Quick Start

### Option 1: Deploy with Helm (Direct)

#### Deploy to Dev Environment
```bash
# Navigate to project root
cd easytravel-k8s

# Deploy Dev environment
helm upgrade --install easytravel-dev ./helm-charts/easytravel \
  --namespace easytravel-dev \
  --create-namespace \
  --values helm-charts/easytravel/values.yaml \
  --values helm-charts/easytravel/values-dev.yaml \
  --wait

# Verify deployment
kubectl get pods -n easytravel-dev
kubectl get svc -n easytravel-dev
```

#### Access the Application
```bash
# Get LoadBalancer IP (if using LoadBalancer service type)
kubectl get svc nginx-service -n easytravel-dev

# Port forward for local testing
kubectl port-forward svc/nginx-service 8080:80 -n easytravel-dev

# Access in browser
# http://localhost:8080  - Classic Frontend
# http://localhost:9079  - Angular Frontend
```

### Option 2: Deploy with ArgoCD (GitOps)

See [ArgoCD Setup Guide](#argocd-setup) below.

## Deployment Methods

### Method 1: Helm Direct Deployment

#### Deploy Dev Environment
```bash
helm upgrade --install easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-dev.yaml \
  -n easytravel-dev \
  --create-namespace \
  --wait
```

#### Deploy Staging Environment
```bash
helm upgrade --install easytravel-staging ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-staging.yaml \
  -n easytravel-staging \
  --create-namespace \
  --wait
```

#### Deploy Production Environment
```bash
helm upgrade --install easytravel-prod ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-prod.yaml \
  -n easytravel-prod \
  --create-namespace \
  --wait
```

### Method 2: ArgoCD GitOps Deployment

#### Install ArgoCD
```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd

# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward to access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access ArgoCD UI at: https://localhost:8080
# Username: admin
# Password: (from above command)
```

#### Deploy Applications with ArgoCD

1. **Update Git Repository URLs**
   
   Edit the ArgoCD application files and replace `YOUR_ORG` with your GitHub organization:
   ```bash
   # In argocd/application-dev.yaml
   # In argocd/application-staging.yaml
   # In argocd/application-prod.yaml
   
   # Change:
   repoURL: https://github.com/YOUR_ORG/easytravel-k8s.git
   # To:
   repoURL: https://github.com/your-actual-org/easytravel-k8s.git
   ```

2. **Apply ArgoCD Applications**
   ```bash
   # Deploy Dev environment
   kubectl apply -f argocd/application-dev.yaml
   
   # Deploy Staging environment
   kubectl apply -f argocd/application-staging.yaml
   
   # Deploy Production environment (manual sync)
   kubectl apply -f argocd/application-prod.yaml
   ```

3. **Sync Applications via CLI**
   ```bash
   # Login to ArgoCD
   argocd login localhost:8080 --username admin --password <password> --insecure
   
   # Sync Dev application
   argocd app sync easytravel-dev
   
   # Sync Staging application
   argocd app sync easytravel-staging
   
   # Sync Production (manual approval required)
   argocd app sync easytravel-prod
   ```

4. **Monitor Application Status**
   ```bash
   # List all applications
   argocd app list
   
   # Get application details
   argocd app get easytravel-dev
   
   # Watch sync status
   argocd app wait easytravel-dev --health
   ```

## Environment Configuration

### Dev Environment (`values-dev.yaml`)
- **Purpose**: Development and testing
- **Replicas**: 1 per service
- **Resources**: Minimal (256Mi-512Mi RAM)
- **Autoscaling**: Disabled
- **LoadGen**: Enabled
- **Ingress**: `easytravel-dev.yourdomain.com`

### Staging Environment (`values-staging.yaml`)
- **Purpose**: Pre-production validation
- **Replicas**: 2 per service
- **Resources**: Medium (512Mi-1Gi RAM)
- **Autoscaling**: Enabled (2-4 replicas)
- **LoadGen**: Enabled
- **Ingress**: `easytravel-staging.yourdomain.com`

### Production Environment (`values-prod.yaml`)
- **Purpose**: Live production traffic
- **Replicas**: 3 per service
- **Resources**: High (1Gi-2Gi RAM)
- **Autoscaling**: Enabled (3-10 replicas)
- **LoadGen**: Disabled
- **Ingress**: `easytravel.yourdomain.com`

## CI/CD Pipeline Setup

### GitHub Actions Setup

#### 1. Create GitHub Repository
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit: EasyTravel Kubernetes deployment"

# Add remote and push
git remote add origin https://github.com/YOUR_ORG/easytravel-k8s.git
git branch -M main
git push -u origin main
```

#### 2. Configure GitHub Secrets

Go to your repository → Settings → Secrets and variables → Actions

Add the following secrets:

**AZURE_CREDENTIALS**
```bash
# Create Azure Service Principal
az ad sp create-for-rbac \
  --name "easytravel-github-actions" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/easytravel-rg \
  --sdk-auth

# Copy the entire JSON output and save as AZURE_CREDENTIALS secret
```

**AZURE_RESOURCE_GROUP**
```
easytravel-rg
```

**AZURE_CLUSTER_NAME**
```
easytravel-aks
```

#### 3. Pipeline Workflow

The GitHub Actions pipeline automatically:
1. **Lints** Helm charts on every push
2. **Validates** Kubernetes manifests
3. **Scans** for security vulnerabilities
4. **Deploys to Dev** on push to `develop` or `main` branch
5. **Deploys to Staging** on push to `main` branch
6. **Deploys to Production** on push to `main` (requires manual approval)

### Opsera Integration

#### 1. Install Opsera Pipeline

```yaml
# Coming soon - Opsera pipeline configuration
# This section will be populated once Opsera pipeline is configured
```

## Verification and Testing

### Check Deployment Status
```bash
# Check all pods in dev namespace
kubectl get pods -n easytravel-dev

# Check services
kubectl get svc -n easytravel-dev

# Check ingress
kubectl get ingress -n easytravel-dev

# Describe a specific pod
kubectl describe pod <pod-name> -n easytravel-dev

# View logs
kubectl logs -f deployment/backend -n easytravel-dev
```

### Test Application Access

#### Using Port Forward
```bash
# Forward Nginx service
kubectl port-forward svc/nginx-service 8080:80 -n easytravel-dev

# Access applications:
# Classic Frontend: http://localhost:8080
# Angular Frontend: http://localhost:9079
# Backend API: http://localhost:8080/api
```

#### Using LoadBalancer (if configured)
```bash
# Get external IP
EXTERNAL_IP=$(kubectl get svc nginx-service -n easytravel-dev -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Classic Frontend: http://$EXTERNAL_IP"
echo "Angular Frontend: http://$EXTERNAL_IP:9079"
```

### Health Checks
```bash
# Check backend health
kubectl exec -it deployment/backend -n easytravel-dev -- curl localhost:8080/health

# Check MongoDB connection
kubectl exec -it deployment/mongodb -n easytravel-dev -- mongo --eval "db.adminCommand('ping')"
```

## Monitoring and Observability

### View Logs
```bash
# Stream logs from backend
kubectl logs -f deployment/backend -n easytravel-dev

# Get logs from all pods with label
kubectl logs -l app=backend -n easytravel-dev --all-containers=true

# View previous logs (after crash)
kubectl logs deployment/backend -n easytravel-dev --previous
```

### Resource Usage
```bash
# Top nodes
kubectl top nodes

# Top pods
kubectl top pods -n easytravel-dev

# Describe resource usage
kubectl describe nodes
```

### Prometheus & Grafana (Optional)

If you have Prometheus Operator installed:
```bash
# Enable ServiceMonitor in values
# Set serviceMonitor.enabled: true in values-dev.yaml

# Verify ServiceMonitor
kubectl get servicemonitor -n easytravel-dev
```

## Scaling

### Manual Scaling
```bash
# Scale backend deployment
kubectl scale deployment backend --replicas=3 -n easytravel-dev

# Scale all deployments
kubectl scale deployment --all --replicas=2 -n easytravel-dev
```

### Autoscaling
Autoscaling is configured via Helm values:
```yaml
backend:
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 10
    targetCPUUtilizationPercentage: 70
```

Check HPA status:
```bash
kubectl get hpa -n easytravel-dev
kubectl describe hpa backend-hpa -n easytravel-dev
```

## Updating Deployments

### Update Configuration
```bash
# Edit values file
vim helm-charts/easytravel/values-dev.yaml

# Upgrade release
helm upgrade easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-dev.yaml \
  -n easytravel-dev

# With ArgoCD (if using GitOps)
git add helm-charts/easytravel/values-dev.yaml
git commit -m "Update dev configuration"
git push origin main
# ArgoCD will auto-sync if enabled
```

### Rollback
```bash
# View release history
helm history easytravel-dev -n easytravel-dev

# Rollback to previous version
helm rollback easytravel-dev -n easytravel-dev

# Rollback to specific revision
helm rollback easytravel-dev 3 -n easytravel-dev
```

## Cleanup

### Delete Single Environment
```bash
# Using Helm
helm uninstall easytravel-dev -n easytravel-dev
kubectl delete namespace easytravel-dev

# Using ArgoCD
argocd app delete easytravel-dev
```

### Delete All Environments
```bash
# Delete all environments
helm uninstall easytravel-dev -n easytravel-dev
helm uninstall easytravel-staging -n easytravel-staging
helm uninstall easytravel-prod -n easytravel-prod

# Delete namespaces
kubectl delete namespace easytravel-dev easytravel-staging easytravel-prod
```

### Delete AKS Cluster
```bash
az aks delete \
  --resource-group easytravel-rg \
  --name easytravel-aks \
  --yes --no-wait

az group delete --name easytravel-rg --yes --no-wait
```

## Troubleshooting

### Common Issues

#### Pods Not Starting
```bash
# Check pod status
kubectl get pods -n easytravel-dev

# Describe pod to see events
kubectl describe pod <pod-name> -n easytravel-dev

# Check logs
kubectl logs <pod-name> -n easytravel-dev
```

#### Image Pull Errors
```bash
# If using private registry, create image pull secret
kubectl create secret docker-registry regcred \
  --docker-server=<your-registry-server> \
  --docker-username=<your-name> \
  --docker-password=<your-pword> \
  -n easytravel-dev

# Add to values.yaml
global:
  imagePullSecrets:
    - name: regcred
```

#### Service Not Accessible
```bash
# Check service
kubectl get svc -n easytravel-dev

# Check endpoints
kubectl get endpoints -n easytravel-dev

# Test from within cluster
kubectl run -it --rm debug --image=alpine --restart=Never -n easytravel-dev -- sh
# Inside pod:
wget -qO- http://backend-service:8080
```

#### MongoDB Connection Issues
```bash
# Check MongoDB pod
kubectl get pod -l app=mongodb -n easytravel-dev

# Test MongoDB connection
kubectl exec -it deployment/mongodb -n easytravel-dev -- mongo

# Check backend logs for connection errors
kubectl logs deployment/backend -n easytravel-dev | grep -i mongo
```

## Best Practices

1. **Always use namespace isolation** for different environments
2. **Version control** all Helm values files
3. **Use Secrets** for sensitive data (not ConfigMaps)
4. **Enable resource limits** to prevent resource starvation
5. **Implement health checks** (liveness and readiness probes)
6. **Use GitOps** (ArgoCD) for production deployments
7. **Enable RBAC** and follow principle of least privilege
8. **Monitor** resource usage and application metrics
9. **Backup** persistent volumes regularly
10. **Test** in lower environments before production deployment

## Support

For issues and questions:
- Check the [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- Review Kubernetes events: `kubectl get events -n easytravel-dev`
- Check pod logs: `kubectl logs -f <pod-name> -n easytravel-dev`

## License

This project uses the EasyTravel application from Dynatrace for demonstration purposes.
