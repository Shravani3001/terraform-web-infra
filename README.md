# 🛠️ Terraform + AWS Infrastructure Project

This project provides a complete AWS infrastructure using Terraform. It automates the deployment of a scalable and secure web application environment across public and private subnets using key AWS services.

---

## 📐 Architecture Overview

- ✅ **VPC** with public and private subnets across multiple Availability Zones.
- ✅ **Internet Gateway** for public subnet internet access.
- ✅ **NAT Gateway** to allow outbound access for private instances.
- ✅ **Application Load Balancer (ALB)** in public subnets.
- ✅ **Auto Scaling Group (ASG)** launching EC2 instances in private subnets.
- ✅ **Security Groups** to control traffic between Bastion, ALB, and EC2 instances.
- ✅ **User data script** installs and runs Nginx on EC2 instances.
- ✅ **Target Group + Health Checks** integrated with ALB to route traffic to healthy EC2s.

---

## 🧰 Tools & Services Used

- **Terraform**
- **AWS EC2**
- **AWS VPC**
- **AWS Subnets (Public + Private)**
- **Internet Gateway & NAT Gateway**
- **Security Groups**
- **Auto Scaling Group**
- **Application Load Balancer (ALB)**
- **Ubuntu AMI**
- **Nginx**

---

## ⚙️ How to Deploy

> 📝 Make sure you have AWS CLI configured and Terraform installed.

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name

2. **Initialize Terraform**
   ```bash
   terraform init

3. **Validate the Configuration**
   ```bash
   terraform validate

4. **Review the Execution Plan**
   ```bash
   terraform plan

4. **Apply the Infrastructure**
   ```bash
   terraform apply

6. **Verify Deployment**
   After a few minutes, open the Application Load Balancer DNS in your browser:
   http://<your-alb-dns-name>
   You should see the Nginx "Hello World" page.

✅ **Pre-requisites**
    - AWS account

    - IAM user with necessary permissions

    - AWS CLI configured

    - SSH key pair (if needed for Bastion access)

📝 **Notes**
    - The infrastructure is deployed in us-east-1 (you can update the region if needed).

    - EC2 instances in private subnets are automatically launched via Auto Scaling Group with user data to install Nginx.

    - No manual SSH is required when using ASG (unless debugging).

    - Ensure ALB and EC2 instance subnets are in enabled Availability Zones.

    - **To tear down everything**
    ```bash
    terraform destroy

**Author**
Shravani K
 - 🌐 LinkedIn: www.linkedin.com/in/shravani-k-25953828a
 - 💡 DevOps Learner
