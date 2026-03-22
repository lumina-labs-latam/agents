# TODO-011: QA Testing — Viktor Validates All Migrations

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** High  
**Estimated:** 2-3 hours  
**Depends on:** TODO-010 complete (all migrations done)  
**Assigned to:** Viktor

---

## Objective

Comprehensive QA of all migrated functionality.

---

## Test Plan

### Admin Pages
- [ ] Dashboard — stats load correctly
- [ ] Orders — list, approve, reject, complete
- [ ] Currencies — CRUD operations
- [ ] Reviews — moderate, delete
- [ ] Products — CRUD, image upload, status toggle
- [ ] Categories — CRUD, ordering
- [ ] Users — list, role toggle, status toggle
- [ ] Store Settings — save, payment methods
- [ ] Gamepass Help — content update

### Security
- [ ] Non-admin cannot access admin pages
- [ ] RLS policies enforce correctly
- [ ] Cannot access other users' data

### Edge Cases
- [ ] Empty states (no orders, no products)
- [ ] Pagination (many items)
- [ ] Error handling (network down, server error)

---

## Deliverable

Report to `.viktor/reports/2026-03-23-migration-qa.md` with:
- Pass/fail per feature
- Bugs found (if any) with repro steps
