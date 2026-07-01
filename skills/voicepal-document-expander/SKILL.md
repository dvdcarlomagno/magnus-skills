---
name: voicepal-document-expander
description: Generate Voicepal-style expansion questions for a mentioned draft or document and write them directly into the file. Use only when the user explicitly asks with phrases like "use voicepal expansion mode" or "expand this draft with voicepal questions". Produces inline expansion prompts plus an appended prioritized question bank in the document language.
disable-model-invocation: true
---

# Voicepal Document Expander

## Purpose
Use this skill to expand a draft by asking better follow-up questions, modeled on Voicepal's prompt intent: concise questions that help the writer deepen specifics, examples, and clarity.

## Activation Rules
Run this skill only when the user explicitly asks, for example:
- "use voicepal expansion mode"
- "expand this draft with voicepal questions"
- "apply the voicepal document expander"

Do not auto-activate on passive document mentions.

## Required Input
- A concrete target draft/document (mentioned file, pasted text, or clearly referenced section).

If the target text is missing or ambiguous, ask one focused question to identify the exact text to expand.

## Generation Rubric (Voicepal-Style)
Create follow-up questions that:
1. Ask for specifics instead of abstractions.
2. Pull concrete examples, stories, and proof.
3. Surface assumptions, tradeoffs, and missing context.
4. Clarify who/what/when/how details that improve usability.
5. Push toward actionable next steps.

Question quality constraints:
- Concise and non-leading.
- One intent per question.
- Avoid duplicates and cosmetic rewrites.
- Avoid generic filler (for example: "Can you elaborate more?").

## Output Contract (Always Two Sections, Written Into the Document)
Do not return a chat-only list. Edit the target document directly.

### 1) Inline Expansion Questions (in-place edits)
Insert question blocks immediately after underdeveloped passages in the draft.

Each inserted block must include:
- `Gap:` one short sentence describing what is missing in that passage.
- `Questions:` 1-2 targeted follow-up questions.

Use this exact block format in the document:
```markdown
> [Expansion]
> Gap: <what is missing>
> Questions:
> - <question 1>
> - <question 2 (optional)>
```

Placement and scope rules:
- Keep the original author text intact (no full rewrites).
- Insert blocks right below the relevant paragraph.
- Add up to 8 inline blocks unless the user asks for more.
- Avoid stacking multiple blocks for the same sentence unless needed.

### 2) Appended Question Bank (Prioritized)
Append this section at the end of the same document (not only in chat).

Use this heading and format:
```markdown
## Appended Question Bank (Prioritized)
- [P1] <question>
- [P1] <question>
- [P2] <question>
```

Priority tags:
- `P1` = high impact on clarity/value
- `P2` = medium impact
- `P3` = nice-to-have depth

After editing, reply briefly with:
- which file was edited
- how many inline blocks were inserted
- how many bank questions were appended

## Language Rules
- Match the language of the target draft.
- If the draft is mixed-language, use the dominant language.
- Preserve domain terms, names, product labels, and proper nouns as written.
- Do not translate quoted passages unless the user asks.

## Guardrails
- Do not rewrite the full draft unless explicitly requested.
- Do not invent facts, metrics, or references.
- Keep focus on expansion questions, not editing style preferences.

## Quick Self-Check Before Sending
- Was this explicitly invoked by the user?
- Did I write both required sections into the document?
- Are questions concise, specific, and non-duplicative?
- Did I keep the output in the draft's language?
