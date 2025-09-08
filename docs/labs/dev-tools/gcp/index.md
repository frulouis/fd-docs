# Google Cloud Platform (GCP)

## Overview
Google Cloud Platform is a comprehensive cloud computing platform offering over 100 services for compute, storage, networking, and AI/ML. It's known for its data analytics, machine learning, and open-source technologies.

## Topics Covered
- GCP core services and architecture
- Account setup and project management
- Compute services (Compute Engine, Cloud Functions, GKE)
- Storage solutions (Cloud Storage, Persistent Disks)
- Database services (Cloud SQL, Firestore, BigQuery)
- AI/ML services (Vertex AI, AutoML)
- Data analytics and processing

## Getting Started

GCP provides a powerful cloud platform with strong focus on data analytics, machine learning, and open-source technologies.

### Key Benefits
- **Data Analytics**: Industry-leading big data and analytics services
- **Machine Learning**: Advanced AI/ML platform with AutoML
- **Open Source**: Strong support for Kubernetes, TensorFlow, and open technologies
- **Global Network**: High-performance global network infrastructure
- **Sustainability**: Carbon-neutral cloud platform

---

## Core Services

### Compute Services
- **Compute Engine**: Virtual machines with custom machine types
- **Cloud Functions**: Serverless functions for event-driven applications
- **Google Kubernetes Engine (GKE)**: Managed Kubernetes service
- **App Engine**: Platform-as-a-Service for web applications
- **Cloud Run**: Serverless containers

### Storage Services
- **Cloud Storage**: Object storage with multiple storage classes
- **Persistent Disks**: Block storage for VMs
- **Cloud Filestore**: Managed file system
- **Cloud Storage Transfer**: Data migration service

### Database Services
- **Cloud SQL**: Managed MySQL, PostgreSQL, and SQL Server
- **Firestore**: NoSQL document database
- **BigQuery**: Serverless data warehouse
- **Cloud Spanner**: Globally distributed SQL database

---

## Getting Started with GCP

### Account Setup
1. **Create GCP Account**
   - Visit [cloud.google.com](https://cloud.google.com)
   - Sign up with Google account
   - Verify identity and payment method

2. **Install Google Cloud CLI**
   ```bash
   # Install gcloud CLI
   curl https://sdk.cloud.google.com | bash
   exec -l $SHELL
   
   # Initialize gcloud
   gcloud init
   
   # Set project
   gcloud config set project PROJECT_ID
   ```

3. **Enable APIs**
   ```bash
   # Enable required APIs
   gcloud services enable compute.googleapis.com
   gcloud services enable storage.googleapis.com
   gcloud services enable bigquery.googleapis.com
   ```

---

## Essential Services

### Compute Engine
```bash
# Create VM instance
gcloud compute instances create my-instance \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud

# List instances
gcloud compute instances list

# SSH into instance
gcloud compute ssh my-instance --zone=us-central1-a
```

### Cloud Storage
```bash
# Create bucket
gsutil mb gs://my-unique-bucket-name

# Upload file
gsutil cp local-file.txt gs://my-bucket/

# Download file
gsutil cp gs://my-bucket/file.txt ./

# List objects
gsutil ls gs://my-bucket/
```

### Cloud Functions
```python
# main.py
def hello_world(request):
    return 'Hello World!'

# requirements.txt
functions-framework==3.*
```

```bash
# Deploy function
gcloud functions deploy hello_world \
  --runtime python39 \
  --trigger-http \
  --allow-unauthenticated
```

---

## Database Services

### Cloud SQL
```bash
# Create Cloud SQL instance
gcloud sql instances create my-instance \
  --database-version=POSTGRES_13 \
  --tier=db-f1-micro \
  --region=us-central1

# Create database
gcloud sql databases create mydb --instance=my-instance

# Create user
gcloud sql users create myuser \
  --instance=my-instance \
  --password=mypassword
```

### Firestore
```python
# Python client
from google.cloud import firestore

# Initialize client
db = firestore.Client()

# Add document
doc_ref = db.collection('users').document('alovelace')
doc_ref.set({
    'first': 'Ada',
    'last': 'Lovelace',
    'born': 1815
})

# Read document
doc = doc_ref.get()
if doc.exists:
    print(f'Document data: {doc.to_dict()}')
```

### BigQuery
```sql
-- Create dataset
CREATE SCHEMA `myproject.mydataset`
OPTIONS (
  description="My dataset",
  location="US"
);

-- Create table
CREATE TABLE `myproject.mydataset.mytable` (
  id INT64,
  name STRING,
  created_at TIMESTAMP
);

-- Query data
SELECT * FROM `myproject.mydataset.mytable`
WHERE created_at > '2023-01-01';
```

---

## AI and Machine Learning

### Vertex AI
```python
# Train model with Vertex AI
from google.cloud import aiplatform

# Initialize Vertex AI
aiplatform.init(project="myproject", location="us-central1")

# Create dataset
dataset = aiplatform.TabularDataset.create(
    display_name="my-dataset",
    gcs_source="gs://my-bucket/data.csv"
)

# Create training job
job = aiplatform.AutoMLTabularTrainingJob(
    display_name="my-training-job",
    optimization_objective="minimize-rmse"
)

# Run training
model = job.run(
    dataset=dataset,
    target_column="target",
    training_fraction_split=0.8,
    validation_fraction_split=0.1,
    test_fraction_split=0.1
)
```

### AutoML
```python
# AutoML Vision
from google.cloud import automl

# Initialize client
client = automl.AutoMlClient()

# Create dataset
project_id = "myproject"
location = "us-central1"
dataset_id = "my-dataset"

dataset = {
    "display_name": "my-dataset",
    "image_classification_dataset_metadata": {}
}

operation = client.create_dataset(
    parent=f"projects/{project_id}/locations/{location}",
    dataset=dataset
)
```

---

## Data Analytics

### BigQuery Analytics
```sql
-- Analyze sales data
WITH monthly_sales AS (
  SELECT 
    DATE_TRUNC(order_date, MONTH) as month,
    SUM(amount) as total_sales,
    COUNT(*) as order_count
  FROM `myproject.mydataset.orders`
  WHERE order_date >= '2023-01-01'
  GROUP BY month
)
SELECT 
  month,
  total_sales,
  order_count,
  total_sales / order_count as avg_order_value
FROM monthly_sales
ORDER BY month;
```

### Dataflow (Apache Beam)
```python
# Dataflow pipeline
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

# Define pipeline
def run_pipeline():
    options = PipelineOptions()
    
    with beam.Pipeline(options=options) as pipeline:
        (pipeline
         | 'Read' >> beam.io.ReadFromText('gs://my-bucket/input.txt')
         | 'Transform' >> beam.Map(lambda x: x.upper())
         | 'Write' >> beam.io.WriteToText('gs://my-bucket/output.txt'))

if __name__ == '__main__':
    run_pipeline()
```

---

## Networking and Security

### VPC Networks
```bash
# Create VPC network
gcloud compute networks create my-vpc \
  --subnet-mode=custom

# Create subnet
gcloud compute networks subnets create my-subnet \
  --network=my-vpc \
  --range=10.0.1.0/24 \
  --region=us-central1

# Create firewall rule
gcloud compute firewall-rules create allow-ssh \
  --network=my-vpc \
  --allow=tcp:22 \
  --source-ranges=0.0.0.0/0
```

### IAM and Security
```bash
# Create service account
gcloud iam service-accounts create my-service-account \
  --display-name="My Service Account"

# Grant role
gcloud projects add-iam-policy-binding myproject \
  --member="serviceAccount:my-service-account@myproject.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

---

## Monitoring and Logging

### Cloud Monitoring
```python
# Custom metrics
from google.cloud import monitoring_v3

# Create metric
client = monitoring_v3.MetricServiceClient()
project_name = f"projects/myproject"

series = monitoring_v3.TimeSeries()
series.metric.type = "custom.googleapis.com/my_metric"
series.resource.type = "global"

# Write metric
client.create_time_series(name=project_name, time_series=[series])
```

### Cloud Logging
```python
# Structured logging
from google.cloud import logging

# Initialize client
client = logging.Client()
logger = client.logger("my-logger")

# Log structured data
logger.log_struct(
    {
        "message": "User action",
        "user_id": "12345",
        "action": "login",
        "timestamp": "2023-01-01T00:00:00Z"
    },
    severity="INFO"
)
```

---

## Cost Management

### Budget Alerts
```bash
# Create budget
gcloud billing budgets create \
  --billing-account=123456-ABCDEF-789012 \
  --display-name="My Budget" \
  --budget-amount=1000USD \
  --threshold-rule=percent:50 \
  --threshold-rule=percent:90
```

### Cost Optimization
- Use committed use discounts
- Implement auto-scaling
- Use preemptible instances
- Regular cost analysis

---

## Best Practices

### Security
- Enable Cloud Security Command Center
- Use IAM best practices
- Implement network security
- Regular security audits

### Performance
- Use Cloud CDN for content delivery
- Implement caching strategies
- Monitor application performance
- Use auto-scaling

### Cost Management
- Set up budget alerts
- Use committed use discounts
- Regular cost reviews
- Implement resource tagging

---

## Troubleshooting

### Common Issues
- **Authentication Errors**: Check service account permissions
- **Resource Not Found**: Verify project and region
- **Quota Exceeded**: Check service quotas
- **Deployment Failures**: Review operation logs

### Useful Commands
```bash
# Check project info
gcloud config get-value project

# List all resources
gcloud asset search-all-resources

# Check quotas
gcloud compute project-info describe --project=myproject
```

---

## Next Steps

Once you're comfortable with GCP basics, explore:
- Advanced AI services (Vertex AI, AutoML)
- Data engineering (Dataflow, Dataproc)
- DevOps practices (Cloud Build, Cloud Deploy)
- Multi-cloud strategies

---

## Next Article

[:octicons-arrow-right-24: Terraform](../terraform/terraform.md){ .md-button .md-button--primary }

Learn Infrastructure as Code with Terraform for consistent, repeatable cloud infrastructure deployment across multiple providers.
