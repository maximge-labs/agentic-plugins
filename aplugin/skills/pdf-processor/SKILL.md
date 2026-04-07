---
name: pdf-processor
description: Extract text and metadata from a PDF file. Use when the user asks to read, process, or extract content from a PDF.
---

# pdf-processor

Ask for the PDF file path if not already provided. Then execute:

```bash
python "${CLAUDE_PLUGIN_ROOT}/skills/pdf-processor/scripts/process.py" "<pdf-path>"
```

Display the extracted text, page count, and metadata to the user.
