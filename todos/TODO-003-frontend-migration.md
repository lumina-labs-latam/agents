# TODO-003: Frontend Tidy Up — Migrate Admin Pages to Server Actions

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** High  
**Estimated:** 2-3 hours  
**Depends on:** TODO-002 (Bob's API audit)  
**Assigned to:** Layla

---

## Objective

Migrate all admin pages from API route calls (`fetchAdminJson`) to direct server action imports.

---

## Current State

### ✅ Already Migrated (Server Actions)
| Page | Uses |
|------|------|
| `app/admin/page.tsx` (Dashboard) | `getOrderStats` from `@/lib/orders/actions` |
| `app/admin/orders/page.tsx` | `getOrders`, `updateOrderStatus`, `addOrderNote` |
| `app/admin/currencies/page.tsx` | `getCurrencies`, `createCurrency`, `updateCurrency`, `deleteCurrency` |
| `app/admin/reviews/page.tsx` | `getAllReviews`, `moderateReview`, `softDeleteReview`, `getReviewStats` |

### ❌ Needs Migration (API Routes via `fetchAdminJson`)
| Page | Current API Route | Likely Server Action Replacement |
|------|-------------------|----------------------------------|
| `app/admin/products/page.tsx` | `/api/admin/products` | `lib/catalog/actions.ts` |
| `app/admin/categories/page.tsx` | Likely API route | `lib/catalog/actions.ts` |
| `app/admin/users/page.tsx` | `/api/admin/users` | May need new actions |
| `app/admin/gamepass-help/page.tsx` | `/api/admin/gamepass-help` | `lib/store/actions.ts` |
| `app/admin/support-chat/page.tsx` | `/api/admin/support/*` | May need special handling |
| `app/admin/payment-methods/page.tsx` | Likely API route | `lib/store/actions.ts` |
| `app/admin/email-settings/page.tsx` | `/api/admin/email-settings` | May need new actions |
| `app/admin/audit-logs/page.tsx` | `/api/admin/audit-logs` | May need new actions |
| `app/admin/pricing/page.tsx` | `/api/admin/pricing` | May need new actions |
| `app/admin/exchange-rates/page.tsx` | Likely API route | May need new actions |
| `app/admin/robux-products/page.tsx` | Likely API route | May need new actions |
| `app/admin/in-game-items/page.tsx` | Likely API route | May need new actions |
| `app/admin/home-config/page.tsx` | Likely API route | May need new actions |

---

## Tasks

**Phase 1: Ready to migrate (actions exist)**
- [ ] `app/admin/products/page.tsx` → Use `lib/catalog/actions.ts`
- [ ] `app/admin/categories/page.tsx` → Use `lib/catalog/actions.ts`
- [ ] `app/admin/gamepass-help/page.tsx` → Use `lib/store/actions.ts`
- [ ] `app/admin/payment-methods/page.tsx` → Use `lib/store/actions.ts`

**Phase 2: Needs backend support**
- [ ] `app/admin/users/page.tsx` → Wait for Bob to create user actions
- [ ] `app/admin/support-chat/page.tsx` → Evaluate Realtime vs server actions
- [ ] `app/admin/email-settings/page.tsx` → Wait for Bob
- [ ] `app/admin/audit-logs/page.tsx` → Wait for Bob
- [ ] `app/admin/pricing/page.tsx` → Wait for Bob
- [ ] Other pages → Assess per Bob's audit report

**Phase 3: Cleanup**
- [ ] Remove `lib/admin/client.ts` if no longer needed
- [ ] Update `lib/admin/data.ts` if still needed
- [ ] Verify all migrated pages work correctly

---

## Migration Pattern

**Before (API route):**
```typescript
import { fetchAdminJson } from '@/lib/admin/client'

const response = await fetchAdminJson('/api/admin/products')
const data = await response.json()
```

**After (Server action):**
```typescript
import { getAllProducts } from '@/lib/catalog/actions'

const data = await getAllProducts()
```

---

## Deliverable

Report to `layla/reports/2026-03-23-frontend-migration.md`:
- Pages migrated
- Issues encountered
- Backend dependencies needed

---

## Handoff

If backend actions are missing, create handoff to **Bob** documenting what's needed.

---

## Notes

- Read Bob's audit report (TODO-002) before starting
- One page at a time — test after each migration
- Keep `lib/admin/client.ts` until ALL pages are migrated
- Support chat may need special real-time handling
