# Amazon Web Services (AWS)

## Overview
Amazon Web Services is a comprehensive cloud computing platform offering over 200 services including compute, storage, databases, networking, and AI/ML capabilities. It's the world's most adopted cloud platform.

## Topics Covered
- AWS core services and architecture
- Account setup and security best practices
- Compute services (EC2, Lambda, ECS)
- Storage solutions (S3, EBS, EFS)
- Database services (RDS, DynamoDB, Redshift)
- Networking and security
- Cost optimization strategies

## Getting Started

AWS provides on-demand cloud computing resources that scale with your needs, eliminating the need for upfront infrastructure investments.

### Key Benefits
- **Scalability**: Scale resources up or down based on demand
- **Reliability**: 99.99% uptime SLA with global infrastructure
- **Security**: Enterprise-grade security and compliance
- **Cost-Effective**: Pay only for what you use
- **Global Reach**: Deploy applications worldwide

---

## Core Services

### Compute Services
- **EC2 (Elastic Compute Cloud)**: Virtual servers in the cloud
- **Lambda**: Serverless compute for event-driven applications
- **ECS (Elastic Container Service)**: Container orchestration
- **EKS (Elastic Kubernetes Service)**: Managed Kubernetes

### Storage Services
- **S3 (Simple Storage Service)**: Object storage for any amount of data
- **EBS (Elastic Block Store)**: Block storage for EC2 instances
- **EFS (Elastic File System)**: Managed file system
- **Glacier**: Long-term archival storage

### Database Services
- **RDS (Relational Database Service)**: Managed relational databases
- **DynamoDB**: NoSQL database service
- **Redshift**: Data warehouse service
- **ElastiCache**: In-memory caching

---

## Getting Started with AWS

### Account Setup
1. **Create AWS Account**
   - Visit [aws.amazon.com](https://aws.amazon.com)
   - Sign up with email and payment method
   - Verify your account

2. **Set Up IAM User**
   ```bash
   # Install AWS CLI
   pip install awscli
   
   # Configure credentials
   aws configure
   ```

3. **Enable MFA**
   - Go to IAM Console
   - Enable Multi-Factor Authentication
   - Use authenticator app or hardware token

### Basic Security
```bash
# Create IAM user with programmatic access
aws iam create-user --user-name my-user

# Attach policy
aws iam attach-user-policy \
  --user-name my-user \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Create access key
aws iam create-access-key --user-name my-user
```

---

## Essential Services

### EC2 (Elastic Compute Cloud)
```bash
# Launch an instance
aws ec2 run-instances \
  --image-id ami-0c02fb55956c7d316 \
  --instance-type t2.micro \
  --key-name my-key-pair \
  --security-group-ids sg-12345678

# List instances
aws ec2 describe-instances

# Terminate instance
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
```

### S3 (Simple Storage Service)
```bash
# Create bucket
aws s3 mb s3://my-unique-bucket-name

# Upload file
aws s3 cp local-file.txt s3://my-bucket/

# Download file
aws s3 cp s3://my-bucket/file.txt ./

# List objects
aws s3 ls s3://my-bucket/
```

### Lambda (Serverless Functions)
```python
# lambda_function.py
import json

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
```

```bash
# Deploy function
aws lambda create-function \
  --function-name my-function \
  --runtime python3.9 \
  --role arn:aws:iam::123456789012:role/lambda-execution-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip
```

---

## Database Services

### RDS (Relational Database Service)
```bash
# Create RDS instance
aws rds create-db-instance \
  --db-instance-identifier mydb \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password mypassword \
  --allocated-storage 20
```

### DynamoDB (NoSQL Database)
```bash
# Create table
aws dynamodb create-table \
  --table-name Users \
  --attribute-definitions \
    AttributeName=UserId,AttributeType=S \
  --key-schema \
    AttributeName=UserId,KeyType=HASH \
  --provisioned-throughput \
    ReadCapacityUnits=5,WriteCapacityUnits=5
```

---

## Networking and Security

### VPC (Virtual Private Cloud)
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create subnet
aws ec2 create-subnet \
  --vpc-id vpc-12345678 \
  --cidr-block 10.0.1.0/24

# Create internet gateway
aws ec2 create-internet-gateway
```

### Security Groups
```bash
# Create security group
aws ec2 create-security-group \
  --group-name my-security-group \
  --description "My security group"

# Add inbound rule
aws ec2 authorize-security-group-ingress \
  --group-id sg-12345678 \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0
```

---

## Monitoring and Logging

### CloudWatch
```bash
# Create custom metric
aws cloudwatch put-metric-data \
  --namespace MyApp \
  --metric-data MetricName=RequestCount,Value=1,Unit=Count

# Create alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "High CPU Usage" \
  --alarm-description "Alarm when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold
```

### CloudTrail
```bash
# Create trail
aws cloudtrail create-trail \
  --name my-trail \
  --s3-bucket-name my-cloudtrail-bucket
```

---

## Cost Optimization

### Best Practices
- **Right-sizing**: Choose appropriate instance types
- **Reserved Instances**: Commit to 1-3 year terms for discounts
- **Spot Instances**: Use for fault-tolerant workloads
- **Auto Scaling**: Scale resources based on demand
- **S3 Lifecycle**: Move old data to cheaper storage classes

### Cost Monitoring
```bash
# Get cost and usage report
aws ce get-cost-and-usage \
  --time-period Start=2023-01-01,End=2023-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

---

## Best Practices

### Security
- Enable CloudTrail for audit logging
- Use IAM roles instead of access keys
- Enable encryption at rest and in transit
- Regular security audits and compliance checks

### Performance
- Use CloudFront for content delivery
- Implement caching strategies
- Monitor and optimize database queries
- Use auto-scaling groups

### Cost Management
- Set up billing alerts
- Use AWS Cost Explorer
- Implement tagging strategy
- Regular cost reviews

---

## Troubleshooting

### Common Issues
- **Access Denied**: Check IAM permissions
- **Instance Not Starting**: Verify security groups and key pairs
- **High Costs**: Review unused resources and right-sizing
- **Performance Issues**: Check CloudWatch metrics

### Useful Commands
```bash
# Check account info
aws sts get-caller-identity

# List all resources
aws resourcegroupstaggingapi get-resources

# Check service health
aws health describe-events
```

---

## Next Steps

Once you're comfortable with AWS basics, explore:
- Advanced services (SageMaker, Kinesis, Step Functions)
- Infrastructure as Code (CloudFormation, CDK)
- DevOps practices (CodePipeline, CodeDeploy)
- Multi-region deployments

---

## Next Article

[:octicons-arrow-right-24: Azure](../azure/azure.md){ .md-button .md-button--primary }

Explore Microsoft Azure cloud platform with comprehensive guides for enterprise-grade cloud solutions and hybrid environments.
