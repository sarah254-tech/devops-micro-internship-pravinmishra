# Assignment 11 — AI-Assisted Kubernetes Incident Triage

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Configured a read-only Bash triage script for my Book Review App, connected it to Claude Code through `/k8s-triage`, simulated one controlled failure, recovered the application manually, and verified recovery.

**Workflow: Gather → Analyze → Human Act → Verify**

---

## Submission Details

**Full Name:** 	Sarah W Amadi

**Kubernetes Platform:** Azure Kubernetes Service (AKS)

**Selected Workload:** book-review-frontend (Deployment)

**Namespace:** book-review

**GitHub Repository URL:** https://github.com/sarah254-tech/book-review-app

**Simulated Incident:** Invalid container image resulting in ErrImagePull and ImagePullBackOff.

**Baseline Status:** HEALTHY. All 7 checks passed, with 0 warnings and 0 failures. Exit code: 0.

**Recovery Status:** HEALTHY. All 7 checks passed, with 0 warnings and 0 failures. Exit code: 0. The original frontend image was restored, and the workload successfully recovered.

---

# Task 1 — Discover the Application and Capture a Healthy Baseline

## Goal

Identify the actual application configuration and prove that the selected workload is healthy before incident simulation.

### Evidence

#### Screenshot 1 — Healthy Pods and ready Service backends

<![Image](screenshots/Assignment11_task1a.png)>



#### Screenshot 2 — Workspace directory structure

<![Image2](screenshots/Assignment11_task1b.png)>

### Notes

**1. What proves the selected Pods are ready, not merely running?**

The READY column in kubectl get pods shows whether the required containers in each Pod have passed their readiness checks. For example, 1/1 means one out of one containers is ready, while 2/2 means both containers are ready. Running alone only indicates that the Pod has been started; it does not guarantee that it is ready to serve traffic.

**2. What proves the Service has ready backends?**

The Kubernetes EndpointSlices show the IP addresses and ports of the ready endpoints associated with a Service. In this project, the EndpointSlices showed the frontend at 10.244.0.91:80 and the backend at 10.244.0.120:3001, confirming that both Services had ready backends.

**3. Why must the original image be recorded before incident simulation?**

Recording the original image provides a reliable reference for identifying what changed during the incident. It also helps ensure that the correct application image is restored during manual recovery, rather than accidentally deploying an incorrect or unintended version.

---

# Task 2 — Configure CLAUDE.md

## Goal

Define the project configuration, incident workflow, and safety boundary for Claude Code.

### Evidence

#### Screenshot 3 — CLAUDE.md showing application configuration, workflow, safety rules, and output rules

<![Image3](screenshots/Assignment11_task2.png)>


### Notes

**1. Why does Claude need project-specific cluster rules?**

Project-specific rules give Claude the correct Kubernetes context, including the namespace, application resources, original container images and investigation requirements. This helps it focus on the correct application and avoid making assumptions or suggesting actions that could affect unrelated resources. 

**2. Why must a human execute recovery commands?**

A human must execute recovery commands to maintain operational control and accountability. Claude can analyse evidence and recommend actions, but a human must review the recommendation, assess its impact and approve the recovery to prevent unintended changes to the cluster.

**3. Which rule prevents an unsupported diagnosis?**

The rule requiring Claude to base conclusions on collected evidence, distinguish observed facts from possible causes, and request additional evidence when information is insufficient prevents unsupported diagnoses.

---

# Task 3 — Plan the Read-Only Triage Workflow

## Goal

Ask Claude Code to explain the five health checks before running the supplied script.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check read-only plan

<![Image4](screenshots/Assignment11_task3-1.png)>
<![Image4](screenshots/Assignment11_task3-2.png)>
<![Image4](screenshots/Assignment11_task3-3.png)>
<![Image4](screenshots/Assignment11_task3-4.png)>

### Notes

**1. Which part represents the Gather phase?**

The five planned health checks represent the Gather phase: Pod discovery and status, container readiness, restart counts, Kubernetes events, and Service ready backends using EndpointSlices. These checks collect evidence about the application's health before any diagnosis or recovery action is considered.

**2. How did you verify that Claude did not change anything?**

Claude explicitly stated: "Plan only. I have not run any commands or created any scripts." It also presented read-only kubectl commands for the proposed checks and confirmed that no commands had been executed.

**3. Why is planning before coding useful for incident triage?**

Planning establishes what evidence needs to be collected, which commands are appropriate, and what healthy or unhealthy results look like. It prevents unnecessary commands, reduces the risk of accidental changes to the cluster, and gives the triage script a clear and structured design.

---

# Task 4 — Configure and Validate the Bash Script

## Goal

Configure the supplied triage script for the selected workload and validate its syntax.

### Evidence

#### Screenshot 5 — Script configuration variables and checks array

<![Image5](screenshots/Assignment11_task4a.png)>

---

#### Screenshot 6 — Functions for status, readiness, restarts, events, and Service backends

<![Image6](screenshots/Assignment11_task4b-1.png)>
<![Image6](screenshots/Assignment11_task4b-2.png)>
<![Image6](screenshots/Assignment11_task4b-3.png)>

---

#### Screenshot 7 — Preflight, summary, and exit-code logic

<![Image7](screenshots/Assignment11_task4c.png)>

---

#### Screenshot 8 — Successful syntax validation and executable permission

<![Image8](screenshots/Assignment11_task4d.png)>

### Notes

**1. Why must the script fail when no Pods match the configured selector?**

If no Pods match the configured selector, the script has no relevant application Pods to investigate. Reporting a healthy status in this situation would be misleading. It must report a failure so that a missing workload or incorrect selector can be investigated.

**2. How does the readiness check detect a running but unready Pod?**

The readiness check examines each container's ready status and the Pod's readiness condition. If a container reports false, the script identifies it as unready, even if the Pod phase is Running. This prevents the script from treating a running Pod as automatically healthy.

**3. Why are Service backends checked separately from Pod health?**

A Pod can be healthy and ready, but a Service may still have no ready backends because of an incorrect selector or endpoint configuration. Checking EndpointSlices separately confirms whether the Service has ready endpoints to receive traffic.

**4. What do exit codes 0, 1, and 2 represent?**

- 0: Triage completed without failed checks. Warnings may still exist.

- 1: One or more health checks failed.

- 2: Preflight validation failed, for example, because the Kubernetes context or namespace could not be accessed.

---

# Task 5 — Run the Healthy Baseline Report

## Goal

Run the script on the healthy application and confirm that it contains no failed checks.

### Evidence

#### Screenshot 9 — Baseline report showing your full name and all checks

<![Image9](screenshots/Assignment11_task5a-1.png)>
<![Image9](screenshots/Assignment11_task5a-2.png)>

---

#### Screenshot 10 — Captured exit code and final summary

<![Image10](screenshots/Assignment11_task5b.png)>

### Notes

**1. What is the baseline status?**

The baseline status is PASS (healthy). The triage script recorded 7 PASS checks, 0 WARN checks and 0 FAIL checks, with an exit code of 0. All discovered containers were ready, no container restarts were detected, and the three Services had ready backends.

**2. Which evidence proves the Service has a ready backend?**

The EndpointSlices output shows ready backend IP addresses and their corresponding ports:
- Frontend: 10.244.0.91:80
- Backend: 10.244.0.120:3001
- MySQL: 10.244.0.137:3306
The script confirmed one ready backend for each Service.

**3. What is the difference between a warning and a failure?**

A warning (WARN) indicates a condition that requires attention but does not necessarily mean the application is currently unavailable. For example, a container may have restarted previously but is now healthy.

A failure (FAIL) indicates that a required health check has not passed, such as a container being unready or a Service having no ready backends. It requires investigation and may affect application availability.

---

# Task 6 — Configure and Run the Claude Code Skill

## Goal

Connect the Bash script to a manually invoked Claude Code evidence-analysis workflow.

### Evidence

#### Screenshot 11 — SKILL.md showing frontmatter and safety rules

<![Image11](screenshots/Assignment11_task6a.png)>

---

#### Screenshot 12 — Baseline `/k8s-triage` analysis

<![Image12](screenshots/Assignment11_task6b.png)>

### Notes

**1. What does Bash do in this workflow?**

Bash executes the read-only Kubernetes triage script to collect factual evidence about the application's health. It checks Pod status, container readiness, restart counts, Kubernetes events and Service ready backends. It produces a structured report that can be analysed.

**2. What does Claude do in this workflow?**

Claude analyses the evidence collected by Bash, compares the results with the healthy baseline, identifies failed checks or warnings, and suggests likely causes and appropriate recovery actions. It also provides verification steps after recovery. Claude recommends actions but does not execute them.

**3. Why are instructions alone insufficient to guarantee read-only access?**

Instructions guide Claude's behaviour but do not technically prevent it from executing commands that modify Kubernetes resources. Additional safeguards, such as restricting permissions, reviewing commands and requiring human approval, are necessary to enforce read-only operation. Human supervision remains essential.

---

# Task 7 — Simulate One Controlled Incident

## Goal

Create one controlled failure, save its evidence, and let Claude analyze it without executing recovery.

### Evidence

#### Screenshot 13 — Failed or unready Pod evidence and current Service backends

<![Image13](screenshots/Assignment11_task7a.png)>

---

#### Screenshot 14 — Failed `/k8s-triage` analysis with evidence and a suggested manual recovery command

<![Image14](screenshots/Assignment11_task7b-1.png)>
<![Image14](screenshots/Assignment11_task7b-2.png)>
<![Image14](screenshots/Assignment11_task7b-3.png)>
<![Image14](screenshots/Assignment11_task7b-4.png)>

---

#### Screenshot 15 — Saved `incident-failure-report.txt`

<![Image15](screenshots/Assignment11_task7c-1.png)>
<![Image15](screenshots/Assignment11_task7c-2.png)>
<![Image15](screenshots/Assignment11_task7c-3.png)>

### Notes

**1. Which failure did you choose?**

I chose an invalid container image failure (ImagePullBackOff) by changing the frontend Deployment's Next.js image from the original assignment10 image to a deliberately invalid image tag, assignment11-invalid-image.

**2. Which checks failed, and what evidence proved it?**

The container readiness check failed because the new frontend Pod was not ready. The evidence showed:
- New frontend Pod: 0/2 ImagePullBackOff.
- Kubernetes events reported ErrImagePull and ImagePullBackOff.
- The image registry returned NotFound for the invalid image tag.
- The startup probe also failed with HTTP 502.
The previous frontend Pod remained 2/2 Running.

**3. Did Claude execute recovery? Why is that important?**

No. Claude only analysed the collected evidence and recommended a recovery action. This is important because recovery must remain under human control to prevent unintended changes to Kubernetes resources and ensure that recommended actions are reviewed before execution.

**4. Why might the Service retain ready backends during the incident?**

The previous frontend Pod was still running and ready while Kubernetes attempted to create its replacement. Therefore, the Service could retain the previous healthy Pod as a ready backend even though the new Pod was failing. This demonstrates that a failed rollout does not necessarily mean that all application traffic is interrupted.

---

# Task 8 — Recover Manually and Verify

## Goal

Restore the healthy configuration yourself and verify recovery using a second triage report.

### Evidence

#### Screenshot 16 — Recovered Pods and ready Service backends

<![Image16](screenshots/Assignment11_task8a.png)>

---

#### Screenshot 17 — Recovered `/k8s-triage` analysis

<![Image17](screenshots/Assignment11_task8b.png)>

---

#### Screenshot 18 — Reports directory showing failure and recovery reports

<![Image18](screenshots/Assignment11_task8c.png)>


---

#### Screenshot 19 — `incident-summary.md` with all required sections

<![Image19](screenshots/Assignment11_task8d-1.png)>
<![Image19](screenshots/Assignment11_task8d-2.png)>

### Notes

**1. What manual recovery action did you execute?**

I manually restored the original frontend container image by updating the book-review-frontend Deployment from the invalid image tag to:

ghcr.io/sarah254-tech/book-review-frontend:assignment10

I then monitored the Kubernetes rollout to confirm that the Deployment was successfully updated.

**2. What proves the workload recovered?**

The following evidence confirms recovery:
- The frontend Deployment successfully rolled out.
- The frontend Pods returned to Running status.
- All frontend containers became ready.
- The original assignment10 image was restored.
- The frontend Service EndpointSlices showed ready backends.
- The recovery triage report returned an overall PASS with exit code 0.

**3. Why is the second triage run necessary?**

The second triage run collects fresh evidence after the manual recovery. It verifies whether the failed conditions have been resolved, confirms that the application has returned to a healthy state, and identifies any remaining warnings. Without this verification, we cannot confidently conclude that the recovery was successful.

**4. Why should AI not automatically restart every failing production workload?**

Not every failing workload has the same underlying cause. Automatically restarting workloads could cause service interruptions, data loss, repeated failures or disruption to healthy dependencies. AI may also misinterpret incomplete evidence. Human review ensures that recovery actions are appropriate, safe and authorised.

### Remaining WARN Results

Explain any WARN results remaining after recovery, or write “None.”

None, provided your recovery triage report confirms WARN: 0.

---

# Task 9 — Publish Your Kubernetes Incident-Triage Workflow on LinkedIn

## Goal

Share the incident-triage workflow you completed and explain the role of human control.

### Evidence

#### Screenshot 20 — Published LinkedIn post about your Kubernetes incident-triage workflow

<![Image20](screenshots/Assignment11_LinkedInPost.png)>

### LinkedIn Post URL

https://www.linkedin.com/posts/sarah-w-amadi_devops-agenticai-kubernetes-share-7529092108767551488-UTG4/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACAx4n8Bvuf305sZ28vfr5yvaoLLEr0SkSA

---

# Required Project Files

Include these files in your project repository:

- `CLAUDE.md`
- `lab-config.md`
- `scripts/k8s-triage.sh`
- `.claude/skills/k8s-triage/SKILL.md`
- `reports/incident-failure-report.txt`
- `reports/recovery-report.txt`
- `incident-summary.md`

Your `incident-summary.md` must contain:

1. Reported Symptom
2. Evidence Collected
3. Most Likely Cause
4. Human-Approved Recovery Action
5. Verification
6. Safety Decision
7. Agentic Loop Mapping

---

# Final Summary

## Evidence and Cause

Summarize the evidence and the supported cause of the incident.

Add your summary here.

## Manual Recovery

Describe the command or configuration change you performed.

Add your summary here.

## Verification

Explain how the recovery report and Kubernetes outputs confirmed recovery.

Add your summary here.

## Safety Decision

Explain how you kept Claude’s role limited to evidence gathering and analysis.

Add your summary here.

---

# Submission Instructions

- Include all 20 required screenshots under their corresponding Evidence sections.
- Complete all Notes questions in your own words.
- Include the required project files in your linked repository.
- Include your published LinkedIn post URL.
- Use clear, readable screenshots showing relevant commands, configuration, and outputs.
- Display your full name before taking required terminal screenshots.
- Preserve the failure report before recovery.
- Ensure the baseline and recovery reports contain no FAIL results.
- Explain any WARN results remaining after recovery.
- Review reports, logs, configuration records, and screenshots before publishing.
- Do not expose credentials, kubeconfig contents, tokens, certificates, JWT secrets, or confidential account information.

---

# Completion Checklist

- [ ] Confirmed the personal lab context
- [ ] Discovered and recorded application configuration
- [ ] Recorded the original working image
- [ ] Captured healthy Pods and ready Service backends (Screenshot 1)
- [ ] Created the workspace (Screenshot 2)
- [ ] Configured CLAUDE.md (Screenshot 3)
- [ ] Reviewed the five-check triage plan (Screenshot 4)
- [ ] Configured and reviewed the supplied script (Screenshots 5–7)
- [ ] Passed Bash syntax validation and set executable permission (Screenshot 8)
- [ ] Captured a baseline report with no FAIL (Screenshot 9)
- [ ] Captured the correct exit code (Screenshot 10)
- [ ] Configured and invoked `/k8s-triage` (Screenshots 11–12)
- [ ] Simulated one controlled incident manually (Screenshot 13)
- [ ] Reviewed Claude’s failed-state analysis (Screenshot 14)
- [ ] Saved failure evidence before recovery (Screenshot 15)
- [ ] Executed recovery manually and waited for rollout completion
- [ ] Confirmed recovered Pods and ready Service backends (Screenshot 16)
- [ ] Captured recovery analysis with no FAIL (Screenshot 17)
- [ ] Explained any remaining warnings
- [ ] Saved failure and recovery reports (Screenshot 18)
- [ ] Completed the seven-section incident summary (Screenshot 19)
- [ ] Answered all Notes questions
- [ ] Published the LinkedIn post (Screenshot 20)
- [ ] Included the LinkedIn post URL
- [ ] Included all required project files
- [ ] Checked that no sensitive information is exposed

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
