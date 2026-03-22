# TODO-007: Store Settings Page — Migration + Polish

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** Medium  
**Estimated:** 1.5 hours  
**Depends on:** TODO-003  
**Assigned to:** Layla

---

## Objective

Migrate and polish the Store Settings page.

---

## Context

Server actions exist in `lib/store/actions.ts`:
- `getStore()` — get config
- `updateStore(formData)` — update name, description, colors, etc.
- `updatePaymentMethods(methods)` — toggle payment options
- `updateFAQs(faqs)` — manage FAQ list

---

## UI Requirements

- [ ] Store name & description
- [ ] Brand colors (primary, secondary)
- [ ] Logo upload placeholder
- [ ] Payment methods toggles (Yape, Plin, Bank Transfer, etc.)
- [ ] FAQ accordion editor
- [ ] Social links editor
- [ ] Contact info

---

## Pattern

See `app/test/store/page.tsx` for Bob's test implementation — use as reference.

---

## Notes

Payment method config may need special UI for QR codes (Yape/Plin).
