# TODO-006: Users Page — Backend + Frontend

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** Medium  
**Estimated:** 3 hours split between Bob + Layla  
**Assigned to:** Bob (backend) → Layla (frontend)

---

## Objective

Build full Users admin page.

---

## Part 1: Bob — Server Actions

Create `lib/users/actions.ts`:
- [ ] `getUsers()` — paginated user list (admin only)
- [ ] `getUserById(id)` — single user details
- [ ] `updateUserRole(id, role)` — promote/demote admin
- [ ] `toggleUserStatus(id, isActive)` — disable/enable account
- [ ] `getUserStats()` — total users, new today, etc.

RLS: Only admins can access these.

Report to `.bob/reports/2026-03-23-users-actions.md`

---

## Part 2: Layla — Frontend

Build `app/admin/users/page.tsx`:
- [ ] User grid with pagination
- [ ] Search by email/name
- [ ] Role toggle (customer → admin)
- [ ] Account status toggle (active/suspended)
- [ ] View user orders history

---

## Handoff

Bob writes handoff doc with action signatures, then Layla implements UI.
