---
name: aws-audit
description: Run the read-only AWS security and cost audit and explain the findings.
allowed-tools:
  - Bash
  - Read
  - Grep
---

# AWS Audit Skill

## Purpose

Run the existing AWS audit script, read its report, and explain the
security and cost implications of the findings.

## Safety Rules

This skill is strictly read-only.

Never:
- create AWS resources
- modify AWS resources
- delete AWS resources
- authorize security group rules
- revoke security group rules
- terminate EC2 instances
- modify RDS instances
- delete S3 buckets
- change encryption settings

Never execute remediation commands.

If remediation is appropriate, explain the recommended command to the
human operator but do not execute it.

## Workflow

1. Run the existing audit script:
   `./scripts/aws-audit.sh`

2. Read:
   `reports/aws-audit-report.txt`

3. Analyze every finding.

4. Explain:
   - What was detected
   - Why it matters
   - Security risk
   - Potential cost implication
   - Recommended remediation

5. Never claim remediation has been completed unless the human operator
   performs it and a subsequent audit confirms the change.

## Evidence Rules

Only report findings supported by the audit report.

Do not invent AWS resources, security issues, costs, or remediation results.
