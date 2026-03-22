# TODO-009: Support Chat — Evaluate & Implement

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** Low  
**Estimated:** 4-8 hours (if real-time)  
**Assigned to:** Bob + Layla

---

## Objective

Implement or fix the Support Chat system.

---

## Current State

- API routes exist: `/api/admin/support/conversations`, `/messages`
- May need real-time via Supabase Realtime

---

## Part 1: Bob — Architecture Decision

Evaluate two approaches:
1. **Server Actions + Polling** — Simple, sufficient for low volume
2. **Supabase Realtime** — True real-time, more complex

Decision factors:
- Expected chat volume
- Real-time necessity
- Complexity budget

Report to `.bob/reports/2026-03-23-support-chat-decision.md`

---

## Part 2: Implementation

If simple approach:
- Server actions for send/receive
- Polling for new messages

If Realtime:
- Realtime subscription setup
- Optimistic UI updates

---

## UI Requirements (Layla)

- [ ] Conversation list sidebar
- [ ] Message thread view
- [ ] Send message input
- [ ] Customer info panel
- [ ] Unread indicators
