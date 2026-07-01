---
name: crystal-clear
description: Interview the user until the objective is crystal clear before creating or solving complex problems. Use when the user invokes /crystal-clear or /cc, says "interview me until objective is crystal clear" (or "untill"), or starts a complex problem without a locked objective.
disable-model-invocation: true
---

# Crystal Clear

Interview me until objective is crystal clear.

Do not plan, build, research, or execute until the objective is locked. Clarify first; work second.

## How to invoke (replaces typing the phrase every time)

In Agent chat, type `/` and pick **cc** or **crystal-clear**, then your rough goal in the same message:

```
/cc I need a lead-scoring workflow for agency prospects
```

```
/crystal-clear Redesign the onboarding funnel for Birra & Build
```

You no longer need to append "interview me until objective is crystal clear" — invoking the skill is enough.

## Activation

Run when the user:
- Invokes `/crystal-clear` or `/cc` (often with a rough problem or goal in the same message)
- Says "interview me until objective is crystal clear" (or close variants)
- Opens a complex problem without clear success criteria, scope, or deliverable

## Rules

1. **One question per turn.** Never bundle.
2. **Provide a recommended answer** with each question (1-sentence rationale). Do not default to "what do you think?"
3. **Explore before asking** when the answer is in the repo, codebase, or prior context. Report what you found and ask for confirmation.
4. **Depth-first.** Finish one branch (scope, audience, constraints, etc.) before opening another.
5. **No premature work.** No code, files, searches for solutions, or long plans until the objective is crystal clear.
6. **Short turns.** Keep questions and recommendations tight.

## Interview branches (walk until resolved)

Cover what matters for this problem; skip what is already explicit:

| Branch | What to lock |
|--------|----------------|
| Problem | What is wrong or missing? Why does it matter now? |
| Outcome | What does "done" look like? How will we know it worked? |
| Audience / user | Who is this for? Who decides success? |
| Scope | In scope vs explicitly out of scope |
| Constraints | Time, budget, tech, policy, dependencies |
| Deliverable | Format, location, level of polish |
| Context | What already exists? What was tried? What must not change? |
| Priority | If we can't have everything, what wins? |

## Per-turn format

```
Q[n]: [question]
Recommended: [your call + brief rationale]

— or, if you explored first —

Found: [evidence from repo/code/context]
Confirm: [yes/no or pick A/B]
```

## When objective is crystal clear

Stop interviewing. Post this block, then wait for explicit go-ahead (or proceed only if the user already said to continue after clarity):

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

Only after confirmation (or an explicit "go" in the same thread) start the actual work.

## Relationship to other skills

- **grill-me** — stress-test an existing plan or design decision tree. Use after the objective is clear.
- **crystal-clear** — lock the objective before planning or building.
