# Microsoft Azure

## Overview
Microsoft Azure is a comprehensive cloud computing platform offering over 200 services for building, deploying, and managing applications. It provides integrated cloud services for compute, storage, networking, and AI/ML capabilities.

## Topics Covered
- Azure core services and architecture
- Account setup and resource management
- Compute services (Virtual Machines, App Service, Functions)
- Storage solutions (Blob Storage, Files, Disks)
- Database services (SQL Database, Cosmos DB, PostgreSQL)
- Networking and security
- Hybrid cloud and enterprise integration

## Getting Started

Azure provides a robust cloud platform with strong enterprise integration, hybrid cloud capabilities, and comprehensive AI/ML services.

### Key Benefits
- **Enterprise Integration**: Seamless integration with Microsoft ecosystem
- **Hybrid Cloud**: Bridge on-premises and cloud environments
- **AI/ML Services**: Comprehensive artificial intelligence platform
- **Security**: Enterprise-grade security and compliance
- **Global Presence**: Data centers in 60+ regions worldwide

---

## Core Services

### Compute Services
- **Virtual Machines**: Flexible computing with Windows and Linux
- **App Service**: Platform-as-a-Service for web applications
- **Azure Functions**: Serverless compute for event-driven applications
- **Container Instances**: Serverless containers
- **AKS (Azure Kubernetes Service)**: Managed Kubernetes

### Storage Services
- **Blob Storage**: Object storage for unstructured data
- **Files**: Managed file shares
- **Disks**: Persistent storage for VMs
- **Data Lake Storage**: Big data analytics storage

### Database Services
- **SQL Database**: Managed SQL Server
- **Cosmos DB**: Globally distributed NoSQL database
- **PostgreSQL**: Managed PostgreSQL service
- **Redis Cache**: In-memory data store

---

## Getting Started with Azure

### Account Setup
1. **Create Azure Account**
   - Visit [azure.microsoft.com](https://azure.microsoft.com)
   - Sign up with Microsoft account
   - Verify identity and payment method

2. **Install Azure CLI**
   ```bash
   # Install Azure CLI
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   
   # Login to Azure
   az login
   
   # Set subscription
   az account set --subscription "My Subscription"
   ```

3. **Set Up Resource Groups**
   ```bash
   # Create resource group
   az group create --name myResourceGroup --location eastus
   
   # List resource groups
   az group list --output table
   ```

---

## Essential Services

### Virtual Machines
```bash
# Create VM
az vm create \
  --resource-group myResourceGroup \
  --name myVM \
  --image UbuntuLTS \
  --admin-username azureuser \
  --generate-ssh-keys

# List VMs
az vm list --output table

# Start/Stop VM
az vm start --resource-group myResourceGroup --name myVM
az vm stop --resource-group myResourceGroup --name myVM
```

### Blob Storage
```bash
# Create storage account
az storage account create \
  --name mystorageaccount \
  --resource-group myResourceGroup \
  --location eastus \
  --sku Standard_LRS

# Create container
az storage container create \
  --name mycontainer \
  --account-name mystorageaccount

# Upload file
az storage blob upload \
  --account-name mystorageaccount \
  --container-name mycontainer \
  --name myfile.txt \
  --file ./myfile.txt
```

### App Service
```bash
# Create web app
az webapp create \
  --resource-group myResourceGroup \
  --plan myAppServicePlan \
  --name myWebApp \
  --runtime "NODE|14-lts"

# Deploy code
az webapp deployment source config \
  --resource-group myResourceGroup \
  --name myWebApp \
  --repo-url https://github.com/user/repo \
  --branch master \
  --manual-integration
```

---

## Database Services

### SQL Database
```bash
# Create SQL server
az sql server create \
  --name myserver \
  --resource-group myResourceGroup \
  --location eastus \
  --admin-user azureuser \
  --admin-password MyPassword123!

# Create database
az sql db create \
  --resource-group myResourceGroup \
  --server myserver \
  --name myDatabase \
  --service-objective S0
```

### Cosmos DB
```bash
# Create Cosmos DB account
az cosmosdb create \
  --name mycosmosdb \
  --resource-group myResourceGroup \
  --locations regionName=eastus

# Create database
az cosmosdb sql database create \
  --account-name mycosmosdb \
  --resource-group myResourceGroup \
  --name myDatabase
```

---

## Networking and Security

### Virtual Networks
```bash
# Create virtual network
az network vnet create \
  --resource-group myResourceGroup \
  --name myVNet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name mySubnet \
  --subnet-prefix 10.0.1.0/24

# Create network security group
az network nsg create \
  --resource-group myResourceGroup \
  --name myNSG

# Add security rule
az network nsg rule create \
  --resource-group myResourceGroup \
  --nsg-name myNSG \
  --name AllowSSH \
  --protocol Tcp \
  --priority 1000 \
  --destination-port-range 22 \
  --access Allow
```

### Key Vault
```bash
# Create Key Vault
az keyvault create \
  --name myKeyVault \
  --resource-group myResourceGroup \
  --location eastus

# Store secret
az keyvault secret set \
  --vault-name myKeyVault \
  --name mySecret \
  --value "MySecretValue"
```

---

## AI and Machine Learning

### Cognitive Services
```python
# Text Analytics
from azure.cognitiveservices.vision.computervision import ComputerVisionClient
from msrest.authentication import CognitiveServicesCredentials

# Initialize client
credentials = CognitiveServicesCredentials("your-key")
client = ComputerVisionClient("your-endpoint", credentials)

# Analyze image
result = client.analyze_image("image-url", visual_features=["Description"])
```

### Machine Learning
```python
# Azure ML SDK
from azureml.core import Workspace, Experiment, ScriptRunConfig

# Create workspace
ws = Workspace.create(
    name='myworkspace',
    subscription_id='your-subscription-id',
    resource_group='myResourceGroup',
    location='eastus'
)

# Create experiment
experiment = Experiment(workspace=ws, name='my-experiment')
```

---

## Monitoring and Management

### Application Insights
```bash
# Create Application Insights
az monitor app-insights component create \
  --app myAppInsights \
  --location eastus \
  --resource-group myResourceGroup

# Get instrumentation key
az monitor app-insights component show \
  --app myAppInsights \
  --resource-group myResourceGroup \
  --query instrumentationKey
```

### Log Analytics
```bash
# Create Log Analytics workspace
az monitor log-analytics workspace create \
  --resource-group myResourceGroup \
  --workspace-name myWorkspace \
  --location eastus
```

---

## Cost Management

### Budget Alerts
```bash
# Create budget
az consumption budget create \
  --budget-name myBudget \
  --resource-group myResourceGroup \
  --amount 1000 \
  --time-grain Monthly
```

### Cost Analysis
- Use Azure Cost Management
- Set up budget alerts
- Review cost recommendations
- Implement resource tagging

---

## Best Practices

### Security
- Enable Azure Security Center
- Use Azure Active Directory
- Implement network security groups
- Regular security assessments

### Performance
- Use Azure CDN for content delivery
- Implement caching strategies
- Monitor application performance
- Use auto-scaling

### Cost Optimization
- Use reserved instances
- Implement auto-shutdown for VMs
- Regular cost reviews
- Use Azure Advisor recommendations

---

## Troubleshooting

### Common Issues
- **Authentication Errors**: Check Azure AD configuration
- **Resource Not Found**: Verify resource group and location
- **Permission Denied**: Check RBAC assignments
- **Deployment Failures**: Review activity log

### Useful Commands
```bash
# Check account info
az account show

# List all resources
az resource list --output table

# Check activity log
az monitor activity-log list --resource-group myResourceGroup
```

---

## Next Steps

Once you're comfortable with Azure basics, explore:
- Advanced AI services (Cognitive Services, Bot Framework)
- DevOps practices (Azure DevOps, GitHub Actions)
- Hybrid cloud solutions (Azure Arc, Azure Stack)
- Enterprise integration (Active Directory, Power Platform)

---

## Next Article

[:octicons-arrow-right-24: GCP](../gcp/gcp.md){ .md-button .md-button--primary }

Discover Google Cloud Platform with comprehensive guides for data analytics, machine learning, and modern cloud-native applications.
