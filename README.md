# Lab Skills

Public agent skill library by [Davide Carlomagno](https://github.com/dvdcarlomagno) — portable workflows for Cursor, Claude Code, and the [open skills ecosystem](https://skills.sh/).

Skills live under `skills/<name>/` with a required `SKILL.md`. Install individual skills or clone the whole repo into your Lab.

## Install

### Skills CLI (recommended)

```bash
npx skills add dvdcarlomagno/lab-skills/skills/crystal-clear
npx skills add dvdcarlomagno/lab-skills/skills/mac-storage-cleanup
npx skills add dvdcarlomagno/lab-skills/skills/cc
```

### Cursor (manual)

```bash
git clone https://github.com/dvdcarlomagno/lab-skills.git ~/Lab/lab-skills
ln -s ~/Lab/lab-skills/skills/crystal-clear ~/.cursor/skills/crystal-clear
ln -s ~/Lab/lab-skills/skills/mac-storage-cleanup ~/.cursor/skills/mac-storage-cleanup
```

## Available skills

| Skill | Invoke | What it does |
|-------|--------|--------------|
| [crystal-clear](skills/crystal-clear/) | `/crystal-clear` | Interview until the objective is locked before building |
| [cc](skills/cc/) | `/cc` | Shortcut alias for crystal-clear |
| [mac-storage-cleanup](skills/mac-storage-cleanup/) | `/mac-storage-cleanup` | Mac disk retrospective with safe cleanup + HTML report |

## Roadmap (planned additions)

See [ROADMAP.md](ROADMAP.md) for the full catalog of personal skills queued for publication.

## License

MIT — see [LICENSE](LICENSE).
