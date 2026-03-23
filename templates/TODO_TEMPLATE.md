---
id: TODO-XXX
title: Clear description of the task
assigned_to: steve|viktor|bob|layla|archy
status: pending|in_progress|ready_for_review|approved_by_human|rejected
priority: high|medium|low
created_at: 2024-01-15
dependencies: []
---

# TODO-XXX: [Title]

## Objective
[Clear description of what needs to be done]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Acceptance Criteria
1. [Criterion 1]
2. [Criterion 2]
3. [Criterion 3]

## Context
[Any background information the agent needs]

## Related Files
- `path/to/file.ts` — [Description]

## Notes
[Any additional notes]

---

## Completion Section (Filled by Agent)

**DO NOT move this file to .solved/ — Wait for human approval**

When you finish, fill this section and update status to `ready_for_review`:

```yaml
completed_at: 2024-01-15T14:30:00Z
completed_by: steve|viktor|bob|layla|archy
status: ready_for_review  # NOT solved — waiting for human
```

### What Was Done
[Detailed description of changes made]

### Files Modified
- `path/to/file.ts` — [What changed]
- `path/to/other.ts` — [What changed]

### Key Decisions Made
- [Decision 1]: Why this approach
- [Decision 2]: Trade-offs considered

### Testing Performed
- [ ] Unit tests
- [ ] Manual testing
- [ ] Edge cases checked

### Potential Issues / Risks
[Anything that might cause problems later]

### Next Steps (if applicable)
[What needs to happen next — for handoff to next agent]

### Handoff File
Written to: `.agents/handoffs/from-{agent}/HANDOFF-XXX.md`

---

## Human Review Section (Filled by Juanes)

```yaml
reviewed_at: 
reviewed_by: juanes
verdict: approved|rejected|needs_revision
```

### Review Notes
[Juanes writes feedback here]

### Required Changes (if rejected)
- [ ] Change 1
- [ ] Change 2

---

## Archive Record (Filled by Orchestrator after Human Approval)

```yaml
moved_to_solved_at: 2024-01-15T16:00:00Z
approved_by: juanes
```
