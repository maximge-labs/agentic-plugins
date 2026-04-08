---
name: shell-file-info
description: Analyze a shell script (.sh file) and report shell-specific metrics — shebang, line count, functions, comments, variables, pipes, sourced files, and top commands. Use when the user asks to inspect or get stats about a shell script.
---

# shell-file-info

Ask for the `.sh` file path if not already provided. Then execute:

```bash
bash scripts/info.sh <sh-file-path>
```

Display all returned fields to the user.
