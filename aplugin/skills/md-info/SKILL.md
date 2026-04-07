---
name: md-info
description: Get info about a markdown file — word count, line count, headers, and links. Use when the user asks to inspect or summarize a markdown file.
---

# md-info

Ask for the markdown file path if not already provided uin user input. Then execute:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/md-info/scripts/info.sh" "<md-path>"
```

Display the results to the user.
