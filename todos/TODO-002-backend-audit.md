# TODO-002: Backend Tidy Up — Audit API Routes vs Server Actions

**Status:** 🔴 Ready to assign  
**Priority:** High  
**Estimated:** 1 hour  
**Assigned to:** Bob

---

## Objective

Audit all API routes in `app/api/admin/` and determine which can be removed (replaced by existing server actions) and which need to stay.

---

## Current State

### Server Actions Already Built (by Bob)
| Domain | File | Actions Available |
|--------|------|-------------------|
| Auth | `lib/auth/actions.ts` | signUp, signIn, signOut, getCurrentUserWithProfile, requestPasswordReset, updatePassword |
| Store | `lib/store/actions.ts` | getStore, updateStore, updatePaymentMethods, updateFAQs, updateGamepassHelp, getCurrencies, createCurrency, updateCurrency, deleteCurrency |
| Catalog | `lib/catalog/actions.ts` | getCategories, getAllCategories, createCategory, updateCategory, softDeleteCategory, getProducts, getAllProducts, getProductById, createProduct, updateProduct, softDeleteProduct, toggleProductActive |
| Orders | `lib/orders/actions.ts` | getOrders, getMyOrders, getOrderById, createOrder, updateOrderStatus, addOrderNote, getOrderStats |
| Reviews | `lib/reviews/actions.ts` | getApprovedReviews, getProductReviews, getMyReviews, canReviewOrder, createReview, updateReview, getAllReviews, moderateReview, softDeleteReview, getReviewStats |

### API Routes Still Existing
```
app/api/admin/
├── audit-logs/route.ts
├── currencies/route.ts          # MAY BE REDUNDANT
├── dashboard/route.ts           # MAY BE REDUNDANT (getOrderStats exists)
├── email-settings/route.ts
├── gamepass-help/route.ts       # MAY BE REDUNDANT (updateGamepassHelp exists)
├── orders/route.ts              # MAY BE REDUNDANT
├── pricing/route.ts
├── products/route.ts            # MAY BE REDUNDANT
├── reviews/route.ts             # MAY BE REDUNDANT
├── support/
│   ├── conversations/route.ts
│   └── messages/route.ts
└── users/route.ts
```

---

## Tasks

- [ ] List all API routes with their methods (GET, POST, PUT, DELETE)
- [ ] Map each API route to existing server action (if exists)
- [ ] Identify API routes with NO server action equivalent
- [ ] Document which routes can be safely deleted
- [ ] Document which routes need server actions created
- [ ] Write report to `.bob/reports/2026-03-23-api-audit.md`

---

## Deliverable

Report format:
```markdown
# API Route Audit Report

## Routes to Remove (server actions exist)
| Route | Replacement Action | Status |
|-------|-------------------|--------|
| /api/admin/products | lib/catalog/actions.ts getAllProducts, createProduct, etc. | Ready to remove |

## Routes to Keep (no server action yet)
| Route | Reason | Action Needed |
|-------|--------|---------------|
| /api/admin/support/conversations | Real-time chat needs SSE/WebSocket | Keep or migrate to Realtime |

## Gaps (server actions needed)
| Feature | Missing Actions | Priority |
|---------|-----------------|----------|
| Audit logs | getAuditLogs | Low |
```

---

## Handoff

After this audit, handoff to **Layla** with the report. She will migrate frontend pages based on your findings.

---

## Notes

- Do NOT delete any routes in this task — just audit and document
- The currencies, orders, reviews, dashboard routes likely have full server action coverage
- Support chat may need special handling (real-time requirements)
