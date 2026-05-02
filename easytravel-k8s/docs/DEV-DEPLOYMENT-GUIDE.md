# Step-by-Step Guide: Deploy EasyTravel to Dev Environment

This guide walks you through deploying EasyTravel to the Dev environment on your Azure Kubernetes cluster.

## Prerequisites Checklist

- [ ] Azure CLI installed
- [ ] kubectl installed
- [ ] Helm 3 installed
- [ ] Git installed
- [ ] Access to Azure subscription
- [ ] GitHub account (for CI/CD)

## Phase 1: Azure Kubernetes Cluster Setup

### Step 1: Login to Azure
```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account list --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### Step 2: Create Resource Group
```bash
# Create resource group in East US region
az group create \
  --name easytravel-rg \
  --location eastus

# Verify creation
az group show --name easytravel-rg
```

### Step 3: Create AKS Cluster
```bash
# This will take 5-10 minutes
az aks create \
  --resource-group easytravel-rg \
  --name easytravel-aks \
  --node-count 3 \
  --node-vm-size Standard_D4s_v3 \
  --enable-managed-identity \
  --generate-ssh-keys \
  --kubernetes-version 1.28.0 \
  --network-plugin azure \
  --enable-addons monitoring \
  --zones 1 2 3

# Expected output: JSON with cluster details
```

### Step 4: Connect to AKS Cluster
```bash
# Get credentials
az aks get-credentials \
  --resource-group easytravel-rg \
  --name easytravel-aks \
  --overwrite-existing

# Verify connection
kubectl cluster-info
kubectl get nodes

# You should see 3 nodes in Ready state
```

### Step 5: Verify Cluster Setup
```bash
# Check node status
kubectl get nodes -o wide

# Check system pods
kubectl get pods -n kube-system

# Check available storage classes
kubectl get storageclass

# All system pods should be Running
```

## Phase 2: Prepare Your Local Environment

### Step 1: Clone/Create Project Structure
```bash
# Create project directory
mkdir -p ~/easytravel-k8s
cd ~/easytravel-k8s

# If you have the files, copy the helm-charts directory here
# Otherwise, you'll need to create the structure as provided
```

### Step 2: Verify Helm Chart Structure
```bash
# Navigate to project root
cd ~/easytravel-k8s

# Verify structure
ls -la helm-charts/easytravel/

# You should see:
# - Chart.yaml
# - values.yaml
# - values-dev.yaml
# - values-staging.yaml
# - values-prod.yaml
# - templates/ directory
```

### Step 3: Customize Configuration (Optional)
```bash
# Edit dev values file
nano helm-charts/easytravel/values-dev.yaml

# Key settings to review:
# - namespace: easytravel-dev
# - ingress.hosts (update domain if needed)
# - resource limits (adjust based on cluster capacity)
```

## Phase 3: Deploy to Dev Environment using Helm

### Step 1: Validate Helm Chart
```bash
# Lint the chart
helm lint helm-charts/easytravel

# Expected output: "1 chart(s) linted, 0 chart(s) failed"

# Dry-run to see what will be created
helm install easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-dev.yaml \
  -n easytravel-dev \
  --create-namespace \
  --dry-run \
  --debug

# Review the output - no errors should appear
```

### Step 2: Deploy to Dev Namespace
```bash
# Deploy the application
helm upgrade --install easytravel-dev ./helm-charts/easytravel \
  --namespace easytravel-dev \
  --create-namespace \
  --values helm-charts/easytravel/values.yaml \
  --values helm-charts/easytravel/values-dev.yaml \
  --wait \
  --timeout 10m

# Expected output:
# NAME: easytravel-dev
# LAST DEPLOYED: [timestamp]
# NAMESPACE: easytravel-dev
# STATUS: deployed
# REVISION: 1
```

### Step 3: Monitor Deployment Progress
```bash
# Watch pods being created
kubectl get pods -n easytravel-dev --watch

# In another terminal, check deployment status
kubectl get deployments -n easytravel-dev

# Check services
kubectl get svc -n easytravel-dev

# Wait until all pods show "Running" and "1/1" or "2/2" ready
# This may take 3-5 minutes for all images to download
```

### Step 4: Verify All Components
```bash
# Check all resources in dev namespace
kubectl get all -n easytravel-dev

# You should see:
# - 1 mongodb pod
# - 1 backend pod
# - 1 frontend pod
# - 1 angular-frontend pod
# - 1 nginx pod
# - 1 loadgen pod
# - Corresponding services
```

## Phase 4: Verification and Testing

### Step 1: Check Pod Health
```bash
# Detailed pod status
kubectl get pods -n easytravel-dev -o wide

# Check pod events
kubectl get events -n easytravel-dev --sort-by='.lastTimestamp'

# If any pod is not running, describe it
kubectl describe pod <pod-name> -n easytravel-dev
```

### Step 2: View Application Logs
```bash
# MongoDB logs
kubectl logs deployment/mongodb -n easytravel-dev

# Backend logs
kubectl logs deployment/backend -n easytravel-dev --tail=50

# Frontend logs
kubectl logs deployment/frontend -n easytravel-dev --tail=50

# Nginx logs
kubectl logs deployment/nginx -n easytravel-dev --tail=50

# No errors related to connectivity should appear
```

### Step 3: Test Internal Connectivity
```bash
# Run a test pod
kubectl run test-pod --image=alpine --rm -it -n easytravel-dev -- sh

# Inside the test pod, run:
apk add curl
curl http://backend-service:8080
curl http://frontend-service:8080
curl http://nginx-service:80

# All should return HTML responses
# Type 'exit' to leave the pod
```

### Step 4: Access Application from Local Machine

#### Option A: Using Port Forward (Recommended for Dev)
```bash
# Forward nginx service to local port 8080
kubectl port-forward svc/nginx-service 8080:80 8081:9079 8082:8080 -n easytravel-dev

# Keep this terminal open
# Open browser and navigate to:
# - http://localhost:8080  (Classic Frontend)
# - http://localhost:8081  (Angular Frontend)
# - http://localhost:8082  (Backend API)
```

#### Option B: Using LoadBalancer Service (If configured)
```bash
# Get external IP (may take a few minutes to provision)
kubectl get svc nginx-service -n easytravel-dev

# Wait for EXTERNAL-IP to appear (not <pending>)
# Once available, access via:
EXTERNAL_IP=$(kubectl get svc nginx-service -n easytravel-dev -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Access application at: http://$EXTERNAL_IP"
```

### Step 5: Functional Testing
```bash
# Access the application in browser
# Classic Frontend: http://localhost:8080

# Test the following functionality:
# 1. Browse for destinations
# 2. Search for journeys
# 3. Book a trip
# 4. View booking confirmation

# If load generator is enabled, you should see automated traffic
```

## Phase 5: Post-Deployment Configuration

### Step 1: Verify ConfigMaps and Secrets
```bash
# View ConfigMap
kubectl get configmap easytravel-config -n easytravel-dev -o yaml

# View Secret (base64 encoded)
kubectl get secret easytravel-secrets -n easytravel-dev -o yaml

# Decode secret values (for verification only)
kubectl get secret easytravel-secrets -n easytravel-dev -o jsonpath='{.data.MONGODB_USER}' | base64 -d
```

### Step 2: Check Resource Usage
```bash
# View resource consumption
kubectl top pods -n easytravel-dev
kubectl top nodes

# Verify pods are within resource limits
kubectl describe pod <backend-pod> -n easytravel-dev | grep -A 5 "Limits"
```

### Step 3: Set Up Monitoring (Optional)
```bash
# If you have Prometheus Operator installed
# Enable ServiceMonitor in values-dev.yaml
# Set serviceMonitor.enabled: true

# Upgrade release
helm upgrade easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-dev.yaml \
  -n easytravel-dev

# Verify ServiceMonitor
kubectl get servicemonitor -n easytravel-dev
```

## Phase 6: Setup ArgoCD (Optional - GitOps)

### Step 1: Install ArgoCD
```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for all pods to be ready (2-3 minutes)
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd
```

### Step 2: Access ArgoCD UI
```bash
# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

# Port forward ArgoCD server
kubectl port-forward svc/argocd-server -n argocd 8443:443

# Access ArgoCD UI: https://localhost:8443
# Username: admin
# Password: (from above command)
# Accept self-signed certificate in browser
```

### Step 3: Push to GitHub
```bash
# Initialize git repository
cd ~/easytravel-k8s
git init
git add .
git commit -m "Initial commit: EasyTravel Kubernetes deployment"

# Create GitHub repository (via web UI or CLI)
# Then add remote
git remote add origin https://github.com/YOUR_USERNAME/easytravel-k8s.git
git branch -M main
git push -u origin main
```

### Step 4: Create ArgoCD Application
```bash
# Update argocd/application-dev.yaml with your GitHub repo URL
nano argocd/application-dev.yaml
# Change: repoURL: https://github.com/YOUR_USERNAME/easytravel-k8s.git

# Apply ArgoCD application
kubectl apply -f argocd/application-dev.yaml

# Sync the application
argocd app sync easytravel-dev

# Watch sync progress
kubectl get application easytravel-dev -n argocd --watch
```

## Phase 7: Setup GitHub Actions CI/CD

### Step 1: Create Service Principal
```bash
# Get subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Create service principal
az ad sp create-for-rbac \
  --name "easytravel-github-actions" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/easytravel-rg \
  --sdk-auth

# Copy the entire JSON output
# Save it as AZURE_CREDENTIALS secret in GitHub
```

### Step 2: Configure GitHub Secrets
```
Go to: GitHub Repository → Settings → Secrets and variables → Actions

Create the following secrets:
1. AZURE_CREDENTIALS: <JSON from step 1>
2. AZURE_RESOURCE_GROUP: easytravel-rg
3. AZURE_CLUSTER_NAME: easytravel-aks
```

### Step 3: Copy GitHub Actions Workflow
```bash
# Copy workflow file to correct location
mkdir -p .github/workflows
cp github-actions/.github/workflows/ci-cd-pipeline.yml .github/workflows/

# Commit and push
git add .github/
git commit -m "Add GitHub Actions CI/CD pipeline"
git push origin main

# Check workflow execution in GitHub Actions tab
```

## Troubleshooting Common Issues

### Issue 1: Pods Stuck in Pending
```bash
# Check node resources
kubectl describe nodes | grep -A 5 "Allocated resources"

# Check pod events
kubectl describe pod <pod-name> -n easytravel-dev

# Common causes:
# - Insufficient node resources
# - Storage class not available
# - Image pull errors
```

### Issue 2: Image Pull Errors
```bash
# Check image pull status
kubectl describe pod <pod-name> -n easytravel-dev | grep -A 10 "Events"

# Solution: Ensure images are publicly accessible
# Or create image pull secret for private registry
```

### Issue 3: MongoDB Connection Failures
```bash
# Check MongoDB pod
kubectl get pod -l app=mongodb -n easytravel-dev

# Check MongoDB logs
kubectl logs deployment/mongodb -n easytravel-dev

# Verify MongoDB service
kubectl get svc mongodb-service -n easytravel-dev

# Test connection from backend pod
kubectl exec -it deployment/backend -n easytravel-dev -- \
  curl http://mongodb-service:27017
```

### Issue 4: Application Not Accessible
```bash
# Check nginx service
kubectl get svc nginx-service -n easytravel-dev

# Check nginx pod logs
kubectl logs deployment/nginx -n easytravel-dev

# Verify port-forward is running
ps aux | grep port-forward

# Try accessing from within cluster
kubectl run test --image=curlimages/curl --rm -it -n easytravel-dev -- \
  curl http://nginx-service:80
```

## Next Steps

After successful Dev deployment:

1. **Test thoroughly** in Dev environment
2. **Make configuration changes** and test
3. **Deploy to Staging** using `values-staging.yaml`
4. **Validate in Staging** before production
5. **Deploy to Production** using `values-prod.yaml`

## Cleanup (When Done Testing)

### Remove Dev Deployment
```bash
# Delete Helm release
helm uninstall easytravel-dev -n easytravel-dev

# Delete namespace
kubectl delete namespace easytravel-dev

# Verify cleanup
kubectl get all -n easytravel-dev
# Should return: "No resources found"
```

### Delete AKS Cluster (Optional - Full Cleanup)
```bash
# Delete AKS cluster
az aks delete \
  --resource-group easytravel-rg \
  --name easytravel-aks \
  --yes --no-wait

# Delete resource group
az group delete --name easytravel-rg --yes --no-wait

# This will remove all resources and stop billing
```

## Summary Checklist

- [ ] AKS cluster created and accessible
- [ ] Helm chart deployed to easytravel-dev namespace
- [ ] All pods running successfully
- [ ] Application accessible via port-forward or LoadBalancer
- [ ] Functional testing completed
- [ ] ArgoCD installed and configured (optional)
- [ ] GitHub Actions CI/CD pipeline configured (optional)
- [ ] Documentation reviewed and understood

## Support

If you encounter issues:
1. Check pod logs: `kubectl logs <pod-name> -n easytravel-dev`
2. Check events: `kubectl get events -n easytravel-dev --sort-by='.lastTimestamp'`
3. Describe resources: `kubectl describe <resource-type> <name> -n easytravel-dev`
4. Review main README.md for additional troubleshooting

Congratulations! You have successfully deployed EasyTravel to your Dev environment!
