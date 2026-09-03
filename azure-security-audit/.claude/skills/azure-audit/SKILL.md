name: azure-audit
description: Run the read-only Azure security audit, analyze the report, and explain security findings and recommended human remediation.
allowed-tools:
  - Bash(./azure-audit.sh)
  - Bash(cat baseline-report.txt)
  - Bash(cat *.txt)
  - Read
---

# Azure Security Audit Skill

## Purpose

Run the existing read-only Azure security audit script and explain its findings.

## Safety Rules

- NEVER run a mutating Azure CLI command.
- NEVER run remediation commands.
- NEVER create, modify, delete, restart, stop, start, or reconfigure Azure resources.
- NEVER modify project files.
- NEVER claim a finding without evidence from the audit report.
- The human must review and execute all remediation commands.
- Do not expose passwords, secrets, private keys, connection strings,
  subscription IDs, or tenant IDs.

## Workflow

1. Run `./azure-audit.sh`.
2. Read the resulting audit output.
3. Identify every PASS, WARN, and FAIL.
4. Explain the evidence supporting each finding.
5. Explain the security risk.
6. Recommend a remediation for the human operator.
7. Do not execute the remediation.
8. Clearly distinguish evidence from recommendations.

## Output Format

For each check provide:

- Status
- Evidence
- Risk
- Recommended human remediation

Finish with an overall assessment.
