# 🚀 AWS Multi-AZ Load-Balanced Infrastructure with Terraform


![2025-06-25 (15)](https://github.com/user-attachments/assets/5dee372c-7f20-4995-9d1a-f02858ac6640)



![2025-06-25 (4)](https://github.com/user-attachments/assets/013226bc-b9f6-4421-b23b-0ceedbaa97bf)

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?logo=terraform)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Medium](https://img.shields.io/badge/Medium-Blog%20Post-12100E?logo=medium)](https://medium.com/@your-username/your-blog-post)



![2025-06-25 (16)](https://github.com/user-attachments/assets/7a307b92-dcd3-4a69-adc9-e87710d67e2f)

A production-ready, multi-availability zone infrastructure deployment on AWS using Terraform. This project demonstrates enterprise-grade architecture patterns with high availability, intelligent load balancing, and Infrastructure as Code best practices.

## 🏗️ Architecture Overview

This infrastructure creates a highly available web application spanning multiple AWS Availability Zones with intelligent traffic routing based on subdomains.

```
Internet → Route 53 → Application Load Balancer → Target Groups → EC2 Instances
                                ↓
                        (us-east-1a & us-east-1b)
```

### 🎯 Key Features

- **🌍 Multi-AZ Deployment**: Fault-tolerant architecture across multiple availability zones
- **⚡ Load Balancing**: Application Load Balancer with health checks and intelligent routing
- **🌐 Custom DNS**: Route 53 hosted zone with subdomain routing
- **🔒 Security**: Security groups with least-privilege access
- **📝 Infrastructure as Code**: 100% Terraform-managed infrastructure
- **🎨 Host-based Routing**: Different content served based on subdomain

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Infrastructure** | Terraform | Infrastructure as Code automation |
| **Compute** | AWS EC2 | Virtual servers hosting web applications |
| **Load Balancing** | AWS ALB | Traffic distribution and health monitoring |
| **DNS** | Route 53 | Domain management and traffic routing |
| **Security** | Security Groups | Network-level access control |
| **Monitoring** | CloudWatch | Infrastructure monitoring (optional) |

## 🚀 Quick Start


![2025-06-25 (6)](https://github.com/user-attachments/assets/a0493050-1376-4233-ad9f-805997123ddb)


### Prerequisites

- **AWS Account** with administrative privileges
- **Terraform** >= 1.0 ([Installation Guide](https://terraform.io/downloads))
- **AWS CLI** configured with credentials ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- **Domain name** (optional, but recommended for full experience)

### 1. Clone and Setup

```bash
# Clone the repository
 https://github.com/etaoko333/project-4-load-balanced-architecture.git]
cd project-4-load-balanced-architecture

# Initialize Terraform
terraform init
```

### 2. Configure Variables

Create a `terraform.tfvars` file:

```hcl
# terraform.tfvars
aws_region    = "us-east-1"
domain_name   = "your-domain.com"  # Replace with your domain
instance_type = "t2.micro"
key_name      = "your-key-pair"    # Optional: for SSH access
```

![2025-06-25 (9)](https://github.com/user-attachments/assets/fe8450af-9101-44ef-98f4-d83277d0eaea)


### 3. Deploy Infrastructure

```bash
# Review the deployment plan
terraform plan

# Deploy the infrastructure
terraform apply

# Note the outputs (ALB DNS name, Route 53 name servers)
terraform output
```
![2025-06-25 (2)](https://github.com/user-attachments/assets/770a3286-380c-4853-8175-0fa8ec0ea651)


### 4. Configure Domain (Optional)

If using a custom domain:

1. **Get name servers** from Terraform output
2. **Update your domain registrar** to use Route 53 name servers
3. **Wait for DNS propagation** (15-60 minutes)

### 5. Test Your Deployment

```bash
# Test ALB directly
curl http://$(terraform output -raw load_balancer_dns)

# Test with custom domain (after DNS propagation)
curl http://your-domain.com
curl http://red.your-domain.com
curl http://blue.your-domain.com
curl http://www.your-domain.com
```


![2025-06-25 (12)](https://github.com/user-attachments/assets/2dbd09be-e8f6-4454-8dd7-c5c89484250b)

## 📁 Project Structure

```
aws-multi-az-infrastructure/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable values (create this)
├── user-data-red.sh        # Red server initialization script
├── user-data-blue.sh       # Blue server initialization script
├── README.md               # This file
└── .gitignore              # Git ignore file
```

![2025-06-25 (13)](https://github.com/user-attachments/assets/2af63096-6429-4423-9fcd-3c1cbc305608)



![2025-06-25 (2)](https://github.com/user-attachments/assets/daeee10f-2dd3-4d92-9087-b602471cfef8)

## ⚙️ Configuration Details

### Default Configuration

| Resource | Configuration | Notes |
|----------|---------------|-------|
| **EC2 Instances** | t2.micro, Amazon Linux 2023 | Free tier eligible |
| **Load Balancer** | Application Load Balancer | HTTP (port 80) |
| **Availability Zones** | us-east-1a, us-east-1b | Multi-AZ for high availability |
| **Security Groups** | HTTP (80), SSH (22) | Least privilege access |
| **Health Checks** | HTTP on port 80, path "/" | 30-second intervals |

### Customizable Variables

```hcl
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Your domain name"
  type        = string
  default     = "example.com"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS key pair for SSH access"
  type        = string
  default     = ""
}
```

## 🌐 Routing Configuration

The load balancer routes traffic based on the host header:

| URL | Target | Content |
|-----|--------|---------|
| `http://your-domain.com` | Red Server | Red-themed page (default) |
| `http://www.your-domain.com` | Red Server | Red-themed page |
| `http://red.your-domain.com` | Red Server | Red-themed page |
| `http://blue.your-domain.com` | Blue Server | Blue-themed page |


![2025-06-25](https://github.com/user-attachments/assets/c226a6fb-c824-4ade-8a56-f4603cd60e47)



![2025-06-25 (11)](https://github.com/user-attachments/assets/36914ef6-e7b7-4f32-834a-0dc3bedc7c4a)


## 💰 Cost Estimation

**Monthly AWS costs (us-east-1):**
- 2 × EC2 t2.micro instances: ~$17.00
- Application Load Balancer: ~$22.00
- Route 53 hosted zone: $0.50
- Data transfer (minimal): ~$1.00

**Total: ~$40-45/month**

*💡 Tip: Use AWS Free Tier if eligible to significantly reduce costs*

## 🔒 Security Features

### Network Security
- **Security Groups**: Restrict access to necessary ports only
- **ALB Security Group**: HTTP/HTTPS from internet
- **EC2 Security Group**: HTTP from ALB only, SSH from your IP

### Access Control
- **IAM Roles**: EC2 instances use IAM roles instead of access keys
- **Least Privilege**: Minimal required permissions only

### Best Practices Implemented
- ✅ No hardcoded credentials
- ✅ Security groups with minimal required access
- ✅ Infrastructure versioning with Terraform state
- ✅ Separate environments possible with workspaces

## 🧪 Testing and Validation

### Automated Tests

```bash
# Test infrastructure deployment
terraform plan -detailed-exitcode

# Validate Terraform configuration
terraform validate

# Check resource health
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw red_target_group_arn)
```

### Manual Testing

```bash
# Test load balancer health
curl -I http://$(terraform output -raw load_balancer_dns)

# Test subdomain routing (after DNS propagation)
curl -H "Host: red.your-domain.com" http://$(terraform output -raw load_balancer_dns)
curl -H "Host: blue.your-domain.com" http://$(terraform output -raw load_balancer_dns)

# Test DNS resolution
dig your-domain.com
nslookup red.your-domain.com
```

## 🔧 Troubleshooting

### Common Issues

#### 1. "This site can't be reached"
**Symptoms**: Website not accessible via domain name
**Solutions**:
- Verify DNS propagation: `dig your-domain.com`
- Check name servers at domain registrar
- Clear browser DNS cache: `chrome://net-internals/#dns`
- Test with ALB DNS name directly

#### 2. Terraform State Lock
**Symptoms**: `Error acquiring the state lock`
**Solutions**:
```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID

# Or delete lock file if using local state
rm .terraform/terraform.tfstate
```

#### 3. Health Check Failures
**Symptoms**: Targets showing as unhealthy
**Solutions**:
```bash
# Check target health
aws elbv2 describe-target-health --target-group-arn TARGET_GROUP_ARN

# Verify security group rules
aws ec2 describe-security-groups --group-ids SECURITY_GROUP_ID

# Check EC2 instance logs
aws logs describe-log-streams --log-group-name /aws/ec2/user-data
```

### Debug Commands

```bash
# Get detailed Terraform output
terraform apply -auto-approve -input=false

# Check AWS resource status
aws ec2 describe-instances --filters "Name=tag:Name,Values=red-web-server"
aws elbv2 describe-load-balancers --names tovadel-academy-alb

# View security group rules
aws ec2 describe-security-groups --filters "Name=group-name,Values=tovadel-*"
```

## 📈 Scaling and Extensions

### Immediate Enhancements
- **HTTPS Support**: Add SSL/TLS certificates with AWS Certificate Manager
- **Auto Scaling**: Implement Auto Scaling Groups for dynamic capacity
- **Monitoring**: Add CloudWatch dashboards and alarms
- **Backup**: Configure automated EBS snapshots

### Advanced Extensions
- **CI/CD Pipeline**: Integrate with GitHub Actions or AWS CodePipeline
- **Container Migration**: Move to ECS or EKS
- **Database Layer**: Add RDS with Multi-AZ configuration
- **CDN**: Implement CloudFront for global content delivery
- **WAF**: Add Web Application Firewall for security

### Multi-Environment Setup

```bash
# Create separate environments using Terraform workspaces
terraform workspace new development
terraform workspace new staging
terraform workspace new production

# Deploy to specific environment
terraform workspace select development
terraform apply -var-file="environments/dev.tfvars"
```

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
# .github/workflows/terraform.yml
name: 'Terraform'
on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v3
      
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      
    - name: Terraform Init
      run: terraform init
      
    - name: Terraform Plan
      run: terraform plan
      
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve
```

## 🧹 Cleanup

To avoid ongoing AWS charges:

```bash
# Destroy all resources
terraform destroy

# Confirm deletion of all resources
aws ec2 describe-instances --filters "Name=tag:Name,Values=*-web-server"
aws elbv2 describe-load-balancers --names tovadel-academy-alb
```

**⚠️ Warning**: This will permanently delete all infrastructure. Ensure you have backups of any important data.

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines
- Follow Terraform best practices
- Include tests for new features
- Update documentation
- Ensure security compliance

## 📚 Learning Resources

### AWS Documentation
- [Application Load Balancer Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [Route 53 Developer Guide](https://docs.aws.amazon.com/route53/)
- [EC2 User Guide](https://docs.aws.amazon.com/ec2/)

### Terraform Resources
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [AWS Provider Examples](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples)

### Blog Posts and Tutorials
- [Medium Blog Post: Complete Implementation Guide](https://medium.com/@your-username/aws-multi-az-infrastructure)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [Terraform Learn](https://learn.hashicorp.com/terraform)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support and Questions

- **Issues**: [GitHub Issues](https://github.com/your-username/aws-multi-az-infrastructure/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/aws-multi-az-infrastructure/discussions)
- **Email**: your-email@example.com
- **LinkedIn**: [Your LinkedIn Profile](https://linkedin.com/in/your-profile)

## 🌟 Acknowledgments

- **Digital Cloud Training** for the excellent AWS tutorials
- **HashiCorp** for Terraform
- **AWS** for the amazing cloud platform
- **Community** for feedback and contributions

---

**⭐ If this project helped you, please give it a star on GitHub!**

**📝 Found this useful? Check out my [Medium blog]([https://medium.com/@your-username](https://medium.com/@osenat.alonge/building-production-ready-infrastructure-a-complete-guide-to-aws-multi-az-load-balanced-c5e62de256ef)) for more AWS and DevOps tutorials!**

---
** vist: website: www.tovadelacademy.co.uk**

*Built with ❤️ using Infrastructure as Code*
