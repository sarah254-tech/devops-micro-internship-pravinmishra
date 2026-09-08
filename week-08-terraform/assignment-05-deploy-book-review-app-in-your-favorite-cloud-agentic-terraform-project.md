# Capstone Assignment — Deploy the Book Review App Using Terraform and Claude Code Agentic AI

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Student Details

**Full Name:** Sarah Wambui Amadi 
**Cloud Platform:** AWS 
**GitHub Repository URL:** https://github.com/sarah254-tech  
**Public Application URL / Load-Balancer DNS:** http://book-review-public-alb-173017032.us-east-1.elb.amazonaws.com/

---

## Purpose

I deployed the Book Review App using Terraform on AWS in a secure, highly available, production-style three-tier architecture. Use Claude Code, specialized subagents, Terraform MCP, and validation hooks to support the engineering workflow while keeping all infrastructure-changing operations under human control.

---

# Task 0 — Prepare the Project and Agentic AI Environment

## Goal

Prepare the Book Review App project and configure the provided Claude Code Agentic AI starter kit with project context, specialized subagents, Terraform MCP, validation hooks, and safety guardrails.

## Evidence

### Screenshot 1 — Project `CLAUDE.md`

Add a screenshot of the project `CLAUDE.md` showing the three-tier architecture, security boundaries, Terraform requirements, and human-approval rules.

<![Image1](screenshots/Assignment5_task0-1a.png)>
<![Image1](screenshots/Assignment5_task0-1b.png)>
<![Image1](screenshots/Assignment5_task0-1c.png)>
<![Image1](screenshots/Assignment5_task0-1d.png)>
<![Image1](screenshots/Assignment5_task0-1e.png)>
<![Image1](screenshots/Assignment5_task0-1f.png)>
<![Image1](screenshots/Assignment5_task0-1g.png)>

---

### Screenshot 2 — Terraform Engineer Subagent

Add a screenshot showing the Terraform Engineer subagent configuration.

<![Image2](screenshots/Assignment5_task0-2a.png)>
<![Image2](screenshots/Assignment5_task0-2b.png)>
<![Image2](screenshots/Assignment5_task0-2c.png)>

---

### Screenshot 3 — Architecture and Security Reviewer Subagent

Add a screenshot showing the Architecture and Security Reviewer subagent configuration.

<![Image3](screenshots/Assignment5_task0-3a.png)>
<![Image3](screenshots/Assignment5_task0-3b.png)>
<![Image3](screenshots/Assignment5_task0-3c.png)>
<![Image3](screenshots/Assignment5_task0-3d.png)>

---

### Screenshot 4 — Terraform MCP Connection

Add a screenshot showing Terraform MCP connected and available.

<![Image4](screenshots/Assignment5_task0-4.png)>

---

### Screenshot 5 — Validation Hooks

Add a screenshot showing the configured Claude Code validation hooks.

<![Image5](screenshots/Assignment5_task0-5a.png)>
<![Image5](screenshots/Assignment5_task0-5b.png)>

---

# Task 1 — Design the Three-Tier Architecture

## Goal

Design the required secure, highly available three-tier architecture and create an architecture diagram before building the infrastructure.

The diagram must show:

- VPC or VNet
- Availability Zones or equivalent availability locations
- Six subnets
- Internet connectivity
- NAT or outbound design
- Public load balancer
- Web Tier
- Internal load balancer
- Application Tier
- Managed MySQL
- Read replica
- Main traffic flow

## Architecture Diagram

                    INTERNET
                       │
                       ▼
             ┌───────────────────┐
             │   Internet        │
             │   Gateway (IGW)   │
             └─────────┬─────────┘
                       │
                       ▼
          ┌──────────────────────────┐
          │ PUBLIC APPLICATION ALB   │
          │ Internet-facing          │
          │ HTTP/HTTPS               │
          └────────────┬─────────────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
       ┌─────────────┐   ┌─────────────┐
       │ Web EC2 #1  │   │ Web EC2 #2  │
       │ AZ-A        │   │ AZ-B        │
       │ Nginx       │   │ Nginx       │
       └──────┬──────┘   └──────┬──────┘
              │                 │
              └────────┬────────┘
                       │
                       ▼
          ┌──────────────────────────┐
          │ INTERNAL APPLICATION ALB │
          │ Private                  │
          │ Port 3001                │
          └────────────┬─────────────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
       ┌─────────────┐   ┌─────────────┐
       │ App EC2 #1  │   │ App EC2 #2  │
       │ AZ-A        │   │ AZ-B        │
       │ Node/Express│   │ Node/Express│
       └──────┬──────┘   └──────┬──────┘
              │                 │
              └────────┬────────┘
                       │
                       │ MySQL :3306
                       ▼
              ┌──────────────────┐
              │   RDS MySQL      │
              │   Primary        │
              │   Private        │
              └────────┬─────────┘
                       │
                 Replication
                       │
                       ▼
              ┌──────────────────┐
              │   RDS Read       │
              │   Replica        │
              │   Private        │
              └──────────────────┘

---

# Task 2 — Build the Terraform Networking and Security Layers

## Goal

Create the modular Terraform project and implement the network and security layers across the required public and private subnets.

## Evidence

### Screenshot 6 — Modular Terraform Project Structure

Add a screenshot showing the modular Terraform project structure.

<![Image6](screenshots/Assignment5_task2a.png)>

---

### Screenshot 7 — Six-Subnet Architecture

Add a screenshot showing the six-subnet architecture across two availability locations.

<![Image7](screenshots/Assignment5_task2b.png)>

---

### Screenshot 8 — Public and Private Tier Separation

Add a screenshot showing the public and private tier separation, including routing and security boundaries.

<![Image8](screenshots/Assignment5_task2c-1.png)>
<![Image8](screenshots/Assignment5_task2c-2.png)>

---

# Task 3 — Build the Load-Balancing and Compute Layers

## Goal

Deploy the public and internal load balancers and the Web and Application compute resources required by the Book Review App.

## Evidence

### Screenshot 9 — Web and Application Compute

Add a screenshot showing the Web and Application compute resources in their required subnets.

<![Image9](screenshots/Assignment5_task3-1a.png)>
<![Image9](screenshots/Assignment5_task3-1b.png)>
<![Image9](screenshots/Assignment5_task3-1c.png)>
<![Image9](screenshots/Assignment5_task3-1d.png)>

---

### Screenshot 10 — Public Load Balancer

Add a screenshot showing the internet-facing public load balancer.

<![Image10](screenshots/Assignment5_task3-2.png)>

---

### Screenshot 11 — Internal Load Balancer

Add a screenshot showing the private internal load balancer.

<![Image11](screenshots/Assignment5_task3-3.png)>

---

### Screenshot 12 — Healthy Targets

Add a screenshot showing healthy target groups or backend pools.

<![Image12](screenshots/Assignment5_task3-4a.png)>
<![Image12](screenshots/Assignment5_task3-4b.png)>

---

# Task 4 — Build the Managed MySQL Database Layer

## Goal

Deploy a private, highly available managed MySQL database with a read replica and restrict database connectivity to the Application Tier.

## Evidence

### Screenshot 13 — Managed MySQL Database

Add a screenshot showing the managed MySQL database deployment.

<![Image13](screenshots/Assignment5_task4-1.png)>

---

### Screenshot 14 — High Availability

Add a screenshot showing the Multi-AZ or high-availability configuration.

       This was not possible because the free tier account din't allow for the multi-AZ selection. and so Single-AZ was used.

---

### Screenshot 15 — Read Replica

Add a screenshot showing the read replica configuration.

<![Image15](screenshots/Assignment5_task4-3.png)>

---

### Screenshot 16 — Private Database Access

Add a screenshot showing that the database is private and accepts MySQL traffic only from the Application Tier.

<![Image16](screenshots/Assignment5_task4-4.png)>

---

# Task 5 — Validate, Review, and Apply the Terraform Configuration

## Goal

Validate the Terraform configuration, review the execution plan using both Agentic AI and human judgment, and apply the infrastructure changes only after all required checks pass.

## Evidence

### Screenshot 17 — Terraform Validation

Add a screenshot showing successful `terraform validate` output.

<![Image17](screenshots/Assignment5_task5a.png)>

---

### Screenshot 18 — Terraform Plan

Add a screenshot showing the Terraform plan output.

<![Image18](screenshots/Assignment5_task5b.png)>

---

### Screenshot 19 — Terraform Apply

Add a screenshot showing successful `terraform apply` completion.

<![Image19](screenshots/Assignment5_task5c.png)>

---

# Task 6 — Deploy and Configure the Book Review Application

## Goal

Deploy and configure the Book Review App across the Web, Application, and Database tiers and verify the complete application functionality.

## Evidence

### Screenshot 20 — Homepage

Add a screenshot showing the Book Review App homepage through the public endpoint.

<![Image20](screenshots/Assignment5_task6a.png)>

---

### Screenshot 21 — Login or Authentication

Add a screenshot showing successful login or authentication.

<![Image21](screenshots/Assignment5_task6b.png)>

---

### Screenshot 22 — Book Data

Add a screenshot showing the book listing or book details.

<![Image22](screenshots/Assignment5_task6c.png)>

---

### Screenshot 23 — Review Functionality

Add a screenshot showing the review functionality working successfully.

<![Image23](screenshots/Assignment5_task6d.png)>

---

### Screenshot 24 — Backend or API Evidence

Add a screenshot showing that the backend or API is working successfully.

<![Image24](screenshots/Assignment5_task6e.png)>

---

### Screenshot 25 — Database Reads and Writes

Add a screenshot showing successful database reads and writes.

<![Image25](screenshots/Assignment5_task6f.png)>

## Public Application URL

**Public Application URL / DNS:** http://book-review-public-alb-173017032.us-east-1.elb.amazonaws.com/

---

# Task 7 — Demonstrate the Agentic AI Workflow

## Goal

Demonstrate how Claude Code assisted with Terraform generation, architecture and security review, and evidence-based troubleshooting while infrastructure-changing decisions remained under human control.

You do not need to submit your complete Claude Code conversation history. Include only focused evidence.

## Evidence

### Screenshot 26 — AI-Assisted Terraform Generation

Add a screenshot showing one useful example of AI-assisted Terraform generation or improvement.

<![Image28](screenshots/Assignment5_task7b.png)>

---

### Screenshot 27 — Architecture or Security Review

Add a screenshot showing one structured architecture or security review result.

<![Image27](screenshots/Assignment5_task7b.png)>

---

### Screenshot 28 — AI-Assisted Troubleshooting

Add a screenshot showing one AI-assisted troubleshooting interaction based on collected evidence.

<![Image28](screenshots/Assignment5_task7c-a.png)>
<![Image28](screenshots/Assignment5_task7c-b.png)>

---

# Task 8 — Complete the Final Architecture Review

## Goal

Review the completed infrastructure against the original capstone requirements and resolve significant architecture, security, reliability, and cost issues.

Confirm that the final review covers:

- Tier separation
- Availability
- Public exposure
- Routing
- Security rules
- Load balancing
- Database privacy
- Secrets
- Terraform quality
- Module structure
- Reliability
- Obvious cost risks

Use Screenshot 27 as the focused evidence for the structured architecture or security review.

---

# Task 9 — Answer the Reflection Questions

## Goal

Reflect on the architecture, Terraform implementation, and Agentic AI workflow. Answer each question briefly in your own words.

## Architecture

### 1. Why did you separate the Web, Application, and Database tiers?

       I separated the three tiers so that each layer has a clear responsibility and security boundary. The Web Tier handles user requests, the Application Tier handles business logic and API requests, and the Database Tier stores the application data. This makes the system easier to secure, troubleshoot, and scale.

### 2. Why is the Application Tier private?

       The Application Tier is private so users on the internet cannot connect directly to the backend servers. Requests reach the application through the internal load balancer, which limits access to the Web Tier and reduces the public attack surface.

### 3. Why is MySQL private?

       MySQL contains the application's persistent data, so it should not be directly accessible from the internet. I restricted port 3306 to the Application Tier security group, allowing only the backend servers to communicate with the database.

### 4. Why are multiple Availability Zones used?

       I used two Availability Zones so that the Web and Application tiers have instances in separate locations within the AWS region. If one Availability Zone has a problem, the other can continue serving traffic through the load balancers.

### 5. What is the difference between Multi-AZ/high availability and a read replica?

       Multi-AZ is mainly for availability and failover. A standby database can take over when the primary fails. A read replica is mainly for scaling read operations and can also provide a copy of the data in another Availability Zone. My architecture uses a Single-AZ primary with a cross-AZ read replica, so it does not provide the same automatic failover as an RDS Multi-AZ standby.

## Terraform

### 6. How did you divide your Terraform into modules?

       I divided the Terraform configuration according to the main infrastructure responsibilities. I created modules for networking, security, compute, load balancers, and database resources. This keeps the configuration organized and makes each part easier to manage and reuse.

### 7. How do the modules communicate through variables and outputs?

       The root Terraform configuration passes values into modules using variables. Modules then expose important resource information through outputs. For example, the network module provides subnet and VPC IDs, which are passed to the compute, security, load balancer, and database modules.

### 8. What did you specifically check in `terraform plan`?

       I checked what Terraform intended to add, change, or destroy before applying anything. I paid particular attention to unexpected resource destruction, security group changes, networking changes, database changes, and whether the planned resources matched the three-tier architecture. I also used the plan to confirm that changes were intentional before applying them.

## Agentic AI

### 9. What was the purpose of `CLAUDE.md`?

       CLAUDE.md gave Claude Code the project context and rules it needed to work consistently. I used it to describe the architecture, workflow, safety rules, and expected outputs so Claude could understand the project instead of treating every task as a completely new request.

### 10. What work did the Terraform Engineer subagent perform?

       The Terraform Engineer focused on the infrastructure implementation. It helped review and develop the Terraform configuration for the network, security groups, compute resources, load balancers, and database, while checking whether the configuration matched the required architecture.

### 11. What did the Architecture and Security Reviewer identify?

       The reviewer identified architecture, security, reliability, and cost considerations that needed attention. Important findings included the Single-AZ RDS primary, single NAT Gateway, HTTP-only public ALB, security boundaries, Terraform quality, and the exposed backend/.env secrets in the application repository.

### 12. Why did you use Terraform MCP instead of relying only on Claude's existing Terraform knowledge?

       I used Terraform MCP to give Claude access to Terraform-specific tooling and validation capabilities. This allowed the AI workflow to work with the actual Terraform project and validate configuration rather than relying only on general knowledge about Terraform.

### 13. What was the purpose of your validation hooks?

       The validation hooks were used as a safety check before infrastructure changes. They helped automatically verify Terraform formatting and configuration validity, reducing the chance of proceeding with an incorrectly formatted or invalid configuration.

### 14. Describe one real issue Claude helped you troubleshoot.

       One real issue was the database authentication failure on the Application Tier. The backend services initially could not authenticate to RDS. We traced the problem to a mismatch between the RDS password and the credential stored in SSM Parameter Store. After correcting the credentials, both application servers successfully connected to RDS.

       Another practical issue was the Nginx API routing problem. /api/books initially returned 404 even though the Internal ALB and backend were working. We identified the Nginx routing issue and changed the configuration to use location ^~ /api/, after which the API returned HTTP 200.

### 15. Describe one recommendation you reviewed, modified, or rejected instead of accepting blindly.

       I did not blindly implement the recommendation to use RDS Multi-AZ for the primary database. I reviewed the requirement against the project's Free Tier and cost limitations and chose a Single-AZ primary with a cross-AZ read replica instead. I documented that this provides a read replica but is not equivalent to automatic Multi-AZ failover. This was a deliberate, human-approved trade-off.

---

# Task 10 — Publish the Mandatory LinkedIn Post

## Goal

Publish a LinkedIn post describing the capstone, the technical work completed, the Agentic AI workflow, and the lessons learned.

Write the post in your own words, include at least one project image or other proof, and ensure that it can be viewed by the submission reviewer.

## LinkedIn Post URL

**LinkedIn Post URL:** https://www.linkedin.com/posts/sarah-w-amadi_dmibypravinmishra-devops-aws-share-7503172053236211712-reBL/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACAx4n8Bvuf305sZ28vfr5yvaoLLEr0SkSA

---

# Submission Instructions

- Complete Tasks 0–10 in sequence.
- Include all Screenshots 1–28 exactly as specified.
- Ensure that your full name is visible in the required screenshots.
- Include the selected cloud platform.
- Include the completed architecture diagram.
- Include the modular Terraform project structure.
- Include the working public application URL or public load-balancer DNS.
- Include all required Agentic AI workflow evidence.
- Answer all 15 reflection questions briefly in your own words.
- Include the published LinkedIn post URL.
- Do not expose cloud credentials, database passwords, SSH private keys, JWT secrets, access tokens, account IDs, Terraform state containing sensitive values, or other confidential information.
- Review all screenshots and project files carefully before submitting through GitHub.

---

# Completion Checklist

- [✅] Selected AWS or Azure
- [✅] Added and reviewed the Agentic AI starter files
- [✅] Configured `CLAUDE.md`
- [✅] Configured the Terraform Engineer subagent
- [✅] Configured the Architecture and Security Reviewer subagent
- [✅] Connected Terraform MCP
- [✅] Configured validation hooks and safety guardrails
- [✅] Created the architecture diagram
- [✅] Created the six-subnet design
- [✅] Configured public Web Tier routing
- [✅] Kept the Application Tier private
- [✅] Kept the Database Tier private
- [✅] Configured tier-specific Security Groups or NSGs
- [✅] Restricted backend port `3001`
- [✅] Restricted MySQL port `3306` to the Application Tier
- [✅] Created the public load balancer
- [✅] Created the internal load balancer
- [✅] Configured listeners and health checks
- [✅] Deployed the Web Tier compute resources
- [✅] Deployed the private Application Tier compute resources
- [✅] Provisioned private managed MySQL
- [✅] Configured Multi-AZ or high availability
- [✅] Configured a read replica
- [✅] Created the modular Terraform project
- [✅] Used variables, outputs, and module dependencies
- [✅] Used current Terraform documentation through MCP
- [✅] Used hooks for deterministic validation
- [✅] Completed `terraform fmt`
- [✅] Completed `terraform validate`
- [✅] Reviewed `terraform plan`
- [✅] Completed the Terraform Engineer review
- [✅] Completed the Architecture and Security review
- [✅] Applied the infrastructure only after human approval
- [✅] Deployed and configured the backend
- [✅] Deployed and configured the frontend
- [✅] Configured Nginx where required
- [✅] Configured the internal backend endpoint
- [✅] Configured the public frontend endpoint
- [✅] Verified the homepage
- [✅] Verified login or authentication
- [✅] Verified book data
- [✅] Verified review functionality
- [✅] Verified the backend API
- [✅] Verified database reads and writes
- [✅] Verified healthy load-balancer targets
- [✅] Included AI-assisted Terraform generation evidence
- [✅] Included one architecture or security review
- [✅] Included one AI-assisted troubleshooting example
- [✅] Completed the final architecture review
- [✅] Answered all 15 reflection questions
- [✅] Published the mandatory LinkedIn post
- [✅] Added the LinkedIn post URL
- [✅] Captured all 28 required screenshots
- [✅] Confirmed that my full name is visible in the required screenshots
- [✅] Checked that no secrets or sensitive information are exposed

---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory), focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations through hands-on experience.

---

## Resources

- Book Review App Repository: [https://github.com/pravinmishraaws/book-review-app](https://github.com/pravinmishraaws/book-review-app)
- DMI Official Website: [https://dmi.pravinmishra.com](https://dmi.pravinmishra.com)
- University: [https://university.pravinmishra.com](https://university.pravinmishra.com)
- Discord Community: [https://discord.pravinmishra.com](https://discord.pravinmishra.com)
- Blog: [https://dmi.pravinmishra.com/blog](https://dmi.pravinmishra.com/blog)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra on LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory on LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of the DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
