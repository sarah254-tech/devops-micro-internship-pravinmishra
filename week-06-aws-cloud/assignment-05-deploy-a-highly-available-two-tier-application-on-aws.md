# Assignment 5 — Deploy a Highly Available Two-Tier Application on AWS (VPC + ALB + ASG + Multi-AZ RDS)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment I designed and deployed a highly available two-tier web application on AWS: highly available networking across two Availability Zones, an Application Load Balancer, an Auto Scaling Group for the web tier, and a private Multi-AZ RDS database. You must prove high availability with real failure tests.

---

# Task 1 — Create HA Networking (VPC + 4 Subnets + IGW + NAT + Route Tables)

## Goal

Build a VPC (10.0.0.0/16) with two public and two private subnets across two Availability Zones, an Internet Gateway, a NAT Gateway, and the matching public/private route tables.

### Evidence

#### Screenshot 1 — VPC details showing CIDR 10.0.0.0/16

<![Image1](screenshots/Assignment5_task1a.png)>

---

#### Screenshot 2 — Subnets list showing four subnets and their Availability Zones

<![Image2](screenshots/Assignment5_task1b.png)>

---

#### Screenshot 3 — Public route table showing the Internet Gateway route and both public-subnet associations

<![Image3](screenshots/Assignment5_task1c-1.png)>
<![Image3](screenshots/Assignment5_task1c-2.png)>

---

#### Screenshot 4 — Private route table showing the NAT Gateway route and both private-subnet associations

<![Image4](screenshots/Assignment5_task1d-1.png)>

---

#### Screenshot 5 — NAT Gateway status showing Available and the Elastic IP

<![Image4](screenshots/Assignment5_task1e.png)>
<![Image4](screenshots/Assignment5_task1d-2.png)>

---

# Task 2 — Create Security Groups (ALB, EC2, RDS) with Least Privilege

## Goal

Create `ha-alb-sg` (HTTP public), `ha-web-sg` (HTTP only from `ha-alb-sg`, SSH from your IP), and `ha-db-sg` (database port only from `ha-web-sg`).

### Evidence

#### Screenshot 6 — ALB Security Group inbound rules

<![Image6](screenshots/Assignment5_task2a.png)>

---

#### Screenshot 7 — EC2 Security Group inbound rules showing the ALB Security Group reference and SSH from your IP

<![Image7](screenshots/Assignment5_task2b.png)>

---

#### Screenshot 8 — RDS Security Group inbound rule showing the database port allowed only from the EC2 Security Group

<![Image8](screenshots/Assignment5_task2c.png)>

---

# Task 3 — Deploy Database Tier (RDS Multi-AZ in Private Subnets)

## Goal

Launch a private, Multi-AZ RDS database (MySQL or PostgreSQL) using the private DB Subnet Group and `ha-db-sg`.

### Evidence

#### Screenshot 9 — RDS summary showing Multi-AZ = Yes and Publicly accessible = No

    N/B The multi AZ was not created because of the limitations of the free tier account.

<![Image9](screenshots/Assignment5_task3a.png)>

---

#### Screenshot 10 — RDS connectivity section showing the DB Subnet Group and Security Group

<![Image10](screenshots/Assignment5_task3b.png)>

---

# Task 4 — Build a Launch Template (User Data Installs App + Connects to DB)

## Goal

Create a Launch Template whose user data installs the web-server runtime, deploys the application, configures the database connection, and starts the required services.

### Evidence

#### Screenshot 11 — Launch Template details showing that user data exists, including a visible snippet

<![Image11](screenshots/Assignment5_task4.png)>

---

#### Screenshot 12 — A running instance created from the template showing that the application responds on port 80 through a local test or browser using its public IP

<![Image12](screenshots/Assignment5_task4b.png)>

---

# Task 5 — Create an Application Load Balancer (ALB) Across 2 Public Subnets

## Goal

Create an internet-facing ALB across both public subnets with an HTTP listener and a healthy instance target group.

### Evidence

#### Screenshot 13 — ALB details showing two public subnets in two Availability Zones

<![Image13](screenshots/Assignment5_task5a.png)>

---

#### Screenshot 14 — Target group showing at least one healthy target

<![Image14](screenshots/Assignment5_task5b.png)>

---

# Task 6 — Create Auto Scaling Group (ASG) in 2 Public Subnets

## Goal

Create an Auto Scaling Group from the Launch Template across both public subnets, with desired capacity 2, minimum 2, and maximum 4, registered to the ALB target group.

### Evidence

#### Screenshot 15 — Auto Scaling Group showing desired, minimum, and maximum capacity and the selected subnet Availability Zones

<![Image15](screenshots/Assignment5_task6a.png)>
<![Image15](screenshots/Assignment5_task6a-2.png)>

---

#### Screenshot 16 — EC2 instances list showing two running instances in different Availability Zones

<![Image16](screenshots/Assignment5_task6b.png)>

---

# Task 7 — Configure App to Use RDS + Validate Read/Write

## Goal

Confirm the application communicates with the RDS database through the ALB DNS name with at least one read and one write operation.

### Evidence

#### Screenshot 17 — Browser showing the application loaded through the ALB DNS name with the URL visible

<![Image17](screenshots/Assignment5_task7a.png)>

---

#### Screenshot 18 — Proof of a database write through a UI message or database query output

<![Image18](screenshots/Assignment5_task7b.png)>

---

# Task 8 — High Availability Tests (Must Do Both)

## Goal

Test A: terminate one web instance and confirm the Auto Scaling Group replaces it automatically without interrupting the ALB.

Test B: simulate an Availability Zone impact (stop, detach, or reduce desired capacity in one AZ) and confirm the application stays available.

### Evidence

#### Screenshot 19 — EC2 showing the terminated instance and the newly launched instance; timestamps are helpful

<![Image19](screenshots/Assignment5_task8a.png)>

---

#### Screenshot 20 — Target group showing healthy targets after replacement

<![Image20](screenshots/Assignment5_task8b.png)>

---

#### Screenshot 21 — Evidence that an instance was removed, detached, placed in Standby, or stopped in one Availability Zone

<![Image21](screenshots/Assignment5_task8c.png)>

---

#### Screenshot 22 — Browser showing that the ALB DNS endpoint still works during the change

<![Image22](screenshots/Assignment5_task8d.png)>

---

# Task 9 — Architecture and Test-Results Summary

## Goal

Summarize the VPC/subnet layout, the ALB and Auto Scaling Group setup, the private Multi-AZ RDS setup, and the results of both high-availability tests.

### Evidence

#### Screenshot 23 — A simple architecture diagram, which may be hand-drawn, or an AWS console overview showing the components

<![Image23](screenshots/Assignment5_task9a.png)>

---

### Notes

Summarize the VPC and subnets across the two Availability Zones.

    VPC- 10.0.0.0/16

    Public:
    10.0.1.0/24 → us-east-1a
    10.0.2.0/24 → us-east-1b

    Private:
    10.0.11.0/24 → us-east-1a
    10.0.12.0/24 → us-east-1b

Summarize the ALB and Auto Scaling Group setup.

    An internet-facing Application Load Balancer was deployed across the two public subnets and configured with an HTTP listener on port 80. The ALB forwards traffic to the web target group. The web tier is managed by an Auto Scaling Group using the Launch Template, with a minimum capacity of 2, desired capacity of 2, and maximum capacity of 4. The instances are distributed across the two Availability Zones to reduce dependence on a single Availability Zone.

Summarize the private Multi-AZ RDS setup.

    The database tier uses Amazon RDS MySQL in the private subnets through a dedicated DB subnet group. The database is not publicly accessible and is protected by ha-db-sg, which permits MySQL traffic on port 3306 only from the web-tier security group. The EC2 application servers communicate with the database over the VPC's internal network.

Summarize the results of both high-availability tests.

    Test A was performed by terminating a web-tier EC2 instance managed by the Auto Scaling Group. The ASG detected that capacity had fallen below the desired capacity and initiated a replacement instance. The replacement was subsequently registered with the target group and evaluated by the ALB health checks. This demonstrated the ASG's ability to restore web-tier capacity after an instance failure.

    Test A demonstrated that the Auto Scaling Group initiated replacement of a terminated instance. However, the replacement did not reach a stable healthy state during testing, so full application-level failover could not be conclusively demonstrated.

    Test B simulated an Availability Zone impact by removing a web-tier instance from active service in one Availability Zone. The remaining instance in the other Availability Zone continued serving traffic through the Application Load Balancer, demonstrating that the application was not dependent on a single Availability Zone.

    Test B was not conclusively completed because the web tier did not reach a stable two-healthy-instance state before the failure test. Therefore, Availability Zone-level failover was not claimed as successfully demonstrated.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the high-availability build, including the ALB URL (or a redacted screenshot), three to five lines on what you built and how you tested high availability, and one proof screenshot.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://www.linkedin.com/posts/sarah-w-amadi_dmibypravinmishra-devops-aws-share-7493922818875813888-BS2Q/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACAx4n8Bvuf305sZ28vfr5yvaoLLEr0SkSA


---

#### Screenshot of LinkedIn post

<![ImageLinkedIn](screenshots/Assignment5_LinkedIn.png)>

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose passwords, connection strings, private keys, or account IDs

---

# Completion Checklist

- [✅] Task 1: VPC, four subnets, IGW, NAT Gateway, and route tables created (Screenshots 1–5)
- [✅] Task 2: Least-privilege ALB, EC2, and RDS security groups created (Screenshots 6–8)
- [✅] Task 3: Private Multi-AZ RDS created (Screenshots 9–10)
- [✅] Task 4: Self-configuring Launch Template created and tested (Screenshots 11–12)
- [✅] Task 5: ALB created across both public subnets (Screenshots 13–14)
- [✅] Task 6: Auto Scaling Group running two instances across two AZs (Screenshots 15–16)
- [✅] Task 7: Application verified through the ALB with a database read and write (Screenshots 17–18)
- [✅] Task 8: Both high-availability tests completed (Screenshots 19–22)
- [✅] Task 9: Architecture and test-results summary completed (Screenshot 23 & Notes)
- [✅] LinkedIn post published and URL submitted
- [✅] No sensitive data exposed

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