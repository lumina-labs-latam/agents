# Agent Hub Decisions Log

**Project:** Sakus Store  
**Initialized:** 2026-03-23  
**Purpose:** Track architectural and workflow decisions made by agents

---

## Decision Template

```markdown
### DECISION-XXX: [Title]
**Date:** YYYY-MM-DD  
**Agent:** [Name]  
**Context:** [What problem are we solving?]  
**Options Considered:**
1. [Option A]
2. [Option B]
**Decision:** [What we chose]  
**Rationale:** [Why]  
**Consequences:** [Trade-offs, future implications]
```

---

## Agent Responsibilities (Corrected)

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

## Decisions Made

*(Agents append here)*
