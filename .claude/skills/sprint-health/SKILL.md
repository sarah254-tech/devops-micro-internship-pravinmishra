---
name: sprint-health
description: Reads the current active sprint via Jira MCP and produces a read-only triage report — velocity so far, at-risk stories, and items missing estimates. Never creates, edits, comments on, or transitions a Jira issue.
allowed-tools: mcp__jira__jira_search, mcp__jira__jira_get_issue, mcp__jira__jira_get_sprint, mcp__jira__jira_get_board, Read
disable-model-invocation: true
---