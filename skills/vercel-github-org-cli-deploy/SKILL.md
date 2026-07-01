---
name: vercel-github-org-cli-deploy
description: >-
  Set up free Vercel Hobby deploys for GitHub org repos using GitHub Actions
  and the Vercel CLI (pull → build → deploy --prebuilt). Use when deploying an
  org-hosted GitHub repo to a personal Vercel account, replicating the
  spililand-pwa pattern, or when native Vercel Git integration is undesirable.
---

# Vercel CLI Deploy for GitHub Org Repos (Free)

Deploy a GitHub **organization** repo to Vercel **Hobby (free)** without Vercel Pro or native Git integration. Proven on `spililand/spililand-pwa`.

## Why this pattern

| Approach | Cost | Org private repo | Notes |
|----------|------|------------------|-------|
| Vercel Git integration on org repo | Hobby OK | Needs Vercel↔GitHub app on org | Preview comments, auto-deploy on push |
| **GitHub Actions + Vercel CLI** (this skill) | Hobby + GH Actions minutes | Works with org secrets only | No Vercel GitHub app on org required |

Use this when the repo lives under a GitHub org but billing/ownership should stay on a personal Vercel Hobby account.

## Architecture

```
GitHub org repo (push to main)
  └─ GitHub Actions workflow
       ├─ secrets: VERCEL_TOKEN, ORG_ID, PROJECT_ID
       ├─ vercel pull   → downloads project settings + env vars
       ├─ vercel build  → builds in CI (deterministic)
       └─ vercel deploy --prebuilt --prod → production URL
            └─ Vercel Hobby project (personal account or single-member team)
```

`.vercel/` is **gitignored**. CI links via `VERCEL_ORG_ID` + `VERCEL_PROJECT_ID` env vars, not committed files.

## One-time setup (per repo)

### 1. Prerequisites

- Node project with a working `build` script (e.g. Next.js `next build`)
- Vercel CLI installed locally: `npm i -g vercel`
- Logged in: `vercel login`
- Correct scope: `vercel whoami` — switch with `vercel teams switch` if needed

### 2. Create and link the Vercel project

From the repo root:

```bash
vercel link          # single-app repo → creates .vercel/project.json
# monorepo or non-root app:
# vercel link --repo
```

Record IDs from `.vercel/project.json`:

```json
{
  "projectId": "prj_…",
  "orgId": "team_…"   // or user id for personal scope
}
```

Confirm: `vercel project inspect <project-name>`

### 3. Environment variables

Set production (and preview if needed) vars in Vercel — **not** in the repo:

```bash
vercel env add NEXT_PUBLIC_APP_URL production
vercel env ls
```

For local dev, pull once: `vercel pull --environment=development`

### 4. Create a Vercel access token

1. https://vercel.com/account/tokens → Create Token (full account or scoped to project)
2. Store as GitHub secret — never commit

### 5. Add GitHub repository secrets

In the **org or repo** settings → Secrets and variables → Actions:

| GitHub secret | Maps to env var | Source |
|---------------|-----------------|--------|
| `VERCEL_TOKEN` | `VERCEL_TOKEN` | Vercel account tokens page |
| `ORG_ID` | `VERCEL_ORG_ID` | `.vercel/project.json` → `orgId` |
| `PROJECT_ID` | `VERCEL_PROJECT_ID` | `.vercel/project.json` → `projectId` |

Verify: `gh secret list`

### 6. Add the workflow

Copy [workflow-template.yml](workflow-template.yml) to `.github/workflows/vercel-merge.yml`.

Adjust:
- `branches` if not `main`
- `vercel@54.5.0` pin — bump intentionally, not on every deploy
- Add `workflow_dispatch` is already included for manual runs

### 7. Ensure `.gitignore` excludes `.vercel`

```
.vercel
.env*
```

## Deploy flow (automatic)

On every push to `main`:

1. **Pull** — `vercel pull --yes --environment=production` fetches `project.json` + env into `.vercel/`
2. **Build** — `vercel build --prod` runs the framework build in CI
3. **Deploy** — `vercel deploy --prebuilt --prod` uploads artifacts; aliases (e.g. custom domain) apply automatically

Typical runtime: ~1–2 minutes for a Next.js app.

Manual deploy: Actions → "Deploy to Vercel on merge" → Run workflow.

## Replication checklist

Copy this when setting up a new repo:

```
- [ ] vercel login && vercel whoami (correct team/scope)
- [ ] vercel link (or vercel link --repo for monorepos)
- [ ] vercel project inspect <name> — framework preset correct
- [ ] Production env vars set in Vercel dashboard
- [ ] VERCEL_TOKEN created
- [ ] GitHub secrets: VERCEL_TOKEN, ORG_ID, PROJECT_ID
- [ ] .github/workflows/vercel-merge.yml committed
- [ ] .vercel in .gitignore
- [ ] Push to main → gh run list — workflow success
- [ ] vercel inspect <production-url> — status Ready
```

## Verification commands

```bash
# Local
vercel whoami
vercel project inspect <project-name>
cat .vercel/project.json

# GitHub
gh secret list
gh workflow list
gh run list --workflow=vercel-merge.yml --limit 3
gh run view <run-id> --log

# Vercel
vercel inspect <url>
vercel env ls
```

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Project not found` in CI | Wrong `ORG_ID`/`PROJECT_ID`; re-read `.vercel/project.json` after `vercel link` |
| Auth errors | Regenerate `VERCEL_TOKEN`; token must access the linked org/team |
| Build OK, wrong env values | `vercel pull --environment=production` missing or env vars not set for Production in dashboard |
| Workflow cancelled after hours | Concurrency `cancel-in-progress: true` — newer push cancelled an old run; redeploy latest commit |
| Third-party action permission errors | Use direct CLI steps (this pattern), not `amondnet/vercel-action` |
| Monorepo wrong project | `vercel link --repo`; run workflow from correct root directory |
| Deploy job can't find build output | Split build/deploy jobs need `vercel build --prod --standalone` |

## Free-tier limits (know before scaling)

- **Vercel Hobby**: personal/non-commercial; bandwidth, build minutes, serverless limits apply
- **GitHub Actions**: org private repos consume included minutes; public repos are unlimited
- **Custom domains**: free on Hobby; DNS must point to Vercel

## Optional: preview deploys

This template deploys **production only** on `main`. For PR previews, either:

- Add a second workflow on `pull_request` using `vercel deploy` (no `--prod`), or
- Enable Vercel Git integration for previews only (hybrid)

## Reference implementation

- Repo: `spililand/spililand-pwa` (private GitHub org)
- Vercel project: `spililand-pwa` → `https://app.spililand.com`
- Workflow: `.github/workflows/vercel-merge.yml`
- Evolution: started with `amondnet/vercel-action`, migrated to direct CLI for reliability

For general Vercel CLI commands, also load the `vercel-cli` skill.
