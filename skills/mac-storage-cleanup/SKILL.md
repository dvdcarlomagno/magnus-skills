---
name: mac-storage-cleanup
description: Runs a Mac disk storage retrospective — scans usage, asks tailored cleanup questions, executes safe deletions with confirmation, and writes a minimal light-theme HTML report.
disable-model-invocation: true
---

# Mac Storage Cleanup

**Manual activation only** — run when the user explicitly invokes `/mac-storage-cleanup` or asks to run the mac-storage-cleanup skill. Do not auto-apply from ambient context (disk space mentions, storage complaints, etc.).

Weekly or monthly retrospective to reclaim disk space safely on macOS (Apple Silicon or Intel).

## Quick start

1. Run scan → 2. Compare baseline → 3. Ask tailored questions → 4. Execute approved cleanup → 5. Rescan → 6. Write HTML report

Default report: `~/disk-cleanup-plan.html`

## Phase 1 — Scan

Run from this skill's directory (works whether installed via `npx skills add` or cloned from GitHub):

```bash
chmod +x scripts/scan-disk.sh
./scripts/scan-disk.sh
```

Read `state/last-scan.json` (current) and `state/previous-scan.json` (last run baseline).

Supplement manually if needed:

```bash
df -h /System/Volumes/Data
du -sh ~/Library/* ~/lab/* ~/.cursor/* 2>/dev/null | sort -hr | head -20
find ~/lab \( -name node_modules -o -name .next -o -name target \) -type d -prune -exec du -sh {} \; 2>/dev/null | sort -hr | head -15
brew list --cask; brew leaves 2>/dev/null
du -sh ~/.cursor/extensions/* 2>/dev/null | sort -hr | head -10
```

Flag anything **≥ 100 MB** for questions or recommendations.

## Phase 2 — Baseline

| Scenario | "Before" source |
|----------|-----------------|
| First run | Current scan (pre-cleanup) |
| Recurring | `previous-scan.json` or prior report date |

Record: free space, used space, capacity %, top 10 consumers.

## Phase 3 — Tailored questions

For each large target in scan, ask one focused question. Skip items already absent.

**Format each question:**
- What it is (plain language + path)
- Size
- What happens if removed
- Estimated savings

**Group questions** when > 8 targets (dev caches → apps → lab projects → homebrew).

Use **AskQuestion** for batches. If user pre-answers in one message (like "remove X, keep Y, skip caches"), map answers directly — do not re-ask.

**Never delete without confirmation** for Medium/Risky items. See [reference.md](reference.md) for risk levels and question bank.

## Phase 4 — Execute cleanup

Order: Safe → Medium → Risky.

**Before deleting any `~/lab` project:**
```bash
cd ~/lab/PROJECT && git status && git remote -v && git log @{u}..HEAD --oneline
```
Only proceed if clean, synced, no unpushed commits.

**Quit apps** before clearing Application Support (Claude, Cursor, Arc, Slack).

**After cleanup**, rerun scan script for "after" numbers.

Commands and targets: [reference.md](reference.md)

## Phase 5 — HTML report

Write `~/disk-cleanup-plan.html` — minimal light theme, max-width 720px.

Required sections:
1. **Summary** — before / after / recovered hero + usage bars
2. **Before & After** — side-by-side folder table
3. **Completed** — this session's actions with status badges
4. **Remaining opportunities** — sorted by size
5. **Current inventory** — disk stats, homebrew, lab projects
6. **Ongoing maintenance** — weekly/monthly habits

Design tokens and structure: [reference.md](reference.md)

Open report when done: `open ~/disk-cleanup-plan.html`

## Phase 6 — Close out

Summarize in chat:
- GB recovered
- What was removed vs kept
- Top 3 remaining opportunities
- Next recommended review (1 week or 1 month per user cadence)

## Safety rules

1. **Regenerable** = safe: `target/`, `.next/`, `node_modules/`, package caches, `cargo clean`
2. **Not regenerable** = confirm: chat DBs, app data, databases, whole project folders
3. **Never** `sudo rm`, never delete without checking git sync for projects
4. **Leave caches** if user says keep them (npm/pnpm/Arc) — mark `Kept` in report
5. **Containers** — data deletes; metadata plist may remain (~40 KB), ignore

## Recurring cadence

When user says "weekly" or "monthly":
- Compare against last snapshot automatically
- Prioritize **new** large items since last scan
- Shorter question set — only items changed or newly above 500 MB

## Additional resources

- Scan targets, commands, question bank: [reference.md](reference.md)
