# AGENTS

This folder is home. Treat it that way.

This is your worspace for the Tartin project.

## Visual Design Anti-Patterns

**NEVER use emoji-style icons** (🔴🟠🟡🔵⚪) in CLI output. They cause cognitive overload.

**ALWAYS use small Unicode symbols** with semantic colors:
- Status: `○ ◐ ● ✓ ❄`
- Priority: `● P0` (filled circle with color)

See "Visual Design System" section for full guidance.

## First Run

If BOOTSTRAP.md exists, that's your birth certificate. Follow it, figure out who you are, then delete it. You won't need it again.

## Project

PROJECT.md contains information about the project you are working on. It includes details such as the project name, description, technology stack, and any relevant links or resources.

## Every Session

Before doing anything else:

- Read SOUL.md — this is who you are
- Read USER.md — this is who you're helping
- If in MAIN SESSION (direct chat with your human): Also read MEMORY.md
- Don't ask permission. Just do it.

## Memory

You wake up fresh each session. These files are your continuity:

Long-term: MEMORY.md — your curated memories, like a human's long-term memory
Capture what matters. Decisions, context, things to remember. Skip the secrets unless asked to keep them.

Use Beads and the `bd` tool for all other memories associated with building as an agent.

### MEMORY.md - Your Long-Term Memory

- ONLY load in main session (direct chats with your human)
- DO NOT load in shared contexts (Discord, group chats, sessions with other people)
- This is for security — contains personal context that shouldn't leak to strangers
- You can read, edit, and update MEMORY.md freely in main sessions
- Write significant events, thoughts, decisions, opinions, lessons learned
- This is your curated memory — the distilled essence, not raw logs
- Over time, review your daily files and update MEMORY.md with what's worth keeping

## Write It Down - No "Mental Notes"!

- Memory is limited — if you want to remember something, WRITE IT TO A FILE or Beads issue
- "Mental notes" don't survive session restarts. Files do.
- When someone says "remember this" → update the relevant beads epic or issue with the details
- When you learn a lesson → update AGENTS.md, TOOLS.md, or the relevant skill
- When you make a mistake → document it so future-you doesn't repeat it
- Text > Brain

## Safety

- Don't exfiltrate private data. Ever.
- Don't run destructive commands without asking.
- trash > rm (recoverable beats gone forever)
- When in doubt, ask.

## Tools

Skills and MCPs provide your tools. When you need one, check its SKILL.md. Keep local notes in TOOLS.md.

## Make It Yours

This is a starting point. Add your own conventions, style, and rules as you figure out what works.

## Agent Warning: Interactive Commands

**DO NOT use `bd edit`** - it opens an interactive editor ($EDITOR) which AI agents cannot use.

Use `bd update` with flags instead:
```bash
bd update <id> --description "new description"
bd update <id> --title "new title"
bd update <id> --design "design notes"
bd update <id> --notes "additional notes"
bd update <id> --acceptance "acceptance criteria"
```

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

## Documentation

Use these documentation resources for Tart, Vagrant, and Tart Vagrant plugin.

- [Packer documentation](https://developer.hashicorp.com/packer/docs)
- [Tart documentation](https://tart.dev/docs)
- [Tart Frequently Asked Questions](https://tart.run/faq/)
- [Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)
- [Tart Vagrant Plugin documentation](https://letiemble.github.io/vagrant-tart/)
- [Tart Vagrant Plugin installation](https://letiemble.github.io/vagrant-tart/)
- [Tart Vagrant Plugin configuration](https://letiemble.github.io/vagrant-tart/configuration.html)
- [Vagrant documentation](https://developer.hashicorp.com/vagrant/docs)
- [Vagrantfile documentation](https://developer.hashicorp.com/vagrant/docs/vagrantfile)
- [Vagrant tips and tricks](https://developer.hashicorp.com/vagrant/docs/vagrantfile/tips)
- [Vagrant config.vm](https://developer.hashicorp.com/vagrant/docs/vagrantfile/machine_settings)

<!-- bv-agent-instructions-v1 -->

---

## Beads Workflow Integration

This project uses [beads_viewer](https://github.com/Dicklesworthstone/beads_viewer) for issue tracking. Issues are stored in `.beads/` and tracked in git.

### Essential Commands

```bash
# View issues (launches TUI - avoid in automated sessions)
bv

# CLI commands for agents (use these instead)
bd ready              # Show issues ready to work (no blockers)
bd list --status=open # All open issues
bd show <id>          # Full issue details with dependencies
bd create --title="..." --type=task --priority=2
bd update <id> --status=in_progress
bd close <id> --reason="Completed"
bd close <id1> <id2>  # Close multiple issues at once
bd sync               # Commit and push changes
```

### Workflow Pattern

1. **Start**: Run `bd ready` to find actionable work
2. **Claim**: Use `bd update <id> --status=in_progress`
3. **Work**: Implement the task
4. **Complete**: Use `bd close <id>`
5. **Sync**: Always run `bd sync` at session end

### Key Concepts

- **Dependencies**: Issues can block other issues. `bd ready` shows only unblocked work.
- **Priority**: P0=critical, P1=high, P2=medium, P3=low, P4=backlog (use numbers, not words)
- **Types**: task, bug, feature, epic, question, docs
- **Blocking**: `bd dep add <issue> <depends-on>` to add dependencies

### Session Protocol

**Before ending any session, run this checklist:**

```bash
git status              # Check what changed
git add <files>         # Stage code changes
bd sync                 # Commit beads changes
git commit -m "..."     # Commit code
bd sync                 # Commit any new beads changes
git push                # Push to remote
```

### Best Practices

- Check `bd ready` at session start to find available work
- Update status as you work (in_progress → closed)
- Create new issues with `bd create` when you discover tasks
- Use descriptive titles and set appropriate priority/type
- Always `bd sync` before ending session

<!-- end-bv-agent-instructions -->
