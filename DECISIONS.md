# Architecture Decision Log

This file is the shared memory of the development team. Every non-obvious
technical decision is recorded here so that future work doesn't contradict,
undo, or re-debate past choices.

**Who writes here:** Steve, Viktor, Bob, Layla, Archy
**When to write:** After making a decision where the "why" isn't obvious from
the code alone — design tradeoffs, rejected alternatives, regulatory constraints,
bug patterns that must not recur.
**When NOT to write:** Routine implementation choices, obvious patterns, anything
self-evident from reading the code.

---

## Agent Responsibilities

| Agent | Primary Role | Stack Focus | Reports To |
|-------|-------------|-------------|------------|
| Steve | Database Architect | PostgreSQL, Supabase, RLS, migrations | .steve/reports/ |
| Viktor | QA Testing | pgTAP, RLS testing, constraint verification | .viktor/reports/ |
| Bob | Backend Engineer | Next.js Server Actions, API routes, auth | .bob/reports/ |
| Layla | Frontend Architect | React, Tailwind, shadcn/ui, UX | .layla/reports/ |
| Archy | Senior Debugger | Escalated bug fixes | .archy/reports/ |

---

## Pipeline Flow

```
Schema Changes:     Steve → Viktor → Bob → Viktor → Layla
Backend Changes:    Bob → Viktor → Layla
Frontend Changes:   Layla (solo, unless bug) → Archy (if escalated)
Bugs:               Any → Archy (escalated)
```

---

## Workflow

1. **New Task** → Added to `.agents/todos/TODO-XXX.md`
2. **Handoff** → Previous agent writes `.agents/handoffs/HANDOFF-XXX.md`
3. **Work** → Agent executes, updates todo
4. **Complete** → Todo moved to `.agents/archive/`, decision logged here if needed

---

<!-- TEMPLATE — copy this block for each new entry

## YYYY-MM-DD — [Short title: what was decided]
**Agent:** [Steve / Viktor / Bob / Layla / Archy]
**Context:** [1-2 sentences: what problem or question triggered this decision]
**Decision:** [What was chosen and how it works]
**Why not the alternative:** [What was rejected and why]
**Revisit if:** [Under what future conditions this decision should be reconsidered]

-->

## Decisions Made

*(Agents append here)*
