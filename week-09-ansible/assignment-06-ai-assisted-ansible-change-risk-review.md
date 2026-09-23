# Assignment 6 — AI-Assisted Ansible Change Risk Review

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, I built an AI-assisted Ansible risk-review workflow using `ansible-playbook --check --diff`, Bash scripting, and Claude Code.

I reviewed possible server changes before applying them, classified risky tasks, and kept the final apply decision under human control.

---

# Task 1 — Confirm EpicBook Connectivity and Create the Workspace

## Goal

Confirm that your previous EpicBook Ansible project is working before creating the risk-review automation.

### Evidence

#### Screenshot 1 — Output of `ansible web -i inventory.ini -m ping`

<![Image1](screenshots/Assignment6_task1a.png)>

---

#### Screenshot 2 — Output of `ansible-playbook -i inventory.ini site.yml --syntax-check`

<![Image2](screenshots/Assignment6_task1b.png)>

---

#### Screenshot 3 — Output of `pwd` and `find . -maxdepth 4 -type d | sort`

<![Image3](screenshots/Assignment6_task1c.png)>

---

### Notes

Answer the following in your own words:

**1. What proves that Ansible can reach your EpicBook VM?**

    The successful pong response from ansible web -i inventory.ini -m ping proves that Ansible can connect to the EpicBook VM and communicate with it successfully.

---

**2. Why should you confirm playbook syntax before building a risk-review script?**

    Syntax checking confirms that the Ansible playbook is correctly written before the risk-review script analyzes it. This helps prevent errors in the playbook from being mistaken for risk-review problems.

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` file that tells Claude Code how this project must behave.

### Evidence

#### Screenshot 4 — `CLAUDE.md` open in VS Code or terminal showing the safety rules

<![Image4](screenshots/Assignment6_task2a-1.png)>
<![Image4](screenshots/Assignment6_task2a-2.png)>
<![Image4](screenshots/Assignment6_task2a-3.png)>

---

### Notes

Answer the following in your own words:

**1. Why should Claude Code have project-specific safety rules?**

    Project-specific safety rules tell Claude Code what it is allowed and not allowed to do in this environment. They help keep the risk-review process controlled and prevent accidental changes to infrastructure.

---

**2. Why should the human run the real Ansible playbook manually?**

    The human should make the final decision because the real playbook can change the server. Human approval provides an additional safety check before changes are actually applied.

---

**3. Which rule prevents Claude Code from applying changes automatically?**
**
    The rule stating that, **Claude Code must not apply the real Ansible playbook**, prevents it from automatically making changes.

---

# Task 3 — Ask Claude Code to Plan the Risk Review

## Goal

Use Claude Code to produce a read-only plan before writing the Bash script.

### Evidence

#### Screenshot 5 — Claude Code showing the four-category risk-classification plan

<![Image5](screenshots/Assignment6_task3-1.png)>
<![Image5](screenshots/Assignment6_task3-2.png)>
<![Image5](screenshots/Assignment6_task3-3.png)>

---

### Notes

Answer the following in your own words:

**1. Which part of this task represents the Gather phase?**

    The Gather phase is collecting evidence from the Ansible project and the --check --diff dry run without applying any changes.

---

**2. Which part represents the Analyze phase?**

    The Analyze phase is reviewing the gathered evidence and classifying possible changes into the four risk categories.

---

**3. How did you verify Claude Code did not create or edit files?**

    I gave Claude Code an explicit read-only instruction and told it not to create, edit, or delete files. I also reviewed its output to confirm that it only produced an analysis and did not make project changes

---

# Task 4 — Build the Ansible Risk Review Script

## Goal

Create a Bash script that runs an Ansible dry run and classifies risky changes.

### Evidence

#### Screenshot 6 — Top section of `ansible-check-review.sh` showing `full_name`, `playbook_path`, `inventory_path`, and the `checks` array

<![Image6](screenshots/Assignment6_task4a.png)>

---

#### Screenshot 7 — Middle section showing `extract_changed_tasks` and `check_tasks_matching_pattern`

<![Image7](screenshots/Assignment6_task4b-1.png)>
<![Image7](screenshots/Assignment6_task4b-2.png)>

---

#### Screenshot 8 — Bottom section showing the loop, summary, and exit behavior

<![Image8](screenshots/Assignment6_task4c.png)>

---

#### Screenshot 9 — Output of `bash -n ansible-check-review.sh` and `ls -l ansible-check-review.sh`

<![Image9](screenshots/Assignment6_task4d.png)>

---

### Notes

Answer the following in your own words:

**1. What is stored in the `changed_tasks` array?**

    The changed_tasks array stores the names of Ansible tasks that the dry run reports as changes.

---

**2. Which function finds changed tasks from the Ansible output?**

    The extract_changed_tasks function finds and stores the changed tasks.

---

**3. Why does the script use `--check --diff`?**

    --check performs a dry run without applying the changes, while --diff shows the differences Ansible expects to make. Together, they provide evidence for reviewing potential changes before applying them.

---

**4. Why does the script use different exit codes for healthy, warning, and failed results?**

    Different exit codes allow the result to be understood automatically. A healthy review returns 0, detected changes return 1 for human review, and an Ansible failure returns 2

---

# Task 5 — Run the Baseline Dry-Run Review

## Goal

Run the script against your current EpicBook playbook and confirm the baseline risk status.

### Evidence

#### Screenshot 10 — Output of `./ansible-check-review.sh`

<![Image10](screenshots/Assignment6_task5a.png)>

---

#### Screenshot 11 — Output of `echo "Captured Exit Code: $script_exit_code"` and `cat reports/ansible-risk-report.txt`

<![Image11](screenshots/Assignment6_task5b.png)>

---

### Notes

Answer the following in your own words:

**1. What was the overall status of your baseline run?**

    The overall status of my baseline run was WARNING because the Ansible dry run detected three tasks that would make changes. Human review was therefore required before applying the changes.

---

**2. Did any tasks report `changed`?**

    Yes. The dry run detected three changed tasks:

        common : Update apt package cache
        epicbook : Configure EpicBook production database
        epicbook : Create EpicBook environment file

---

**3. Were any changed tasks flagged as risky?**

    Yes. The review classified the Update apt package cache task as a package/dependency risk and the Create EpicBook environment file task as a file, configuration, or permission risk. The production database configuration task was also identified as a configuration-related change requiring human review.

---

**4. What does the script exit code mean?**

    The exit code communicates the result of the review. 0 represents a healthy review, 1 indicates that changes were detected and require human review, and 2 indicates that the Ansible dry run failed.

---

# Task 6 — Create and Run the Claude Code Skill

## Goal

Turn the Bash script into a reusable Claude Code skill called `/ansible-risk-review`.

### Evidence

#### Screenshot 12 — `SKILL.md` showing the frontmatter, allowed tools, and safety rules

<![Image12](screenshots/Assignment6_task6a.png)>

---

#### Screenshot 13 — Claude Code output after running `/ansible-risk-review`

<![Image13](screenshots/Assignment6_task6b-1.png)>
<![Image13](screenshots/Assignment6_task6b-2.png)>

    The risk-review tool itself was tested, its false-negative was discovered by the AI review, the defect was corrected, and the workflow was then retested before a controlled risky change was introduced.

---

### Notes

Answer the following in your own words:

**1. Why does this skill allow `Bash`, `Read`, and `Grep`?**

    These tools allow the skill to run the read-only risk-review script and inspect project files and reports without giving it tools for editing files.

---

**2. Why does this skill not allow file editing?**

    File editing is not required for a risk review. Removing editing capability reduces the possibility of the AI making unintended project changes.

---

**3. What part is handled by Bash?**

    Bash runs the Ansible dry run, captures the output, identifies changed tasks, classifies risks, and generates the risk report

---

**4. What part is handled by Claude Code?**

    Claude Code interprets the evidence, explains the risks, organizes the findings into the required categories, and provides a human-readable risk assessment.

---

**5. Why is this better than asking Claude Code if the playbook is safe without giving it evidence?**

    The review is based on actual Ansible dry-run evidence rather than an assumption. This makes the risk assessment more objective and easier for a human operator to verify.

---

# Task 7 — Introduce a Controlled Risky Change and Let the Skill Catch It

## Goal

Add a small controlled risky change in your lab playbook and confirm the script and Claude Code catch it before applying.

### Evidence

#### Screenshot 14 — The added risky task inside the role file

<![Image14](screenshots/Assignment6_task7a.png)>

---

#### Screenshot 15 — Output of `./ansible-check-review.sh`

<![Image15](screenshots/Assignment6_task7b.png)>

---

#### Screenshot 16 — Claude Code `/ansible-risk-review` output showing the risky finding

<![Image16](screenshots/Assignment6_task7c.png)>


---

#### Screenshot 17 — Output of `cat reports/risky-change-report.txt`

<![Image17](screenshots/Assignment6_task7d.png)>

---

### Notes

Answer the following in your own words:

**1. Which risk category did the added task fall into?**

    The added Install cowsay package for controlled risk review task fell into the Package or dependency changes category because it would install a new package on the EpicBook VM.

---

**2. What evidence proves the task would change something?**

    The Ansible dry run reported changed=2 and specifically identified the cowsay task as changed. The dry-run evidence stated that a new cowsay package would be installed.

---

**3. Did Claude Code apply the playbook?**

    No. Claude Code only performed the read-only risk review. It explicitly stated that it had not and would not execute the real Ansible playbook. The final apply decision remained with the human operator.

---

**4. Why is it important that Claude Code only analyzed the risk?**

    The risk-review stage is intended to identify potential changes before they are applied. Keeping Claude Code in the analysis role prevents an AI-assisted review from directly changing the server without human approval.

---

**5. Which phase of the Agentic Loop is represented by the Bash report?**

    The Bash report primarily represents the Gather phase because it collects and records evidence from the Ansible dry run. Claude Code then uses that evidence during the Analyze phase.

---

# Task 8 — Apply as the Human, Verify, and Write the Change Summary

## Goal

Review the risky-change report, apply the playbook manually as the human operator, and verify the result.

### Evidence

#### Screenshot 18 — Output of the real playbook run showing the final recap with `failed=0`

<![Image18](screenshots/Assignment6_task8a.png)>

---

#### Screenshot 19 — Output of `ansible web -i inventory.ini -m ping`

<![Image19](screenshots/Assignment6_task8b.png)>

---

#### Screenshot 20 — Second `/ansible-risk-review` output after applying the change

<![Image20](screenshots/Assignment6_task8c.png)>

---

#### Screenshot 21 — Output of `ls -lah reports`

<![Image20](screenshots/Assignment6_task8d.png)>
---

#### Screenshot 22 — `change-summary.md` showing all required sections and your Full Name

<![Image22](screenshots/Assignment6_task8e-1.png)>
<![Image22](screenshots/Assignment6_task8e-2.png)>
<![Image22](screenshots/Assignment6_task8e-3.png)>


---

### Notes

Answer the following in your own words:

**1. What command did you run to apply the change for real?**

    I ran:

    ansible-playbook -i ansible/inventory.ini ansible/site.yml

---

**2. Who made the final decision to apply the playbook?**

    I, as the human operator, made the final decision to apply the playbook after reviewing the risk findings from the Bash script and Claude Code.

---

**3. What evidence proves the VM is still reachable?**

    The successful Ansible ping proves that the VM remained reachable after the change. The result returned ping: pong with changed: false.

---

**4. Why should the risk review be run again after applying?**

    The risk review should be run again after applying the change to verify that the intended change has converged and to identify any remaining unexpected changes. This provides the Verify phase of the Agentic Loop.

---

**5. What could go wrong if an AI agent applied Ansible changes automatically?**

    An AI agent could apply an unintended configuration, package, service, or application change without sufficient human review. This could cause service disruption, configuration errors, security problems, or unexpected changes to production resources. Keeping the final apply decision with a human provides an important safety control.

---

# LinkedIn Post Required

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://www.linkedin.com/posts/sarah-w-amadi_devops-ansible-agenticai-share-7505989718627581952-Nbqd/

---

#### Screenshot — Published LinkedIn post

<![Image-_linkedIn](screenshots/Assignment6_LinkedIn.png)>

---

# Required Files

Confirm that the following files are included in your GitHub repository or assignment folder:

- [✅] `CLAUDE.md`
- [✅] `ansible-check-review.sh`
- [✅] `.claude/skills/ansible-risk-review/SKILL.md`
- [✅] `reports/risky-change-report.txt`
- [✅] `reports/post-apply-report.txt`
- [✅] `change-summary.md`

---

# Submission Instructions

- Add all required screenshots in your submission.
- Full Name must be visible in required screenshots and reports.
- All required notes must be answered clearly.
- Do not expose SSH private keys, passwords, cloud credentials, database credentials, or secret environment variables.
- Add your GitHub repository or folder URL inside this document.

---

# Completion Checklist

- [✅] Task 1: EpicBook connectivity confirmed and workspace created
- [✅] Task 2: `CLAUDE.md` created with safety rules
- [✅] Task 3: Claude Code produced a read-only risk-review plan
- [✅] Task 4: `ansible-check-review.sh` created and syntax checked
- [✅] Task 5: Baseline dry-run review completed
- [✅]  Task 6: Claude Code `/ansible-risk-review` skill created and tested
- [✅] Task 7: Controlled risky change introduced and detected
- [✅] Task 8: Human applied the change and verified the result
- [✅] Risky-change report saved
- [✅] Post-apply report saved
- [✅] Change summary completed
- [✅] All screenshots added
- [✅] All notes answered
- [✅] LinkedIn post published
- [✅] LinkedIn post URL added
- [✅] No sensitive information exposed
- [✅] Google Doc is accessible

---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra and The CloudAdvisory, focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## Resources

- DMI Official Website: [https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme)
- University: [https://university.pravinmishra.com?utm_source=github&utm_medium=readme](https://university.pravinmishra.com?utm_source=github&utm_medium=readme)
- Discord Community: [https://discord.pravinmishra.com?utm_source=github&utm_medium=readme](https://discord.pravinmishra.com?utm_source=github&utm_medium=readme)
- Blog: [https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*