# Quick Reference Guide - Common Commands

## Deployment Commands

### Deploy with Helm
```bash
# Dev
helm upgrade --install easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-dev.yaml \
  -n easytravel-dev --create-namespace --wait

# Staging
helm upgrade --install easytravel-staging ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-staging.yaml \
  -n easytravel-staging --create-namespace --wait

# Production
helm upgrade --install easytravel-prod ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-prod.yaml \
  -n easytravel-prod --create-namespace --wait
```

## Monitoring Commands

### Check Pod Status
```bash
# All pods in namespace
kubectl get pods -n easytravel-dev

# Watch pods
kubectl get pods -n easytravel-dev --watch

# Pod details
kubectl describe pod <pod-name> -n easytravel-dev

# Pod logs
kubectl logs -f deployment/backend -n easytravel-dev
kubectl logs deployment/backend -n easytravel-dev --tail=100
kubectl logs <pod-name> -n easytravel-dev --previous  # After crash
```

### Check Services
```bash
# List services
kubectl get svc -n easytravel-dev

# Service details
kubectl describe svc nginx-service -n easytravel-dev

# Get external IP (if LoadBalancer)
kubectl get svc nginx-service -n easytravel-dev -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### Check Deployments
```bash
# List deployments
kubectl get deployments -n easytravel-dev

# Deployment status
kubectl rollout status deployment/backend -n easytravel-dev

# Deployment history
kubectl rollout history deployment/backend -n easytravel-dev
```

## Access Application

### Port Forward
```bash
# Forward nginx (all ports)
kubectl port-forward svc/nginx-service 8080:80 8081:9079 8082:8080 -n easytravel-dev

# Forward specific service
kubectl port-forward svc/backend-service 8080:8080 -n easytravel-dev
kubectl port-forward svc/frontend-service 8080:8080 -n easytravel-dev
```

### Access URLs
```
Classic Frontend: http://localhost:8080
Angular Frontend: http://localhost:8081
Backend API: http://localhost:8082
```

## Troubleshooting Commands

### Debug Pods
```bash
# Run debug pod
kubectl run debug --image=alpine --rm -it -n easytravel-dev -- sh

# Inside debug pod:
apk add curl
curl http://backend-service:8080
curl http://mongodb-service:27017
```

### Check Events
```bash
# Recent events
kubectl get events -n easytravel-dev --sort-by='.lastTimestamp'

# Watch events
kubectl get events -n easytravel-dev --watch
```

### Resource Usage
```bash
# Pod resource usage
kubectl top pods -n easytravel-dev

# Node resource usage
kubectl top nodes

# Detailed resource allocation
kubectl describe nodes | grep -A 5 "Allocated resources"
```

### Check Configuration
```bash
# View ConfigMap
kubectl get configmap easytravel-config -n easytravel-dev -o yaml

# View Secret (decoded)
kubectl get secret easytravel-secrets -n easytravel-dev -o jsonpath='{.data.MONGODB_USER}' | base64 -d
kubectl get secret easytravel-secrets -n easytravel-dev -o jsonpath='{.data.MONGODB_PASSWORD}' | base64 -d
```

## Scaling Commands

### Manual Scaling
```bash
# Scale specific deployment
kubectl scale deployment backend --replicas=3 -n easytravel-dev
kubectl scale deployment frontend --replicas=2 -n easytravel-dev

# Scale all deployments
kubectl scale deployment --all --replicas=2 -n easytravel-dev
```

### Check HPA (Horizontal Pod Autoscaler)
```bash
# List HPAs
kubectl get hpa -n easytravel-dev

# HPA details
kubectl describe hpa backend-hpa -n easytravel-dev

# Watch HPA
kubectl get hpa -n easytravel-dev --watch
```

## Update and Rollback

### Update Deployment
```bash
# Update via Helm
helm upgrade easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-dev.yaml \
  -n easytravel-dev

# Update specific value
helm upgrade easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values.yaml \
  -f helm-charts/easytravel/values-dev.yaml \
  --set backend.replicaCount=3 \
  -n easytravel-dev
```

### Rollback Deployment
```bash
# Helm history
helm history easytravel-dev -n easytravel-dev

# Rollback to previous
helm rollback easytravel-dev -n easytravel-dev

# Rollback to specific revision
helm rollback easytravel-dev 2 -n easytravel-dev

# Kubectl rollback
kubectl rollout undo deployment/backend -n easytravel-dev
kubectl rollout undo deployment/backend --to-revision=2 -n easytravel-dev
```

### Restart Deployments
```bash
# Restart specific deployment
kubectl rollout restart deployment/backend -n easytravel-dev

# Restart all deployments
kubectl rollout restart deployment -n easytravel-dev
```

## ArgoCD Commands

### Application Management
```bash
# List applications
argocd app list

# Get application details
argocd app get easytravel-dev

# Sync application
argocd app sync easytravel-dev

# Sync with prune
argocd app sync easytravel-dev --prune

# Wait for sync to complete
argocd app wait easytravel-dev --health
```

### Application Status
```bash
# Get sync status
argocd app get easytravel-dev --refresh

# View application history
argocd app history easytravel-dev

# View application manifests
argocd app manifests easytravel-dev
```

### Rollback with ArgoCD
```bash
# Rollback to previous sync
argocd app rollback easytravel-dev

# Rollback to specific revision
argocd app rollback easytravel-dev 5
```

## Cleanup Commands

### Delete Application
```bash
# Uninstall Helm release
helm uninstall easytravel-dev -n easytravel-dev

# Delete namespace
kubectl delete namespace easytravel-dev

# Delete ArgoCD application
argocd app delete easytravel-dev
kubectl delete application easytravel-dev -n argocd
```

### Delete Specific Resources
```bash
# Delete deployment
kubectl delete deployment backend -n easytravel-dev

# Delete service
kubectl delete svc backend-service -n easytravel-dev

# Delete all in namespace
kubectl delete all --all -n easytravel-dev
```

## Azure AKS Commands

### Cluster Management
```bash
# Get credentials
az aks get-credentials --resource-group easytravel-rg --name easytravel-aks

# Show cluster details
az aks show --resource-group easytravel-rg --name easytravel-aks

# List node pools
az aks nodepool list --resource-group easytravel-rg --cluster-name easytravel-aks

# Scale node pool
az aks nodepool scale \
  --resource-group easytravel-rg \
  --cluster-name easytravel-aks \
  --name nodepool1 \
  --node-count 5
```

### Cluster Operations
```bash
# Start cluster
az aks start --resource-group easytravel-rg --name easytravel-aks

# Stop cluster
az aks stop --resource-group easytravel-rg --name easytravel-aks

# Upgrade cluster
az aks upgrade \
  --resource-group easytravel-rg \
  --name easytravel-aks \
  --kubernetes-version 1.29.0
```

## Helm Commands

### Chart Management
```bash
# Lint chart
helm lint helm-charts/easytravel

# Dry-run install
helm install easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values-dev.yaml \
  -n easytravel-dev --dry-run --debug

# Template chart (render manifests)
helm template easytravel-dev ./helm-charts/easytravel \
  -f helm-charts/easytravel/values-dev.yaml
```

### Release Management
```bash
# List releases
helm list -n easytravel-dev
helm list --all-namespaces

# Get release values
helm get values easytravel-dev -n easytravel-dev

# Get release manifest
helm get manifest easytravel-dev -n easytravel-dev

# Show release notes
helm get notes easytravel-dev -n easytravel-dev
```

## Testing Commands

### Connectivity Tests
```bash
# Test from within cluster
kubectl run test-curl --image=curlimages/curl --rm -it -n easytravel-dev -- sh
# Then: curl http://backend-service:8080

# Test DNS resolution
kubectl run test-dns --image=busybox --rm -it -n easytravel-dev -- nslookup backend-service

# Test MongoDB connection
kubectl exec -it deployment/mongodb -n easytravel-dev -- mongo --eval "db.adminCommand('ping')"
```

### Health Checks
```bash
# Backend health
kubectl exec -it deployment/backend -n easytravel-dev -- curl localhost:8080/

# Check all endpoints
for svc in backend-service frontend-service angular-frontend-service nginx-service; do
  echo "Testing $svc..."
  kubectl run test --image=curlimages/curl --rm -it -n easytravel-dev -- curl http://$svc
done
```

## Common One-Liners

```bash
# Get all pod IPs
kubectl get pods -n easytravel-dev -o wide

# Get pod resource requests/limits
kubectl get pods -n easytravel-dev -o custom-columns=NAME:.metadata.name,CPU_REQ:.spec.containers[*].resources.requests.cpu,MEM_REQ:.spec.containers[*].resources.requests.memory

# Find pods by label
kubectl get pods -l app=backend -n easytravel-dev

# Get all resources with label
kubectl get all -l app.kubernetes.io/part-of=easytravel -n easytravel-dev

# Port forward all at once
kubectl port-forward -n easytravel-dev svc/nginx-service 8080:80 8081:9079 &

# Delete completed pods
kubectl delete pods --field-selector status.phase=Succeeded -n easytravel-dev

# Get pod restart count
kubectl get pods -n easytravel-dev -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[*].restartCount

# Find pods consuming most CPU
kubectl top pods -n easytravel-dev --sort-by=cpu

# Find pods consuming most memory
kubectl top pods -n easytravel-dev --sort-by=memory
```

## Useful Aliases

Add these to your `~/.bashrc` or `~/.zshrc`:

```bash
# Kubectl aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kl='kubectl logs -f'
alias kex='kubectl exec -it'

# Namespace aliases
alias kdev='kubectl -n easytravel-dev'
alias kstaging='kubectl -n easytravel-staging'
alias kprod='kubectl -n easytravel-prod'

# Helm aliases
alias h='helm'
alias hl='helm list'
alias hh='helm history'
alias hu='helm upgrade'
alias hi='helm install'

# Combined
alias kdgp='kubectl get pods -n easytravel-dev'
alias ksgp='kubectl get pods -n easytravel-staging'
alias kpgp='kubectl get pods -n easytravel-prod'
```

## Environment Variables

```bash
# Set default namespace
export NAMESPACE=easytravel-dev
kubectl config set-context --current --namespace=$NAMESPACE

# Azure environment
export RESOURCE_GROUP=easytravel-rg
export CLUSTER_NAME=easytravel-aks
export LOCATION=eastus
```

## Bookmarks

Save these for quick reference:
- ArgoCD UI: https://localhost:8443 (when port-forwarded)
- Classic Frontend: http://localhost:8080
- Angular Frontend: http://localhost:8081
- Backend API: http://localhost:8082
- GitHub Actions: https://github.com/YOUR_ORG/easytravel-k8s/actions
