# Terraform + AWS Infrastructure Project

This project provides a complete AWS infrastructure using Terraform. It automates the deployment of a scalable and secure web application environment across public and private subnets using key AWS services.

---

## Project Overview

- ✅ **VPC** with public and private subnets across multiple Availability Zones.
- ✅ **Internet Gateway** for public subnet internet access.
- ✅ **NAT Gateway** to allow outbound access for private instances.
- ✅ **Application Load Balancer (ALB)** in public subnets.
- ✅ **Auto Scaling Group (ASG)** launching EC2 instances in private subnets.
- ✅ **Security Groups** to control traffic between Bastion, ALB, and EC2 instances.
- ✅ **User data script** installs and runs Nginx on EC2 instances.
- ✅ **Target Group + Health Checks** integrated with ALB to route traffic to healthy EC2s.

---

## Tools & Services Used

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

✅ **Pre-requisites**

    - AWS account

    - IAM user with necessary permissions

    - AWS CLI configured

    - SSH key pair (if needed for Bastion access)

---

## How It Works

This project automates the deployment of a secure and scalable web application infrastructure on AWS using Terraform. Here’s a high-level breakdown of how it works:

- Terraform provisions the entire AWS infrastructure — including networking components, compute resources, and load balancers.

- A custom VPC is created with both public and private subnets across multiple availability zones for high availability.

- An Application Load Balancer (ALB) is placed in public subnets to distribute traffic to EC2 instances running inside an Auto Scaling Group (ASG) located in private subnets.

- The ASG launches EC2 instances in the private subnets with a user data script that installs Nginx and serves a sample HTML page.

- The NAT Gateway enables private instances to access the internet for package downloads (like Nginx) without exposing them directly.

- Security Groups ensure secure traffic flow between components (ALB → EC2, etc.).

- You access the web app via the ALB DNS, which routes traffic only to healthy instances using target group health checks.

## Features

- End-to-End Automated Deployment using Terraform

- Highly Available Infrastructure across multiple Availability Zones

- Private Subnet for EC2 Instances — isolated from direct internet exposure

- Application Load Balancer with health checks and target groups

- Auto Scaling Group for automatic horizontal scaling

- User Data Script to install and configure Nginx

- Security Groups enforcing least-privilege access between resources

- Easy Teardown with terraform destroy

## Project Structure
```bash
terraform-web-infra/
├── main.tf                
├── variables.tf           
├── outputs.tf             
├── terraform.tfvars       
├── .gitignore
└── README.md              
```

## Architecture diagram 

<img width="783" height="734" alt="Architecture-diagram" src="https://github.com/user-attachments/assets/d0774026-14f2-49d0-b202-602e20cc32ca" />


## How to Deploy

> Make sure you have AWS CLI configured and Terraform installed.

**1. Clone the Repository**
```bash
git clone https://github.com/Shravani3001/terraform-web-infra.git
cd terraform-web-infra
```

**2. Initialize Terraform**
```bash
terraform init
```

**3. Validate the Configuration**
```bash
terraform validate
```

**4. Preview the Execution Plan**
```bash
terraform plan
```

**5. Apply the Infrastructure**
```bash
terraform apply
```

**6. Verify Deployment**
After a few minutes, open the Application Load Balancer DNS in your browser:
```bash
http://your-alb-dns-name
```

You should see the Nginx "Hello World" page.

<img width="1813" height="493" alt="terraform-web-infra-output" src="https://github.com/user-attachments/assets/a520d94e-ec78-4667-a426-e34c400fb6c7" />


**Notes**
- The infrastructure is deployed in us-east-1 (you can update the region if needed).
- EC2 instances in private subnets are automatically launched via Auto Scaling Group with user data to install Nginx.
- No manual SSH is required when using ASG (unless debugging).
- Ensure ALB and EC2 instance subnets are in enabled Availability Zones.
    
**7. To tear down everything**
```bash
terraform destroy
```

## About Me

I'm **Shravani**, a self-taught and project-driven DevOps engineer passionate about building scalable infrastructure and automating complex workflows.

I love solving real-world problems with tools like Terraform, Ansible, Docker, Jenkins, and AWS — and I’m always learning something new to sharpen my edge in DevOps.

**Connect with me:**

- LinkedIn: www.linkedin.com/in/shravani3001
- GitHub: https://github.com/Shravani3001
