# TODO-008: Gamepass Help Page — Migration

**Status:** 🔴 Ready to assign  
**Priority:** Low  
**Estimated:** 1 hour  
**Depends on:** TODO-003  
**Assigned to:** Layla

---

## Objective

Migrate Gamepass Help page to server actions.

---

## Context

Actions exist in `lib/store/actions.ts`:
- `updateGamepassHelp(formData)` — update help content

This is essentially a CMS page — rich text or markdown content.

---

## UI Requirements

- [ ] Rich text editor (or markdown)
- [ ] Preview mode
- [ ] Save/Publish flow

---

## Notes

Simple page — mostly content editing.
