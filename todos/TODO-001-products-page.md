# TODO-001: Products Page — Full Stack Implementation

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** High  
**Estimated:** 3-4 hours split between Bob + Layla  
**Assigned to:** Bob (backend) → Layla (frontend)

---

## Objective

Build the Products admin page with full CRUD.

---

## Part 1: Bob — Server Actions

Create/modify `lib/catalog/actions.ts`:
- [ ] `getAllProducts()` — paginated list with filters (search, category, status)
- [ ] `getProductById(id)` — single product for edit
- [ ] `createProduct(formData)` — Zod validation, insert product
- [ ] `updateProduct(id, formData)` — partial updates
- [ ] `softDeleteProduct(id)` — soft delete (set deleted_at)
- [ ] `toggleProductActive(id, isActive)` — status toggle
- [ ] `getCategories()` — for dropdown (already exists, verify)

Report to `reports/bob/YYYY-MM-DD-products-actions.md`

---

## Part 2: Layla — Frontend UI

Build `app/admin/products/page.tsx`:
- [ ] Product grid/table with pagination
- [ ] Search/filter by name, category, status
- [ ] Create product modal/form
- [ ] Edit product drawer/sheet
- [ ] Delete confirmation dialog (soft delete)
- [ ] Image upload placeholder (Bob wires later)
- [ ] Category dropdown
- [ ] Status toggle (active/draft/archived)
- [ ] Stock management field
- [ ] Error handling with toast notifications
- [ ] Optimistic updates for status toggle
- [ ] i18n keys in `messages/es.json` and `messages/en.json`

---

## Handoff Path

```
Bob (server actions) → Layla (UI implementation)
```

---

## Notes

- Products table already exists in Supabase
- Pattern: See `app/admin/currencies/page.tsx` for established server action pattern
- Types: Use generated `lib/database.types.ts`
