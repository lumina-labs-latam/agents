# Handoff Template

Use this template when passing work between agents.

**Filename:** `.agents/handoffs/HANDOFF-XXX-{from}-{to}.md`

---

```markdown
# HANDOFF-XXX: [Brief Description]

**From:** [Agent name]  
**To:** [Agent name]  
**Date:** YYYY-MM-DD  
**Related Todo:** TODO-XXX

---

## What Was Done

[Summary of work completed]

---

## Current State

- [ ] Files modified: [list]
- [ ] Tests passing: [yes/no/na]
- [ ] Build status: [passing/failing]

---

## Handoff Details

### Context
[What the next agent needs to know]

### Blockers
[Any issues encountered]

### Decisions Made
[Trade-offs, why certain choices]

### Next Steps
[What needs to happen next]

---

## Files to Review

- `path/to/file.tsx` — [what to look for]
- `path/to/action.ts` — [what to look for]

---

## Open Questions

[Anything unresolved]
```

---

## Handoff Archive

When complete, move to `.agents/archive/handoffs/`
