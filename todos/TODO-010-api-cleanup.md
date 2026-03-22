# TODO-010: API Routes Cleanup — Remove Redundant Routes

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** Medium  
**Estimated:** 1 hour  
**Depends on:** TODO-002 (Bob's audit) + all migrations complete  
**Assigned to:** Bob

---

## Objective

Delete API routes that have been replaced by server actions.

---

## Process

1. Bob reviews TODO-002 audit report
2. Confirms all frontend pages migrated (TODO-003, 004, 005, 006, 007, 008)
3. Deletes redundant routes one by one
4. Tests after each deletion

---

## Candidates for Deletion

Likely can delete:
- `app/api/admin/products/route.ts`
- `app/api/admin/categories/route.ts`
- `app/api/admin/currencies/route.ts`
- `app/api/admin/orders/route.ts`
- `app/api/admin/reviews/route.ts`
- `app/api/admin/dashboard/route.ts`
- `app/api/admin/gamepass-help/route.ts`

Likely keep (for now):
- `app/api/admin/support/*` — depends on TODO-009
- `app/api/admin/users/route.ts` — depends on TODO-006
- `app/api/admin/audit-logs/route.ts` — may need server actions first

---

## Deliverable

Report to `bob/reports/2026-03-23-api-cleanup.md` listing deleted routes.
