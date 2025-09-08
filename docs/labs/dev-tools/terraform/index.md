# Terraform

## Overview
Terraform is an Infrastructure as Code (IaC) tool that enables you to define, provision, and manage cloud infrastructure using declarative configuration files. It supports multiple cloud providers and ensures consistent, repeatable deployments.

## Topics Covered
- Terraform fundamentals and concepts
- Installation and setup
- Writing configuration files (HCL)
- State management and collaboration
- Modules and best practices
- Multi-cloud deployments
- CI/CD integration

## Getting Started

Terraform allows you to manage infrastructure through code, providing version control, collaboration, and automation capabilities.

### Key Benefits
- **Infrastructure as Code**: Version control for infrastructure
- **Multi-Cloud**: Support for 200+ providers
- **State Management**: Track infrastructure changes
- **Plan and Apply**: Preview changes before execution
- **Modularity**: Reusable infrastructure components

---

## Installation and Setup

### Prerequisites
- **Operating System**: Windows, macOS, or Linux
- **Cloud Provider Account**: AWS, Azure, GCP, or others
- **Text Editor**: VS Code with Terraform extension recommended

### Installation Steps

1. **Install Terraform**
   ```bash
   # macOS
   brew install terraform
   
   # Ubuntu/Debian
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
   
   # Windows
   # Download from https://www.terraform.io/downloads
   ```

2. **Verify Installation**
   ```bash
   terraform version
   ```

3. **Configure Provider Credentials**
   ```bash
   # AWS
   aws configure
   
   # Azure
   az login
   
   # GCP
   gcloud auth application-default login
   ```

---

## Basic Concepts

### Configuration Files
Terraform uses HashiCorp Configuration Language (HCL):

```hcl
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  
  tags = {
    Name = "ExampleInstance"
  }
}
```

### Core Commands
```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Show current state
terraform show

# List resources
terraform state list
```

---

## AWS Example

### Basic EC2 Instance
```hcl
# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

# main.tf
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "main-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "main-rt"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name_prefix = "main-sg"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "main-sg"
  }
}

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
  EOF
  
  tags = {
    Name = "main-instance"
  }
}

# outputs.tf
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.main.public_dns
}
```

---

## Azure Example

### Basic Virtual Machine
```hcl
# main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-terraform-example"
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-terraform-example"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-terraform-example"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "nic-terraform-example"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-terraform-example"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

---

## Modules

### Creating Modules
```hcl
# modules/ec2/main.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs for EC2 instance"
  type        = list(string)
}

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  
  tags = {
    Name = "terraform-example"
  }
}

# modules/ec2/outputs.tf
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.main.public_ip
}
```

### Using Modules
```hcl
# main.tf
module "web_server" {
  source = "./modules/ec2"
  
  instance_type      = "t2.micro"
  ami_id            = "ami-0c02fb55956c7d316"
  subnet_id         = aws_subnet.main.id
  security_group_ids = [aws_security_group.main.id]
}

output "web_server_ip" {
  value = module.web_server.instance_public_ip
}
```

---

## State Management

### Local State
```bash
# State is stored locally by default
terraform state list
terraform state show aws_instance.main
terraform state mv aws_instance.main aws_instance.web_server
```

### Remote State (S3)
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "path/to/my/key"
    region = "us-west-2"
  }
}
```

### State Locking (DynamoDB)
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "path/to/my/key"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

---

## Best Practices

### Code Organization
- Use modules for reusable components
- Separate environments (dev, staging, prod)
- Use variables for configuration
- Document your code with comments

### Security
- Never commit sensitive data
- Use environment variables for secrets
- Enable state encryption
- Use least privilege access

### Collaboration
- Use remote state storage
- Implement state locking
- Use consistent naming conventions
- Code review all changes

---

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/terraform.yml
name: Terraform

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.5.0
    
    - name: Terraform Format
      run: terraform fmt -check
    
    - name: Terraform Init
      run: terraform init
    
    - name: Terraform Validate
      run: terraform validate
    
    - name: Terraform Plan
      run: terraform plan
    
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve
```

---

## Troubleshooting

### Common Issues
- **State Lock**: Check for running Terraform processes
- **Provider Issues**: Verify provider configuration
- **Resource Conflicts**: Check for naming conflicts
- **Permission Errors**: Verify IAM permissions

### Useful Commands
```bash
# Debug mode
export TF_LOG=DEBUG
terraform apply

# Import existing resources
terraform import aws_instance.main i-1234567890abcdef0

# Refresh state
terraform refresh

# Validate configuration
terraform validate
```

---

## Next Steps

Once you're comfortable with Terraform basics, explore:
- Advanced modules and testing
- Multi-cloud deployments
- Terraform Cloud for collaboration
- Policy as Code with Sentinel

---

## Next Article

[:octicons-arrow-right-24: DBT](../dbt/index.md){ .md-button .md-button--primary }

Learn data transformation with DBT (data build tool) for modern data engineering workflows and analytics engineering.
