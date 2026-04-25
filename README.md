# PM

> Project manager and bug prevention for vibe coders.

PM is a Claude Code skill that runs your project and protects it at the same time. You describe what you want — PM handles the planning, the security scanning, the saves, and the rollbacks.

Free to install. Free forever for core features. Pro features included free for 30 days.

---

## Install

Four ways to install — pick one.

### Option A: One command (recommended)

```bash
curl -s https://nuggieai.com/install.sh | bash
```

Creates your account, generates a token, installs the skill, and adds the token to CLAUDE.md. Done in 10 seconds.

### Option B: Claude Code (manual skill)

One command — works on Mac and Linux:

```bash
mkdir -p ~/.claude/skills/pm && curl -o ~/.claude/skills/pm/SKILL.md https://raw.githubusercontent.com/christinezhang5/project-manager-nuggieai-skill/main/skills/pm/SKILL.md
```

Windows:
```
mkdir %USERPROFILE%\.claude\skills\pm
```
Then download `SKILL.md` from this repo and move it to that folder.

### Option C: Claude Code Plugin

Clone the repo and run Claude Code with the `--plugin-dir` flag:

```bash
git clone https://github.com/christinezhang5/project-manager-nuggieai-skill.git ~/.claude/plugins/pm
claude --plugin-dir ~/.claude/plugins/pm
```

This uses the official Claude Code plugin system. Skills are namespaced as `/pm:pm`.

### Option C: GitHub Copilot

PM works in GitHub Copilot (VS Code) in agent mode with Claude as the model. Instead of `CLAUDE.md`, add your token to `.github/copilot-instructions.md`. Select Claude Sonnet in the Copilot model picker and make sure you're in Agent mode.

---

## Setup

**1. Get your free token**
Create a free account at [nuggieai.com](https://nuggieai.com) and copy your skill token from the dashboard.

**2. Add token to your project**
Add this line to your project `CLAUDE.md` (or `.github/copilot-instructions.md` for Copilot):
```
skill_token: nvsk_free_xxxxxxxxxxxxxxxxxxxx
```
Replace with your actual token. Space after the colon. No quotes.

**3. Activate**
In Claude Code (or Copilot agent chat) type:
```
pm on
```

That's it. PM activates and prints a confirmation table.

---

## How it works

When you say `pm on`, this installer file tells Claude to:
1. Read your token from `CLAUDE.md`
2. Fetch the full skill from `nuggieai.com/api/skill/pm`
3. Load it into the session

The skill content lives on nuggieai.com servers — not on your machine. This means updates happen automatically and your IP is protected.

---

## Core Features

Always on from the moment you say `pm on`.

### pm prompt
Intercepts every request before code runs. Two Claude roles work in a feedback loop — one builds a complete spec, one executes. Scans your files, calculates confidence, and asks at most one clarifying question before building. Detects multi-task requests and queues them one at a time.

**Strict boundary rule:** PM only touches files listed in the spec. No drive-by refactors, no "while I'm here" cleanup, no adding features you didn't ask for. No renaming variables you didn't mention, no adding comments to code it didn't write, no reformatting untouched lines. The spec is the boundary.

**What you see:**
```
scanning files... ✓
confidence: 87% ✓
TASK: Add login page
FILES: src/pages/Login.jsx, src/routes/auth.py
CHANGE: Create login form, add POST /auth/login route
LEAVE ALONE: existing user session logic
→ build mode: feature — building in isolation
```

---

### pm global
Maintains `globals.json` as the single source of truth for every color, font, spacing value, and shared variable in your project. Enforces token usage on every edit. Runs a consolidation pass at session start to merge duplicates.

**Why it matters:** Without this, the same color gets defined in 12 different files and changing your brand color becomes a 2-hour job.

---

### pm scan
Routes every request to the right build mode before execution. Modes: focused, search, rebuild, connect. Checks if an edit touches a security surface and loads pm guard automatically. Checks CLAUDE.md line count and loads pm claudemd when it gets too long.

**Build modes:**
| Mode | When | What |
|---|---|---|
| surgical | "fix the button" | Touch only that exact thing |
| search | "nothing is working" | Scan all files |
| rebuild | "start over on auth" | Rebuild from scratch |
| connect | "wire the login to the API" | Connect existing pieces |

---

### pm revert
Logs every prompt in plain English to `CHANGELOG.txt`. Writes a 3-word save header every 5 prompts tagged `[pm]`. Go back any number of prompts with one command. Always confirms before restoring.

**Commands:**
```
pm go back              → restore to last prompt
pm go back 3            → restore 3 prompts ago  
pm go back to login     → search changelog and restore
pm history              → view full changelog
save                    → manual save now
save as [name]          → manual save with custom name
```

---

## Modules

Load on demand. PM suggests them as you build.

### Free forever

**pm standup** — on demand session summary
```
pm standup
```
Shows what got built, what needs fixing, what to do next session. Includes security score if pm guard is loaded. Ends with a shareable plain English paragraph.

**pm scope** — keeps session focused
```
pm scope on
```
Set a focus boundary for the session. PM flags anything outside it and offers to park ideas for later.

**pm map** — relationship map + nicknames
Loads automatically at session start. Scans your project, creates short nicknames, and builds a dependency graph via server-side AST extraction — no install needed.

Shows you:
- Which files import which
- Which files share database tables (break one, break all)
- Which files share env vars
- God nodes (high-connectivity files that ripple when touched)
- Danger zones (tables/env vars that affect the most files)
- Drift risks (files that should talk but don't)

```
pm map show             → full relationship map
pm map [nickname]       → single file detail
pm map refresh          → rebuild graph
pm map set x to y       → override a nickname
```

**Example output:**
```
PROJECT MAP — myproject
16 files · 42 edges · 5 communities
═══════════════════════════════════════

user ──→ validate, verifyAuth, admin-auth, rate              ⚠
  tables: skill_tokens, user_products, promo_codes
  env: DATABASE_URL, STRIPE_SECRET_KEY

grant ──→ admin-auth, rate                                    ⚠
  tables: skill_tokens, user_products, waitlist

chat ──→ rate
  env: ANTHROPIC_API_KEY

DANGER ZONES
─────────────────────────────────────
skill_tokens  ← user, grant, tokens, events, skill   (5 files)
DATABASE_URL  ← user, grant, events, waitlist, chat   (5 files)

DRIFT RISKS
─────────────────────────────────────
admin-auth ↔ verifyAuth — share 2 imports, never connect
═══════════════════════════════════════
```

During builds, pm map automatically warns you:
- `⚠ TABLE: user queries skill_tokens — also touched by: grant, tokens, events`
- `⚠ BLAST RADIUS: user has 9 edges (12 transitive)`

---

**pm style** — catches styles that won't show up
Runs on every edit that touches a style file. Finds rules being silently overwritten, class name typos, and missing variables. Plain English only.

---

**pm merge** — prevents Vercel function limit errors
Watches your `api/` folder in the background. Warns at 10 functions. Automatically proposes how to consolidate before you hit the 12 function cap — groups related endpoints and updates every fetch call across the project.

---

**pm resolve** — full-sweep verification and self-fix loop
Auto-loads when you say things like "change everything", "fix it everywhere", "still not working", or when pm scan notices you're asking for the same edit on the same files again (the strongest signal that the previous attempt didn't take).

Classifies the situation as a rename, removal, addition, replacement, or regression — then runs only the verification surfaces relevant to that pattern (instead of a blanket checklist). For renames it grep-checks every old reference against your in-scope/out-of-scope DATA-KEY BOUNDARIES. For regressions it reads CHANGELOG + last 5 saves to find the suspected breaking change, reproduces the failure, and walks the surfaces around the break point.

Self-fixes every issue it finds, re-runs verification, repeats until zero issues. Only escalates genuinely ambiguous calls (like "is this string a DB key or display text?"). Always shows a verification report splitting issues Claude fixed on its own from issues that need your call.

One-shot when auto-loaded — ejects after the triggering prompt so it doesn't carry into the next. Manual `pm resolve` stays sticky until `pm off`.

---

**pm surgical** — strict surgical-mode lock (opposite of pm resolve)
The opposite-side guardrail to pm resolve. When loaded, blocks pm resolve auto-load entirely — even if you say "fix everything" or pm scan detects a repeated prompt. Locks the mode picker to `surgical` only (no escalation to feature, refactor, redesign, or comprehensive). Caps the spec at one file by default; if pm prompt's confidence loop wants to touch a second file, it asks first.

Use this when you want pm to stay tight — a quick fix, an experimental tweak, a one-line patch — and you don't want a full-tree verification report walking your whole project just because you typed a sweep keyword by reflex.

Manual only — say `pm surgical on` to lock, `pm surgical off` to release. Stays sticky until you toggle it off or `pm off`. Free forever.

---

**pm train** — teach your nuggie your preferences
Manual command for training the active nuggie's "skill file" — a compressed markdown blob server-side that gets loaded alongside the core skill on every future activation. Two modes:

- **Explicit:** `pm train` then dictate preferences in your own words (tone, code style, vocabulary, triggers, permissions allowlist, project context). Claude drafts a section per topic.
- **Inexplicit:** the same command but you pick option 2 — Claude scans the current session for corrections, repeated patterns, vocabulary, and approved Bash patterns, then drafts sections silently.

Either way Claude compresses the draft and POSTs it to nuggieai.com, which merges it into your nuggie's existing skill_md by `## section header` (incoming sections replace matching ones, others stay). The merged file is also written locally to `~/.claude/skills/pm/nuggie-<name>.md` for reference, and is editable in plain text from the nuggie page on nuggieai.com.

Switch nuggies with `pm train change nuggie`. View the current saved file with `pm train show`.

**Size limits** (enforced server-side on the merged file): free **1 KB**, Pro **8 KB**. The free tier holds the basics; Pro is for elaborate per-project setups.

Free forever.

---

### Free for 30 days — then Pro ($0.99/month)

**pm guard** — 18-check security scan
Runs automatically via pm scan. Checks for:
- Exposed API keys and passwords
- Open database routes with no auth
- Missing error states on forms and fetches
- Plain text passwords
- SQL injection vulnerabilities
- XSS — user input rendered without escaping
- Hardcoded URLs
- Schema conflicts
- Debug mode left on
- CORS set to wildcard
- Sensitive data in localStorage
- No rate limiting on login endpoints
- Unvalidated file uploads
- Over-fetching in API responses
- No session expiry on tokens
- No HTTPS enforcement

Tracks a 0–100 security score. Auto-fixes what it can. Auto-prompts a fix when score drops below 75.

---

**pm connect** — diagnoses broken connections
```
pm connect
```
Finds field name mismatches, missing endpoints, wrong data formats between frontend and backend. Auto-loads when pm scan detects a connect mode request.

---

**pm claudemd** — keeps CLAUDE.md lean
Auto-loads when CLAUDE.md hits 100 lines. Audits for duplicates, outdated references, and anything already in globals.json. Restructures so critical context loads first. Never rewrites without confirmation.

---

## Full Command Reference

```
pm on / /pm             activate
pm off                  stop everything
pm status               print current feature table
pm / pm help            show all commands

save                    manual save with 3-word header
save as [name]          manual save with custom name
pm go back              restore to last prompt
pm go back [N]          restore N prompts ago
pm go back to [phrase]  search changelog and restore
pm history              view full changelog
pm history [N]          view last N entries

pm style on/off         toggle style checking
pm standup              session summary
pm scope on/off         toggle scope guard
pm map show             print relationship map
pm map [nickname]       single file detail
pm map refresh          rebuild dependency graph
pm map set [x] to [y]   set nickname
pm map remove [x]       remove nickname
pm map reset            regenerate auto nicknames
pm connect              diagnose broken connections
pm connect map          print connection map
pm branch [name]        create branch
pm branches             list branches
pm switch [name]        switch to branch
pm switch main          switch to main
pm merge [name]         merge branch
pm merge on             enable Vercel limit monitoring
pm resolve              full-sweep verify + self-fix (or auto-loads on sweep/regression triggers)
pm surgical on/off      lock to surgical mode, block pm resolve auto-load
pm train                train active nuggie (explicit or inexplicit mode)
pm train change nuggie  switch active nuggie before training
pm train show           print currently-saved skill_md
```

---

## Tiers

| Feature | Free | Trial (30 days) | Pro $0.99/mo |
|---|---|---|---|
| pm prompt | ✓ | ✓ | ✓ |
| pm scan | ✓ | ✓ | ✓ |
| pm revert | ✓ | ✓ | ✓ |
| pm standup | ✓ | ✓ | ✓ |
| pm scope | ✓ | ✓ | ✓ |
| pm map | ✓ | ✓ | ✓ |
| pm style | ✓ | ✓ | ✓ |
| pm merge | ✓ | ✓ | ✓ |
| pm resolve | ✓ | ✓ | ✓ |
| pm surgical | ✓ | ✓ | ✓ |
| pm train | ✓ | ✓ | ✓ |
| pm guard | — | ✓ | ✓ |
| pm connect | — | ✓ | ✓ |
| pm claudemd | — | ✓ | ✓ |

Upgrade at [nuggieai.com/dashboard](https://nuggieai.com/dashboard)

---

## FAQ

**Do I need to reinstall when PM updates?**
No. The skill content lives on nuggieai.com servers. Every time you say `pm on` you get the latest version automatically. The installer file never needs to be updated.

**Can I use the same token in multiple projects?**
Yes. Add the same `skill_token:` line to any project CLAUDE.md. Works simultaneously across unlimited projects.

**Do I need to reinstall on a new machine?**
Run the install command on the new machine (Option A or B above). Add your token to CLAUDE.md. Say `pm on`. Done.

**What's the difference between the skill install and the plugin install?**
Same thing, different packaging. The skill install (Option A) copies one file. The plugin install (Option B) uses the Claude Code plugin system with `--plugin-dir`. Both fetch the same skill content from nuggieai.com when you say `pm on`.

**What happens after my 30-day trial?**
pm standup, pm scope, pm map, pm style, pm merge, pm resolve, pm surgical, and pm train stay free forever. pm guard, pm connect, and pm claudemd require Pro at $0.99/month.

**How do I get my token?**
Create a free account at [nuggieai.com](https://nuggieai.com) and go to your dashboard.

---

## License

MIT — this installer file is free to share, fork, and modify.

The skill content served from nuggieai.com is proprietary and licensed separately.

---

## Built by

Christine Zhang — [nuggieai.com](https://nuggieai.com)
