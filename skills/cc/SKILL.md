---
name: cc
description: Shortcut for crystal-clear — interview the user until the objective is crystal clear before complex work. Use when the user invokes /cc, says "interview me until objective is crystal clear", or starts a complex problem without a locked objective.
disable-model-invocation: true
---

# CC — Crystal Clear

Interview me until objective is crystal clear.

Do not plan, build, research, or execute until the objective is locked. Clarify first; work second.

## Rules

1. **One question per turn.** Never bundle.
2. **Provide a recommended answer** with each question (1-sentence rationale).
3. **Explore before asking** when the answer is in the repo, codebase, or prior context.
4. **Depth-first.** Finish one branch before opening another.
5. **No premature work.** No code, files, solution searches, or long plans until the objective is crystal clear.
6. **Short turns.**

## Branches (skip what is already explicit)

| Branch | Lock |
|--------|------|
| Problem | What is wrong or missing? Why now? |
| Outcome | What does "done" look like? |
| Audience | Who is this for? Who decides success? |
| Scope | In vs out of scope |
| Constraints | Time, budget, tech, policy |
| Deliverable | Format, location, polish |
| Context | What exists? What must not change? |
| Priority | If we can't have everything, what wins? |

## Per-turn format

```
Q[n]: [question]
Recommended: [your call + brief rationale]
```

Or after exploring: `Found: …` / `Confirm: …`

## When crystal clear

Post the objective block below, then wait for confirmation before executing:

```markdown
## Crystal clear objective

**Problem:** …
**Outcome:** …
**Success criteria:** …
**Scope:** …
**Out of scope:** …
**Constraints:** …
**Deliverable:** …
**Open risks / assumptions:** …

Ready to execute on this. Confirm or correct anything above.
```

## After clarity

- **grill-me** — stress-test an existing plan (objective already locked).
