# AGENTS — Tatin

**This folder is home. Treat it that way.**

## What This Is

**Tatin** = LLM agent sandbox
macOS **Tart** VM + **Vagrant** (`vagrant-tart`)
Provisions **Debian 13 dev env**.

**User:** `agent` (sudo privileges, no password required)
**Installed:** build-essential, git, jq, bun, python3, golang, tmux, zsh
**Agent tools:** Claude Code, Crush, OpenCode

## Requirements

* Tart — [https://tart.run](https://tart.run)
* Vagrant — [https://www.vagrantup.com](https://www.vagrantup.com)
* vagrant-tart — [https://github.com/letiemble/vagrant-tart](https://github.com/letiemble/vagrant-tart)

## VM Control

**Wrapper (`scripts/tatin.sh`)**

```bash
tatin up | down | delete | status
```

**Direct Vagrant**

```bash
vagrant up | halt | destroy -f | status | ssh | provision
```

## Layout

* `Vagrantfile` — VM definition
* `scripts/tatin.sh` — lifecycle wrapper (spinner + logging)


**No permission checks. Act.**

## Beads (Issues = Truth)

**Never use `bd edit` (interactive).**

```bash
bd ready
bd list --status=open
bd show <id>
bd create --title="..." --type=task --priority=2
bd update <id> --status=in_progress
bd close <id> [--reason="..."]
bd sync
```

**Types:** task bug feature epic question docs
**Priority:** P0–P4 (numeric only)
**Deps:** `bd dep add <id> <depends-on>`

## Work Pattern

1. `bd ready`
2. `bd update <id> --status=in_progress`
3. Do work
4. `bd close <id>`
5. `bd sync`

## Visual Rules (CLI)

* **NO emoji icons**
* **ONLY Unicode:** `○ ◐ ● ✓ ×`
* Priority format: `● P0`

## Safety

* Ask before destructive actions
* `trash` > `rm`
* Never exfiltrate private data

## Project context

`PROJECT.md` = name, stack, links, goals

## Tools

Skills/MCPs define tools → see `SKILL.md`
Local notes → `TOOLS.md`

## Session shutdown (NON-NEGOTIABLE)

**Work is incomplete until push succeeds.**

```bash
git pull --rebase
bd sync
git push
git status  # must be clean + up to date
```

**Rules**

- Never stop before push
- Never say “ready to push”
- Fix failures and retry until pushed

## Docs (authoritative)

- Use qmd to query Tart docs: `qmd query collection tart-docs "<query>"`
- Use qmd to query HashiCorp product docs: `qmd query collection hc-docs "<query>"`
- Use qmd to query Vagrant Tart provider docs: `qmd query collection vagrant-tart-docs "<query>"`

## Make it yours

Extend rules as you learn.
If it matters twice, **codify it**.
