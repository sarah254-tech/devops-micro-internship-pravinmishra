# Assignment 1 — Create an Azure Virtual Machine using Terraform

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, I used Terraform to provision a complete Azure Virtual Machine environment, including a resource group, virtual network, subnet, public IP, network interface, and a Linux-based virtual machine. I set up and verified the required local tools, defined the infrastructure in Terraform, initialized the project, reviewed and applied the plan, verified the running VM through Azure CLI, capture the public IP output, and destroyed the resources after testing.

---

# Task 0 — Set Up and Verify the Terraform and Azure CLI Environment

## Goal

Prepare your local environment for Terraform deployment by installing Terraform, Azure CLI, and the HashiCorp Terraform extension in VS Code, signing in to your Azure account, and confirming that all required tools are working correctly.

### Evidence

#### Screenshot 1 — Terminal showing successful `terraform version` output

<![Image1](screenshots/Assignment1_task0-a.png)>

---

#### Screenshot 2 — Terminal showing successful `az version` output

<![Image2](screenshots/Assignment1_task0-b.png)>

---

#### Screenshot 3 — VS Code Extensions panel showing the HashiCorp Terraform extension installed and enabled

<![Image3](screenshots/Assignment1_task0-c.png)>

---

# Task 1 — Create a New Terraform Project and Define the Infrastructure

## Goal

Create a new Terraform project and define the complete Azure Virtual Machine environment in `main.tf` by using the official Terraform Registry documentation.

### Evidence

#### Screenshot 4 — VS Code showing the AzureRM provider configuration and resource group configuration in `main.tf`

<![Image4](screenshots/Assignment1_task1-a.png)>

---

#### Screenshot 5 — VS Code showing the Linux virtual machine configuration and public IP `output` block in `main.tf`. Ensure that the VM password is hidden or redacted

<![Image5](screenshots/Assignment1_task1-b.png)>

---

# Task 2 — Initialize Terraform

## Goal

Initialize the Terraform working directory and download the required provider components.

### Evidence

#### Screenshot 6 — Terminal showing the successful `terraform init` output

<![Image6](screenshots/Assignment1_task2-a.png)>

---

# Task 3 — Plan and Apply the Configuration

## Goal

Review the Terraform execution plan and provision the Azure resources.

### Evidence

#### Screenshot 7 — Terraform plan summary showing the proposed resources

<![Image7](screenshots/Assignment1_task3a.png)>

---

#### Screenshot 8 — Terraform apply output showing successful completion

<![Image8](screenshots/Assignment1_task3b.png)>

---

#### Screenshot 9 — Terraform output showing the public IP address of the VM

<![Image9](screenshots/Assignment1_task3c.png)>

### Question

VM Public IP Address: 20.228.211.144

### Question

VM Public IP Address: [Enter the public IP shown by terraform output]

---

# Task 4 — Verify the Deployment

## Goal

Confirm through Azure CLI that the virtual machine was created successfully and is currently running.

### Evidence

#### Screenshot 10 — Azure CLI output showing the deployed VM name and `VM running` status

<![Image10](screenshots/Assignment1_task4.png)>

---

# Task 5 — Destroy the Resources

## Goal

Remove all Azure resources created by Terraform after completing the deployment and verification.

### Evidence

#### Screenshot 11 — Terminal showing successful `terraform destroy` completion

<![Image11](screenshots/Assignment1_task5.png)>

---

# Submission Instructions

- Complete all tasks in sequence and include all required screenshots specified in Tasks 0–5.
- Do not expose passwords, keys, account IDs, or other sensitive information in screenshots.

---

# Completion Checklist

- Installed Terraform and verified it using `terraform version`
- Installed Azure CLI and verified it using `az version`
- Signed in to Azure using `az login`
- Confirmed the correct Azure subscription
- Installed and enabled the HashiCorp Terraform extension in VS Code
- Created the `terraform-azure-vm` project directory and `main.tf`
- Added the Terraform and AzureRM provider configuration
- Defined the resource group, virtual network, subnet, public IP, and network interface
- Defined the Linux virtual machine with username and password-based authentication
- Added the Terraform output for the VM public IP address
- Completed `terraform init` successfully
- Reviewed the Terraform execution plan using `terraform plan`
- Completed `terraform apply` successfully
- Captured and recorded the VM public IP using `terraform output`
- Verified that the VM is running using Azure CLI
- Completed `terraform destroy` successfully
- Captured all required screenshots
- Checked that no passwords, keys, account IDs, or other sensitive information are visible in the screenshots

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*