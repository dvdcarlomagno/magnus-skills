# Roadmap — skills to publish

Skills already in this repo are marked **live**. Others are authored locally and candidates for the next batches.

## Batch 1 — live

- **crystal-clear** — objective-locking interview before complex work
- **cc** — `/cc` shortcut for crystal-clear
- **mac-storage-cleanup** — Mac disk space retrospective + HTML report

## Batch 2 — productivity & clarity (high share value)

| Skill | Why publish |
|-------|-------------|
| **prompt-master** | Universal prompt optimizer for any AI tool; versioned, battle-tested |
| **frontend-slides** | Zero-dependency animated HTML decks from scratch or PPT |
| **vitruvian-image-generator** | Distinctive visual style for idea visualization |
| **voicepal-document-expander** | Inline expansion questions for drafts (pairs with Voicepal) |

## Batch 3 — builder & content (personal brand)

| Skill | Why publish |
|-------|-------------|
| **create-linkedin-ready-post** | Davide's voice system — useful template for other builders |
| **event-recap-slack-message** | Raycafé-style meetup debriefs (Cursor meetups, Birra&Build, etc.) |
| **vercel-github-org-cli-deploy** | Org-repo → personal Vercel Hobby via GitHub Actions |

## Batch 4 — idea validation suite

Cohesive toolkit; publish as a folder or meta-package:

| Skill | Role |
|-------|------|
| problem-miner | Pain clustering from raw feedback |
| web-pain-scanner | Web-wide pain discovery |
| competitor-mapper | Landscape mapping |
| deep-competitor-teardown | Single-competitor deep dive |
| persona-segment-mapper | Segments + personas |
| positioning-play-generator | Differentiation options |
| pricing-landscape-analyzer | Pricing benchmarks |
| wtp-interview-script-generator | WTP interview scripts |
| landing-page-experiment-designer | Demand-test page design |
| validation-summary-synthesizer | Build / retest / pivot decision |

## Batch 5 — freelance OS (Italian-first, needs frontmatter pass)

These skills exist locally but use legacy `$ARGUMENTS` format without YAML frontmatter — normalize before publishing:

| Skill | Role |
|-------|------|
| cliente-freelance-conversione | 3-block conversion framework |
| doctor-sales-navigator | Diagnostic sales calls |
| ghost-proof-offer-architect | Anti-ghosting proposals |
| toxic-client-filter | Red-flag client screening |
| negotiation-leverage-shield | Scope-for-price tradeoffs |
| revision-matrix-manager | Revision / upsell matrix |
| pricing-strategy-architect | Value-based quoting |
| dark-hours-profitability-auditor | True project profitability |
| leveraged-efficiency-automator | Automate non-revenue work |
| autonomous-delivery-orchestrator | GSD + Ralph autonomous delivery |
| pirate-acquisition-system | Client acquisition tactics |
| transformation-identity-designer | Transformation promise + niche |
| victory-diary-curator | Imposter-syndrome evidence log |

## Batch 6 — n8n operator pack

| Skill |
|-------|
| n8n-workflow-patterns |
| n8n-mcp-tools-expert |
| n8n-node-configuration |
| n8n-validation-expert |
| n8n-expression-syntax |
| n8n-code-javascript |
| n8n-code-python |

## Not planned for this repo (separate products)

- **HyperFrames video suite** (`hyperframes`, `website-to-video`, `product-launch-video`, etc.) — belongs with the HyperFrames project, not Lab misc skills
- **grill-me** — fork of [Matt Pocock's skill](https://github.com/mattpocock/skills); link upstream instead of republishing
- **find-skills** — ecosystem utility; users should install from skills.sh directly
- **Cursor built-ins** (`skills-cursor/*`) — Cursor-managed, do not copy

## Before adding a skill

1. YAML frontmatter: `name`, `description`, optional `disable-model-invocation`
2. No hardcoded `~/.cursor/skills/...` paths — use relative paths or env vars
3. Strip personal secrets, client names, or private repo paths unless intentional
4. Add row to README table + install one-liner
