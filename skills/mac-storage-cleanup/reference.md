# Mac Storage Cleanup — Reference

## Report output

Default path: `~/disk-cleanup-plan.html`

Overwrite each run. Optionally archive: `~/disk-cleanup-reports/YYYY-MM-DD.html`

## HTML design spec

Minimal light theme. Match these tokens:

```css
--bg: #fafafa;
--surface: #ffffff;
--border: #e8e8e8;
--text: #111111;
--muted: #737373;
--green: #16a34a;
--red: #dc2626;
--amber: #ca8a04;
```

Required sections:
1. **Summary** — before/after/recovered hero stats + usage meters
2. **Before & After** — side-by-side folder comparison
3. **Completed** — actions taken this session with status badges (`Done`, `Kept`, `Not done`)
4. **Remaining opportunities** — sorted by size descending
5. **Current inventory** — disk, homebrew counts, active projects
6. **Ongoing maintenance** — weekly/monthly checklist

Status badges: `.status.done` (green), `.status.open` (amber), `.status.skip` (gray)

## Question bank

Generate questions only for targets **present in scan** with **kb ≥ 10240** (10 MB). Each question must include: path, size, safe action, estimated savings.

| Target pattern | Question template |
|----------------|-------------------|
| `Claude/vm_bundles` | Still use Claude Desktop VM/sandbox features? |
| `CoreSimulator` | Need iOS Simulators / Xcode? |
| `com.docker.docker` | Use Docker Desktop? Any compose projects? |
| `slackmacgap` | Slack desktop or web-only? |
| `WebEx*` | Still need WebEx? |
| `state.vscdb` | OK to clear old Cursor AI chats? |
| `highagency.pencildev*` | Still use Pencil extension? |
| `node_modules` / `.next` / `target` per project | Is `{project}` active? Archive or delete artifacts? |
| `~/lab/{project}` whole folder | Synced with GitHub? Delete local copy? |
| `brew leaves` | Orphaned deps — run autoremove? |
| Duplicate extension versions | Keep latest only? |
| `.npm` / pnpm store / `Caches/Arc` | Tolerate slower rebuilds to purge caches? |
| `ollama` / `mysql` / `postgresql*` | Use locally? |
| `.codeium` / `.sdkman` / `patchright-browsers` | Tool still in use? |

Use **AskQuestion** when the user hasn't pre-answered and multiple large targets exist (batch by category: dev caches → apps → projects).

## Risk levels

| Level | Examples | Rule |
|-------|----------|------|
| **Safe** | `cargo clean`, delete `.next`, `npm cache clean`, `brew cleanup`, puppeteer cache | Execute after one-line confirmation |
| **Medium** | App Support caches, uninstall cask, remove extension, delete `node_modules` | Require explicit yes per category |
| **Risky** | Delete whole `~/lab` project, Claude vm_bundles, clear state.vscdb | Git sync check + explicit yes per item |

## Git sync check (before deleting any project)

```bash
cd "$PROJECT" && git status && git remote -v && git log @{u}..HEAD --oneline
```

Proceed only if: clean working tree, upstream exists, no unpushed commits.

## Cleanup commands

```bash
# Safe — build artifacts
cd ~/lab/PROJECT && cargo clean                    # Rust target/
find ~/lab -name ".next" -type d -prune -exec rm -rf {} +
find ~/lab/PROJECT -name "node_modules" -type d -prune -exec rm -rf {} +

# Safe — package caches
npm cache clean --force
pnpm store prune
brew cleanup -s && brew autoremove
uv cache clean
bun pm cache rm
rm -rf ~/.cache/puppeteer ~/.cache/hyperframes
cargo cache -a  # or rm -rf ~/.cargo/registry/src

# Medium — app data (quit app first)
rm -rf ~/Library/Application\ Support/Claude/vm_bundles
rm -rf ~/.cursor/extensions/OLD_EXTENSION_VERSION-*

# Medium — extension full removal
rm -rf ~/.cursor/extensions/highagency.pencildev-*
rm -rf ~/Library/Application\ Support/Cursor/User/globalStorage/highagency.pencildev
rm -rf ~/.pencil

# Homebrew
brew uninstall --ignore-dependencies PACKAGE
brew uninstall --cask CASK
```

## macOS permission notes

`~/Library/Containers/*` metadata plists may return "Operation not permitted" — inner data usually deletes; ~40 KB shell remains. Do not force with sudo.

## Baseline comparison

- **First run:** before = current scan; after = post-cleanup rescan
- **Recurring run:** before = `state/previous-scan.json` (or last report date); after = current scan after cleanup
- Store snapshots via `scripts/scan-disk.sh` → `state/last-scan.json`

## Maintenance targets

Keep ≥ 15% disk free. On 245 GB drive ≈ 35 GB minimum recommended.
