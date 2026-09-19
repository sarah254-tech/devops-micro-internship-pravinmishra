# Assignment 1 — Set Up a Self-Hosted Linux Agent for Azure DevOps (Ubuntu + PAT)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, I set up a self-hosted Azure DevOps built agent on an Ubuntu VM (AWS or Azure), registered it with a Personal Access Token in a dedicated agent pool, ran it as a system service, and verified it by running a test pipeline.

---

# Task 1 — Create a Personal Access Token (PAT)

## Goal

Create a PAT with Agent Pools (Read & Manage) and Build (Read & Execute) scopes, and store it securely.

> No PAT value screenshot required. If you capture the token settings page, ensure the secret value is not visible.

---

# Task 2 — Create an Agent Pool

## Goal

Create a self-hosted agent pool (e.g. `SelfHostedPool`) in Azure DevOps Organization Settings.

### Evidence

#### Screenshot 1 — Azure DevOps Agent Pools page showing the newly created pool

<![Image1](screenshots/Assignment1_task2.png)>

---

# Task 3 — Provision the Ubuntu VM

## Goal

Create an Ubuntu 22.04 (or latest) VM in AWS or Azure with SSH access, and confirm connectivity.

### Evidence

#### Screenshot 2 — Cloud console showing the running Ubuntu VM and its public IP or DNS name

<![Image2](screenshots/Assignment1_task3a.png)>

---

#### Screenshot 3 — Terminal showing a successful SSH login and Ubuntu version details

<![Image3](screenshots/Assignment1_task4b.png)>

---

# Task 4 — Install and Configure the Agent

## Goal

Download the Linux agent package, register it with your organization/pool/PAT via `config.sh`, and install/start it as a system service.

### Evidence

#### Screenshot 4 — Terminal showing successful agent configuration without exposing the PAT

<![Image4](screenshots/Assignment1_task4a.png)>

---

#### Screenshot 5 — Terminal showing the agent service running successfully

<![Image5](screenshots/Assignment1_task4b.png)>

---

# Task 5 — Verify the Setup

## Goal

Confirm the agent service is running and the agent shows as Online in the Azure DevOps agent pool.

### Evidence

#### Screenshot 6 — Agent Pool listing showing the registered agent online

<![Image6](screenshots/Assignment1_task2.png)>

---

# Task 6 — Run a Test Pipeline

## Goal

Create and run a YAML pipeline targeting the self-hosted pool, running `uname -a`, `whoami`, and `df -h` on the VM.

### Evidence

#### Screenshot 7 — Successful test pipeline run output in Azure DevOps showing the Linux commands

<![Image7](screenshots/Assignment1_task6a.png)>
<![Image7](screenshots/Assignment1_task6a-2.png)>
<![Image7](screenshots/Assignment1_task6a-3.png)>

---

### Notes

Note the cloud platform used, your Azure DevOps organization/project name, and the agent pool name. Describe any issue you faced and how you resolved it.

Cloud Platform: Microsoft Azure
Azure DevOps Organization: Sarahamadi20221
Azure DevOps Project: demo
Agent Pool: linux-hosted-agent

Issues Encountered and Resolutions

During the setup and testing of the self-hosted Azure DevOps Linux agent, I encountered a few issues.

1. Incorrect agent pool name in the YAML pipeline
I initially configured the pipeline with an incorrect agent pool name. As a result, the pipeline could not locate the intended self-hosted agent. I identified the correct pool name, linux-hosted-agent, updated the azure-pipelines.yml file, and committed the correction to the repository.

2. Self-hosted agent connection went offline unexpectedly
During testing, the connection between the Azure DevOps organization and the Ubuntu self-hosted agent went offline without my knowledge. This resulted in a failed pipeline run because Azure DevOps could not find an available agent to execute the job. I checked the agent status, restored the agent connection/service, and verified that the agent was back online in the linux-hosted-agent pool before running the pipeline again.

3. Pipeline queued because the agent was occupied
After correcting the pool configuration and reconnecting the agent, a previous pipeline job was still occupying the self-hosted agent. The new pipeline therefore remained queued with Azure DevOps reporting that all potential agents were running other requests. I identified the previous job in the agent pool, cancelled the unnecessary run, and allowed the corrected pipeline to use the available agent.

After resolving these issues, the self-hosted Ubuntu agent was successfully registered with Azure DevOps and used to execute the test pipeline containing uname -a, whoami, and df -h.

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not display the PAT, SSH private key, or other secrets in screenshots or logs

---

# Completion Checklist

- [✅] Task 1: PAT created with required scopes and stored securely
- [✅] Task 2: Self-hosted agent pool created (Screenshot 1)
- [✅] Task 3: Ubuntu VM provisioned and SSH verified (Screenshots 2–3)
- [✅] Task 4: Agent installed, registered, and running as a service (Screenshots 4–5)
- [✅] Task 5: Agent verified Online (Screenshot 6)
- [✅] Task 6: Test pipeline run successfully (Screenshot 7)
- [✅] Platform/org/pool details and issue notes written (Notes)
- [✅] No secrets exposed

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
