# Kubernetes

## Overview
Kubernetes (K8s) is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. It provides a robust framework for running distributed systems.

## Topics Covered
- Kubernetes architecture and concepts
- Cluster setup and configuration
- Pods, services, and deployments
- Scaling and load balancing
- Monitoring and troubleshooting
- Production best practices

## Getting Started

Kubernetes simplifies container management by providing automated deployment, scaling, and operations across clusters of hosts.

### Key Features
- **Automated Scheduling**: Intelligent placement of containers
- **Self-Healing**: Automatic restart and replacement of failed containers
- **Horizontal Scaling**: Scale applications up or down based on demand
- **Service Discovery**: Automatic service discovery and load balancing
- **Rolling Updates**: Zero-downtime deployments

---

## Core Concepts

### Cluster Architecture
- **Master Node**: Controls the cluster (API server, etcd, scheduler, controller manager)
- **Worker Nodes**: Run the actual workloads (kubelet, kube-proxy, container runtime)
- **Pods**: Smallest deployable units in Kubernetes
- **Services**: Stable network endpoints for pods

### Key Components
- **Pods**: One or more containers sharing storage and network
- **Deployments**: Manage replica sets and rolling updates
- **Services**: Expose pods to network traffic
- **ConfigMaps**: Store configuration data
- **Secrets**: Store sensitive data

---

## Installation Options

### Local Development
```bash
# Minikube (local single-node cluster)
minikube start

# Kind (Kubernetes in Docker)
kind create cluster

# Docker Desktop (built-in Kubernetes)
# Enable in Docker Desktop settings
```

### Cloud Providers
- **Amazon EKS**: Managed Kubernetes on AWS
- **Google GKE**: Managed Kubernetes on GCP
- **Azure AKS**: Managed Kubernetes on Azure
- **DigitalOcean**: Managed Kubernetes clusters

---

## Basic Operations

### Creating Resources
```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
```

```bash
# Apply configuration
kubectl apply -f pod.yaml

# Get pods
kubectl get pods

# Describe pod
kubectl describe pod my-pod

# Delete pod
kubectl delete pod my-pod
```

### Deployments
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```

### Services
```yaml
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

---

## Common kubectl Commands

```bash
# Get resources
kubectl get pods
kubectl get services
kubectl get deployments

# Describe resources
kubectl describe pod <pod-name>
kubectl describe service <service-name>

# Logs
kubectl logs <pod-name>
kubectl logs -f <pod-name>  # Follow logs

# Execute commands
kubectl exec -it <pod-name> -- /bin/bash

# Port forwarding
kubectl port-forward <pod-name> 8080:80

# Scale deployments
kubectl scale deployment <deployment-name> --replicas=5
```

---

## Configuration Management

### ConfigMaps
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database_url: "postgresql://localhost:5432/mydb"
  debug: "true"
```

### Secrets
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  username: YWRtaW4=  # base64 encoded
  password: MWYyZDFlMmU2N2Rm  # base64 encoded
```

---

## Monitoring and Debugging

### Health Checks
```yaml
spec:
  containers:
  - name: app
    image: my-app
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
```

### Resource Limits
```yaml
spec:
  containers:
  - name: app
    image: my-app
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

---

## Best Practices

### Security
- Use RBAC for access control
- Keep images updated
- Use secrets for sensitive data
- Enable network policies

### Performance
- Set appropriate resource limits
- Use horizontal pod autoscaling
- Optimize image sizes
- Monitor resource usage

### Operations
- Use namespaces for organization
- Implement proper logging
- Set up monitoring and alerting
- Document your configurations

---

## Troubleshooting

### Common Issues
- **Pod not starting**: Check image availability and resource limits
- **Service not accessible**: Verify selectors and port configurations
- **Deployment stuck**: Check replica set and pod status
- **Resource exhaustion**: Monitor cluster resources

### Debugging Commands
```bash
# Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# Check resource usage
kubectl top nodes
kubectl top pods

# Check cluster info
kubectl cluster-info

# Check node status
kubectl get nodes
kubectl describe node <node-name>
```

---

## Next Steps

Once you're comfortable with Kubernetes basics, explore:
- Helm for package management
- Istio for service mesh
- Prometheus for monitoring
- GitOps workflows

---

## Next Article

[:octicons-arrow-right-24: AWS](../aws/aws.md){ .md-button .md-button--primary }

Learn how to deploy and manage applications on Amazon Web Services with comprehensive cloud infrastructure guides.
