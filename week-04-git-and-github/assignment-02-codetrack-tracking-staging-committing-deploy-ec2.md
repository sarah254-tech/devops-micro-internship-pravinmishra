# Assignment 2 — CodeTrack: Tracking, Staging, Committing + Deploy to EC2

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, I tracked and staged project files, created two meaningful Git commits in `CodeTrack`, verify my commit history, and deployed the CodeTrack static website to an EC2 instance using Nginx. This connects local version-control practice with a basic manual deployment workflow used in real DevOps environments.

---

# Task 1 — Verify Git Setup and Enter the Repository

## Goal

Confirm that Git works and that you are inside the correct `CodeTrack` repository.

### Evidence

#### Screenshot 1 — Output of `pwd` showing you're inside `CodeTrack`

<![Image1](screenshots/Assignment2_task1a.png)>

---

#### Screenshot 2 — Output of `git status` showing no "not a git repository" error

<![Image2](screenshots/Assignment2_task1b.png)>

---

# Task 2 — Create index.html and style.css

## Goal

Create the two starter UI files inside `CodeTrack`.

### Evidence

#### Screenshot 3 — Output of `ls` showing `index.html` and `style.css`

<![Image3](screenshots/Assignment2_task2.png)>

---

# Task 3 — Add Starter Content

## Goal

Copy the provided starter HTML and CSS content into your local `index.html` and `style.css` files.

### Evidence

#### Screenshot 4 — Your editor showing the contents of `index.html` and `style.css`

<![Image4](screenshots/Assignment2_task3.png)>

---

# Task 4 — Track and Stage Files Correctly

## Goal

Confirm both files show as untracked, then stage them individually with `git add`.

### Evidence

#### Screenshot 5 — Output of `git status` showing both files as untracked

<![Image5](screenshots/Assignment2_task4a.png)>

---

#### Screenshot 6 — Output of `git status` showing both files staged under "Changes to be committed"

<![Image6](screenshots/Assignment2_task4b.png)>

---

# Task 5 — Create the First Commit (Clean Initial Commit)

## Goal

Commit the staged starter files using the message `Initial UI scaffold: add index.html and style.css`, then check the log.

### Evidence

#### Screenshot 7 — Output of `git commit`

<![Image7](screenshots/Assignment2_task5a.png)>

---

#### Screenshot 8 — Output of `git log --oneline` showing the first commit

<![Image8](screenshots/Assignment2_task5b.png)>

---

# Task 6 — Modify index.html and Create a Second Commit

## Goal

Follow the instruction comment inside `index.html` to update the Student Name and Group Name, then commit that change separately using the message `Update homepage content: heading, tagline, CTA button`.

### Evidence

#### Screenshot 9 — Browser showing the updated page with your Student Name and Group Name visible

<![Image9](screenshots/Assignment2_task6a.png)>

---

#### Screenshot 10 — Output of `git status` showing `index.html` as modified

<![Image10](screenshots/Assignment2_task6b.png)>

---

#### Screenshot 11 — Output of `git commit`
<![Image11](screenshots/Assignment2_task6c.png)>

---

#### Screenshot 12 — Output of `git log --oneline` showing two commits

<![Image12](screenshots/Assignment2_task6d.png)>

---

# Task 7 — Deploy to EC2 with Nginx (Static Website)

## Goal

Install and start Nginx on your EC2 instance, then copy `index.html` and `style.css` into the Nginx web root.

### Evidence

#### Screenshot 13 — Output of `systemctl status nginx --no-pager` showing Nginx `active (running)`

<![Image13](screenshots/Assignment2_task7a.png)>

---

#### Screenshot 14 — Output of `curl -I http://localhost` showing `HTTP/1.1 200 OK`

<![Image14](screenshots/Assignment2_task7b.png)>

---

#### Screenshot 15 — Browser showing the CodeTrack site loaded at `http://<EC2_PUBLIC_IP>`, with your Full Name and Group Name visible

<![Image15](screenshots/Assignment2_task7c.png)>

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

https://www.linkedin.com/posts/sarah-w-amadi_dmibypravinmishra-learninginpublic-devops-share-7484852763256971265-TbuE/?utm_source=share&utm_medium=member_desktop&rcm=ACoAACAx4n8Bvuf305sZ28vfr5yvaoLLEr0SkSA

---

#### Screenshot — LinkedIn post showing the deployed CodeTrack application

<![LinkedInImage](screenshots/Assignment2_LinkedIn.png)>

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name and Group Name must be visible in the deployed application evidence
- `git log --oneline` output must show at least two meaningful commits
- Do not expose AWS access keys, passwords, private key contents, or other sensitive information

---

# Completion Checklist

- [✅] `CodeTrack` repository verified with `git status` (Screenshots 1–2)
- [✅] `index.html` and `style.css` created and populated (Screenshots 3–4)
- [✅] Starter files staged and committed in the first commit (Screenshots 5–8)
- [✅] Student Name and Group Name updated in `index.html` (Screenshot 9)
- [✅] Second controlled commit created (Screenshots 10–12)
- [✅] Nginx active on the EC2 instance and CodeTrack reachable via its public IP (Screenshots 13–15)
- [✅] LinkedIn post published and URL submitted
- [✅] No sensitive data exposed

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
