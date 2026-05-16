<div align="center">

# 🚀 Terraform AWS EC2 Web Server

<img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
<img src="https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white" />
<img src="https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" />
<img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />

<br/>

> **Automated provisioning of a production-ready EC2 web server on AWS using Terraform — with networking, security, and storage fully configured as code.**

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Resources Provisioned](#-resources-provisioned)
- [Prerequisites](#-prerequisites)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Configuration Reference](#-configuration-reference)
- [Security Notes](#-security-notes)
- [Contributing](#-contributing)

---

## 🌐 Overview

This project uses **Terraform** to provision a complete, ready-to-use EC2 web server on **AWS us-west-2 (Oregon)**. Everything is defined as Infrastructure as Code (IaC) — no manual console clicks required.

| Property | Value |
|---|---|
| ☁️ Cloud Provider | Amazon Web Services (AWS) |
| 🌍 Region | `us-west-2` (Oregon) |
| 🖥️ Instance Type | `t3.micro` |
| 💾 OS / AMI | Ubuntu (`ami-0d13e2317a7e75c95`) |
| 💽 Storage | 8 GB gp3 EBS Volume |
| 🔐 Access | SSH (Port 22) + HTTP (Port 80) |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                    AWS Cloud (us-west-2)             │
│                                                     │
│   ┌──────────────────────────────────────────────┐  │
│   │              Default VPC                     │  │
│   │                                              │  │
│   │   ┌─────────────────────────────────────┐   │  │
│   │   │         Security Group              │   │  │
│   │   │   ✅ Inbound  → Port 22  (SSH)      │   │  │
│   │   │   ✅ Inbound  → Port 80  (HTTP)     │   │  │
│   │   │   ✅ Outbound → All Traffic         │   │  │
│   │   │                                     │   │  │
│   │   │   ┌─────────────────────────────┐   │   │  │
│   │   │   │      EC2 Instance           │   │   │  │
│   │   │   │   t3.micro | Ubuntu         │   │   │  │
│   │   │   │   8 GB gp3 EBS Volume       │   │   │  │
│   │   │   │   Key Pair: deployer-key    │   │   │  │
│   │   │   └─────────────────────────────┘   │   │  │
│   │   └─────────────────────────────────────┘   │  │
│   └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
           ▲                    ▲
     SSH (Port 22)        HTTP (Port 80)
      Developer              Browser
```

---

## 📦 Resources Provisioned

| # | Resource | Name | Purpose |
|---|---|---|---|
| 1 | `aws_key_pair` | `deployer-key` | SSH key for secure instance access |
| 2 | `aws_default_vpc` | `Default VPC` | Networking foundation |
| 3 | `aws_security_group` | `web-security-group` | Firewall rules (SSH + HTTP) |
| 4 | `aws_instance` | `Terraform-Web-Server` | The EC2 web server instance |

---

## ✅ Prerequisites

Before you begin, make sure you have the following installed and configured:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.0`
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with valid credentials
- An AWS account with EC2 permissions
- An SSH key pair (public key ready to paste)

```bash
# Verify Terraform installation
terraform --version

# Verify AWS CLI is configured
aws sts get-caller-identity
```

---

## 📁 Project Structure

```
terraform-aws-ec2/
│
├── main.tf          # Core infrastructure (VPC, SG, EC2, Key Pair)
├── README.md        # You are here 📍
└── .gitignore       # Ignore .tfstate and sensitive files
```

> 💡 **Tip:** For larger projects, consider splitting into `variables.tf`, `outputs.tf`, and `providers.tf`.

---

## 🚀 Getting Started

Follow these steps to deploy the infrastructure:

### 1. Clone the Repository

```bash
git clone https://github.com/Muhammadgi/terraform-aws-ec2
cd terraform-aws-ec2
```

### 2. Add Your SSH Public Key

Open `main.tf` and replace the placeholder public key with your own:

```hcl
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 YOUR_ACTUAL_PUBLIC_KEY_HERE"
}
```

> 🔑 Generate a new key pair with: `ssh-keygen -t ed25519 -C "your-email@example.com"`

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Preview the Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm.

### 6. Connect to Your Server

Once provisioned, connect via SSH:

```bash
ssh -i ~/.ssh/your-private-key ubuntu@<EC2_PUBLIC_IP>
```

> 📌 Find your EC2 public IP in the AWS Console or add an `output` block to `main.tf`.

### 7. Destroy Resources (when done)

```bash
terraform destroy
```

---

## ⚙️ Configuration Reference

| Parameter | Value | Description |
|---|---|---|
| `region` | `us-west-2` | AWS region |
| `ami` | `ami-0d13e2317a7e75c95` | Ubuntu AMI (us-west-2) |
| `instance_type` | `t3.micro` | Compute size (~$0.0104/hr) |
| `volume_size` | `8 GB` | Root EBS volume |
| `volume_type` | `gp3` | General Purpose SSD (latest gen) |
| `ssh_port` | `22` | Remote access |
| `http_port` | `80` | Web traffic |

---

## 🔐 Security Notes

> ⚠️ **This configuration opens SSH and HTTP to `0.0.0.0/0` (all IPs).** This is fine for testing, but for production environments, consider the following:

- 🔒 **Restrict SSH** to your specific IP: `cidr_blocks = ["YOUR_IP/32"]`
- 🔒 **Add HTTPS** (Port 443) with an SSL certificate (AWS ACM + ALB)
- 🔒 **Use a private subnet** with a bastion host for production workloads
- 🔒 **Never commit** real private keys or AWS credentials to Git
- 🔒 **Add a `.gitignore`** to exclude `*.tfstate`, `*.tfstate.backup`, and `.terraform/`

**Recommended `.gitignore`:**
```
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
.terraform.lock.hcl
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-improvement`)
3. Commit your changes (`git commit -m 'Add some improvement'`)
4. Push to the branch (`git push origin feature/my-improvement`)
5. Open a Pull Request

---

<div align="center">

Made with ❤️ using Terraform & AWS

⭐ **Star this repo if you found it helpful!** ⭐

</div>
