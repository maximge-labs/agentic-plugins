---
name: uspecs
description: Run uspecs commands
disable-model-invocation: true
---

# uspecs

## Available scripts

- **`scripts/uspecs.sh`** — Main entry point for executing uspecs commands

## Execution instructions

- Parse user input as {action} [options] {other-input} like `uc2 --no-impl here is some prompt`
- run `bash scripts/uspecs.sh action {action} {options}` and follow the instructions in the output how to process {other-input}
  - Do not pass {other-input} verbatim to the command
- Available commands: uchange, archive
- For uchange command
  - {other-input} contains description of change request
  - Determine `kebab-name` from the {other-input}: kebab-case, max 40 chars (ideal 15-30), descriptive, safe to use as a git branch name
    - Should be passed as --kebab-name option to the command, for example `uchange --kebab-name add-user-authentication`
  - If {other-input} contains URL add --issue-url {URL} option to the command, for example `uc2 --issue-url https://example.com`


