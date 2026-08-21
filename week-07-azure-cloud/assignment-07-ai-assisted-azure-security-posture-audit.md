# Assignment 7 — AI-Assisted Azure Security Posture Audit

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, I built a read-only Bash script that audits the Azure resources I deployed earlier this week — a virtual machine, a three-tier network with a Load Balancer, a Storage Account, and an Azure Database for MySQL server — for common security misconfigurations. I connected that script to Claude Code as a reusable `/azure-audit` skill that explains findings and recommends a fix without ever running it, then fix one real finding myself and proved the fix with a second audit run. This is the same read-only-evidence-then-human-fixes discipline from Week 3, now applied to Azure with the `az` CLI instead of Linux commands — and the cloud-agnostic counterpart to the AWS audit you built in Week 6.

---

# Task 1 — Confirm Your Resources and Create the Workspace

## Goal

Confirm your Azure CLI is authenticated and can see the VM, network, storage account, and MySQL server you built this week, then set up a workspace folder for the audit.

### Evidence

#### Screenshot 1 — `az account show` and `az vm list -d -o table` confirming your subscription and running VM (subscription ID partially blurred)

<![Image1](screenshots/Assignment7_task1.png)>

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` for this workspace that tells Claude what the audit covers and the safety rules it must follow: never run a mutating `az` command, never claim a finding without report evidence, and always let the human review and run any remediation.

### Evidence

#### Screenshot 2 — `CLAUDE.md` open in your editor showing the project overview, audit workflow, and safety rules

<![Image2](screenshots/Assignment7_task2a.png)>
<![Image2](screenshots/Assignment7_task2-b.png)>

---

# Task 3 — Use Agentic AI to Plan the Audit Before Writing the Script

## Goal

Ask Claude Code to read `CLAUDE.md` and propose a read-only, four-check audit plan (NSG rules open to `0.0.0.0/0` on port 22 or 3389, storage account public blob access, VM disk encryption status, and Azure Database for MySQL public network access) — without creating or editing any file yet.

### Evidence

#### Screenshot 3 — Claude Code showing the four-check plan, with no files created or modified

<![Image3](screenshots/Assignment7_task3.png)>

---

# Task 4 — Build the Azure Audit Bash Script

## Goal

Write a Bash script that runs the four checks from Task 3 using read-only `az` commands, writes a PASS/WARN/FAIL report with your Full Name, and exits with a different code for a healthy, warning, or failing result. Validate it with `bash -n` and make it executable.

### Evidence

#### Screenshot 4 — Your script open in your editor, showing the check functions and the `az` commands they call

<![Image4](screenshots/Assignment7_task4-a-1.png)>
<![Image4](screenshots/Assignment7_task4-a-2.png)>
<![Image4](screenshots/Assignment7_task4-a-3.png)>
<![Image4](screenshots/Assignment7_task4-a-4.png)>
<![Image4](screenshots/Assignment7_task4-a-5.png)>
<![Image4](screenshots/Assignment7_task4-a-6.png)>

---

#### Screenshot 5 — Output of `bash -n` (no syntax errors) and `ls -l` showing the script is executable

<![Image5](screenshots/Assignment7_task4b.png)>

---

# Task 5 — Run the Script and Review the Baseline Report

## Goal

Run the script against your live resources and read the report honestly, even if it shows a real finding — do not fix anything yet.

### Evidence

#### Screenshot 6 — Script output showing your Full Name and all four checks with a PASS, WARN, or FAIL result

<![Image6](screenshots/Assignment7_task5.png)>

---

# Task 6 — Create and Run the /azure-audit Skill

## Goal

Create a Claude Code skill restricted to read-only tools (no `Write`) that runs your script, reads the report, and explains every finding with the risk of leaving it unresolved — without ever running a remediation command itself.

### Evidence

#### Screenshot 7 — Your skill file's frontmatter showing `allowed-tools` without `Write`

<![Image7](screenshots/Assignment7_task6a.png)>

---

#### Screenshot 8 — `/azure-audit` output showing the baseline findings and Claude's explanation

<![Image8](screenshots/Assignment7_task6b.png)>

---

# Task 7 — Fix a Real Finding and Re-Verify

## Goal

Pick one WARN or FAIL finding (or deliberately open an NSG rule to port 22 from `0.0.0.0/0` if your baseline was already clean), save that failing report, run the remediation command yourself — scoped to your own IP, not left open — and confirm the second audit run shows it resolved.

### Evidence

#### Screenshot 9 — Saved report showing the original finding before the fix

<![Image9](screenshots/Assignment7_task7b-1.png)>
<![Image9](screenshots/Assignment7_task7b-2.png)>

---

#### Screenshot 10 — Terminal output of the remediation command you ran yourself

<![Image10](screenshots/Assignment7_task7c-1.png)>
<![Image10](screenshots/Assignment7_task7c-2.png)>

---

#### Screenshot 11 — Second `/azure-audit` run (or report) showing the finding resolved

<![Image11](screenshots/Assignment7_task7d.png)>

---

### Notes

Compare this assignment to the AWS audit you built in Week 6: which finding categories map to each other across the two clouds, and what stayed exactly the same about the workflow even though the `az`/`aws` commands are completely different?

## Notes: Azure Audit vs AWS Audit

### 🔄 Finding Categories That Map Across Both Clouds

* **Network exposure**

  * **AWS:** Checked security-group rules for unnecessarily open inbound access.
  * **Azure:** Checked NSG rules for SSH/RDP exposed to `0.0.0.0/0`.
  * **Same security principle:** Administrative ports should not be unnecessarily exposed to the Internet.

* **Public storage access**

  * **AWS:** Checked S3 bucket public-access configuration.
  * **Azure:** Checked whether Storage Accounts allow public blob access.
  * **Same security principle:** Cloud storage should not be publicly accessible unless there is a deliberate business requirement.

* **Encryption**

  * **AWS:** Checked encryption/security configuration for cloud resources such as storage/disks.
  * **Azure:** Checked VM OS disk encryption status.
  * **Same security principle:** Data at rest should be protected through appropriate encryption controls.

* **Database public exposure**

  * **AWS:** Database security was assessed in terms of network/public accessibility.
  * **Azure:** Checked whether Azure MySQL Flexible Server has public network access enabled.
  * **Same security principle:** Managed databases should remain private and accessible only from the application tier.

### 🔁 What Stayed Exactly the Same

The biggest similarity was **not the commands. It was the workflow.**

* **1. Gather evidence first**

  * AWS used `aws` CLI read-only commands.
  * Azure uses `az` CLI read-only commands.
  * In both cases, the script observes the environment rather than changing it.

* **2. Never assume a finding**

  * A resource is only reported as insecure when the CLI output provides evidence.
  * This was particularly important with Azure because there was **no Storage Account** in the resource group. Instead of inventing a problem, the audit reported it as inconclusive.

* **3. Separate detection from remediation**

  * The audit script only identifies the problem.
  * Claude explains the risk and recommends the fix.
  * **The human performs the actual remediation.**

* **4. Verify after the human fix**

  * The first audit establishes the baseline.
  * A real finding is corrected manually.
  * The audit is run again.
  * The second report provides evidence that the finding was resolved.

* **5. Keep AI on the safe side of the boundary**

  * Claude can **read, analyse and recommend**.
  * Claude does not execute destructive or mutating cloud commands.
  * The human remains responsible for changing the infrastructure.

### 💡 Main Lesson

The AWS and Azure implementations use completely different commands and resource names, but the **DevOps security discipline is cloud-agnostic**:

> **Gather → Analyse → Human Fix → Verify**

AWS taught me the security-audit pattern. Azure demonstrated that the same pattern can be transferred to another cloud provider without changing the underlying security mindset. The tools changed from `aws` to `az`, but the principles of **least privilege, read-only evidence gathering, human-controlled remediation, and independent verification** stayed exactly the same.


---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 11 required screenshots
- Do not expose your Azure subscription ID, tenant ID, client secrets, or connection strings

---

# Completion Checklist

- [✅] Task 1: Azure resources confirmed and workspace created (Screenshot 1)
- [✅] Task 2: `CLAUDE.md` created with project context and safety rules (Screenshot 2)
- [✅] Task 3: Claude produced a read-only four-check plan before any script existed (Screenshot 3)
- [✅] Task 4: Audit script built, syntax-checked, and executable (Screenshots 4–5)
- [✅] Task 5: Baseline audit run and reviewed honestly (Screenshot 6)
- [✅] Task 6: `/azure-audit` skill created with no `Write` permission and run successfully (Screenshots 7–8)
- [✅] Task 7: A real finding fixed by you (not Claude) and re-verified as resolved (Screenshots 9–11)
- [✅] Notes comparing this to the Week 6 AWS audit completed
- [✅] No subscription IDs, tenant IDs, or credentials exposed

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
