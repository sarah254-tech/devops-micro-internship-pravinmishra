# Assignment 4 — Building Your AI Team

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, I built and configured a set of specialized AI subagents inside my project. I learnt how different models and tool permissions define agent behavior, and triggered two real agent delegations to analyze security and cost aspects of my Terraform infrastructure.

---

# Task 1 — Create the Agents Folder and Add Files

## Goal

Create the `.claude/agents/` directory and add all required agent files.


### Evidence

#### Screenshot 1 — VS Code sidebar showing `.claude/agents/` with all 3 files

<![Image1](screenshots/Assignment4_task1.png)>

---

# Task 2 — Compare the Agent Configurations

## Goal

Analyze the configuration differences between the three agents and demonstrate understanding of model and tool selection.

### Written Answers

#### 1. Why does the cost optimizer use Haiku instead of Sonnet?

The Haiku LLM model is relatively fast, cost effective ,and preferrably better for tasks that do not require deep thinking.

---

#### 2. Why does the security auditor NOT have Write in its tools list?

 Security auditor is only intended to analyze and report,not to modify code.

---

#### 3. Why does the tf-writer use `inherit` instead of a specific model?

tf-writer uses the inherent moodel of the project to maintain consistency that matches the parent project, also it relys on shared context as it maintains a low configuration overhead. Lastly, because of the reduced cost and latency.

---

### Evidence

#### Screenshot 2 — `security-auditor.md` frontmatter showing model and tools configuration

<![Image2](screenshots/Assignment4_task2a.png)>

---

#### Screenshot 3 — `cost-optimizer.md` frontmatter showing the model and tools configuration

<![Image3](screenshots/Assignment4_task2b.png)>

---

# Task 3 — Run the Security Auditor

## Goal

Trigger the security auditor agent and analyzed the generated security report for my Terraform infrastructure.

### Evidence

#### Screenshot 4 — The delegation message showing Claude launched the security-auditor

<![Image4](screenshots/Assignment4_task3a.png)>

---

#### Screenshot 5 — Security audit report output

<![Image5](screenshots/Assignment4_task3b.png)>

---

# Task 4 — Run the Cost Optimizer

## Goal

Tigger the cost optimizer agent and reviewed the generated cost optimization report.

### Evidence

#### Screenshot 6 — The full cost optimization report

<![Image6](screenshots/Assignment4_task4.png)>

---

# Submission Instructions

- Ensure all agent files are committed in `.claude/agents/`
- Complete all written answers in your GitHub Repo
- Push final changes to your forked GitHub repository

---

## GitHub Repository URL

Paste your forked repository URL here:

`/https://github.com/sarah254-tech/Ultimate-Agentic-DevOps-with-Claude-Code/`

---

# Completion Checklist

- [✅ ] `.claude/agents/` folder contains all 3 agent files
- [✅ ] Screenshot 2 shows correct `security-auditor.md` configuration
- [✅ ] Screenshot 3 shows correct `cost-optimizer.md` configuration
- [✅ ] All 3 written answers completed 
- [✅ ] Security auditor executed successfully
- [✅ ] Cost optimizer executed successfully
- [✅ ] Security report is visible with findings
- [✅ ] Cost report is visible with recommendations
- [✅ ] All required screenshots added
- [✅ ] GitHub repo updated with agents

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*