# agentic-plugins

A learning and experimentation playground for plugins and skills targeting agentic AI assistants (Claude, Auggie, etc.), structured to be dropped into a project and picked up automatically by the agent.

## Structure

Each plugin lives in its own directory and follows a simple convention:

```text
<plugin>/
  bin/script.sh       # main executable, receives env vars from the agent
  commands/<cmd>.md   # slash-command definitions (one file per command)
  skills/<skill>/     # optional reusable skills
    SKILL.md          # skill metadata and execution instructions
    scripts/          # scripts invoked by the skill
```

## Plugins

### aplugin

A general-purpose plugin with the following commands and skills:

commands:

- `run` — executes `script.sh aplugin run` and surfaces the output
- `ver` — reports the plugin version
- `inspect-md` — inspects a markdown file (word count, line count, headers, links)

skills:

- `md-info` — get stats about a markdown file
- `txt-info` — get stats about a plain text file (word count, line count, character count, top words)
- `pdf-processor` — extract text and metadata from a PDF
- `uspecs` — run uspecs commands (`uchange`, `archive`) for structured change management

### cplugin

A minimal companion plugin with `run` and `ver` commands.

## Version bumping

`bump.sh` generates a date-based version (`MMDD.H.M`), updates all version strings in tracked files, and commits + pushes.

```bash
bash bump.sh
```

## Links

### Skills

- [agentskills.io](https://agentskills.io/) — open standard for agent skills (SKILL.md)
- [Using scripts in skills](https://agentskills.io/skill-creation/using-scripts#using-scripts-in-skills)
- [Plugin examples with scripts](https://github.com/anthropics/skills)

### Claude Code

- [Create plugins](https://docs.anthropic.com/en/docs/claude-code/plugins) — skills, agents, hooks, MCP servers
- [Plugins reference](https://docs.anthropic.com/en/docs/claude-code/plugins-reference) — full schema and CLI reference
- [How to create custom skills](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)
- [Complete guide to building skills for Claude](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf)
- [Permissions](https://code.claude.com/docs/en/permissions)

### Auggie CLI

- [Plugins and marketplaces](https://docs.augmentcode.com/cli/plugins)

## Environment variables

The agent injects the following variables into plugin scripts at runtime:

- `CLAUDE_PROJECT_DIR` — root of the current project
- `CLAUDE_PLUGIN_ROOT` — root of the plugin directory
- `CLAUDE_PLUGIN_DATA` — plugin-specific data directory
