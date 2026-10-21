# Assignment 8 — AI-Assisted Docker Container Hardening Audit

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, I built a read-only Bash script that audits a running Docker container for common hardening gaps — running as root, missing health checks, unpinned image tags, privileged mode, and unnecessary exposed ports — then connect that script to Claude Code as a reusable `/docker-audit` skill. I ran the audit against my production-grade EpicBook stack, fixed what it found by editing the Dockerfile myself, rebuilt the image, and re-ran the audit to prove the fix worked. Claude analyzes evidence and recommends a fix; it never edits my Dockerfile or rebuilds the image itself.

---

# Target Container

**Target Container Name:** theepicbook-reverse-proxy-1

---

# Task 1 — Prepare the Audit Workspace

## Goal

Create an audit workspace and confirm that the supplied files are available.

### Evidence

#### Screenshot 1 — Audit Workspace Files

Add a terminal screenshot showing your full name and both supplied files:

```text
docker-audit.sh
SKILL.md
```

<![Image1](screenshots/Assignment8_task1.png)>

---

# Task 2 — Add the Docker Audit Skill to Claude Code

## Goal

Add the supplied `docker-audit` skill to Claude Code and confirm that it is available.

### Evidence

#### Screenshot 2 — Docker Audit Skill Available in Claude Code

Add a screenshot of Claude Code showing `docker-audit` in the available skill list.

<![Image2](screenshots/Assignment8_task2.png)>

---

# Task 3 — Validate the Audit Script

## Goal

Verify the audit script line endings, Bash syntax, and usage message.

### Evidence

#### Screenshot 3 — Script Validation

Add a terminal screenshot showing:

- LF line-ending check
- Successful `bash -n docker-audit.sh` validation
- Your full name
- The usage message displayed when the script runs without a container name

<![Image3](screenshots/Assignment8_task3.png)>

---

# Task 4 — Run the Initial Docker Security Audit

## Goal

Audit a running container and record the initial findings.

### Evidence

#### Screenshot 4 — Selected Target Container

Add a terminal screenshot showing:

- Your full name
- `docker ps`
- The audit command using the selected target container name

<![Image4](screenshots/Assignment8_task4.png)>

---

#### Screenshot 5 — Initial Audit Results

Add a terminal screenshot showing the initial Docker audit results.

<![Imag5](screenshots/Assignment8_task4b.png)>

---

# Task 5 — Use AI Assistance to Understand the Findings

## Goal

Use the supplied `docker-audit` skill to understand the initial audit results safely.

### Evidence

#### Screenshot 6 — Audit Explanation and Recommended Fix

Add a Claude Code screenshot showing:

- Audit finding
- Security risk
- Recommended manual fix
- Verification method

<![Imag6](screenshots/Assignment8_task5a.png)>
<![Imag6](screenshots/Assignment8_task5b.png)>
<![Imag6](screenshots/Assignment8_task5c.png)>

---

# Task 6 — Apply One Container-Hardening Fix

## Goal

Manually fix one WARN or FAIL finding from the initial audit.

### Evidence

#### Screenshot 7 — Hardening Configuration Change

Add a screenshot of the updated Dockerfile or `docker-compose.yml` showing the selected hardening fix.

<![Imag5](screenshots/Assignment8_task4b.png)>

---

#### Screenshot 8 — Updated Service Running

Add a terminal screenshot showing your full name and the rebuilt or recreated service/container running successfully.

<![Imag5](screenshots/Assignment8_task4b.png)>

---

# Task 7 — Re-Run the Audit and Compare Results

## Goal

Verify that the selected hardening fix improved the container configuration.

### Evidence

#### Screenshot 9 — Final Audit Results

Add a terminal screenshot showing:

- Your full name
- The updated running container
- The final audit report

<![Imag5](screenshots/Assignment8_task4b.png)>

---

### Before-and-After Comparison

Write a short comparison covering:

- Initial audit finding
- Dockerfile or Docker Compose change applied
- Final audit result
- Security benefit of the improvement


- **Initial audit finding:** The `theepicbook-reverse-proxy-1` container was configured to run as root by default. The audit also confirmed that privileged mode was disabled and a health check was configured.
- **Hardening change applied:** I manually changed the Nginx Dockerfile to use `nginxinc/nginx-unprivileged:alpine`, which runs as UID 101. I updated Nginx to listen on port 8080 and adjusted the Compose port mapping to `80:8080`. I also corrected the health-check URL and configured a dedicated log directory for the unprivileged container.
- **Final audit result:** The container was recreated and reached `healthy` status. A Claude Code audit subsequently identified the reverse proxy as running under UID 101. 
- **Security benefit:** Running Nginx as a non-root user reduces the privileges available to the process if it is compromised. Keeping the health check functional also helps Docker detect when the service is not responding as expected.

---

# LinkedIn Requirement

## Goal

Create a LinkedIn post about the container security checks you performed, one hardening improvement you applied, and why the improvement matters.

### Evidence

**LinkedIn Post URL:** https://www.linkedin.com/posts/sarah-w-amadi_devops-docker-containersecurity-share-7518611155045765120-mNnC/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACAx4n8Bvuf305sZ28vfr5yvaoLLEr0SkSA

#### LinkedIn Post Screenshot

Add a screenshot of the published LinkedIn post, including the final audit result.

<![Image_LinkedIn](screenshots/Assignment8_LinkedIn.png)>

---

# Submission Instructions

- Include Screenshots 1–9 exactly as specified.
- Include the target container name and before-and-after comparison.
- Include the LinkedIn post URL and screenshot.
- Ensure that your full name is visible in all required terminal screenshots.
- Do not expose passwords, API keys, tokens, account IDs, or `.env` file contents.

---

# Completion Checklist

- [ ] Audit workspace created and supplied files verified
- [ ] `docker-audit` skill added to Claude Code
- [ ] Audit script validated successfully
- [ ] Running target container identified
- [ ] Initial Docker audit completed
- [ ] Claude Code explanation of findings captured
- [ ] One hardening fix applied manually
- [ ] Affected service or container rebuilt and recreated
- [ ] Final Docker audit completed
- [ ] Before-and-after comparison completed
- [ ] Screenshots 1–9 included
- [ ] LinkedIn post URL and screenshot included
- [ ] No sensitive information exposed

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

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
