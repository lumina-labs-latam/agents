# TODO-001: Initialize Products Page

**Status:** 🔴 Ready to assign  
**Priority:** High  
**Estimated:** 2-3 hours  
**Assigned to:** (pending)

---

## Objective

Wire up the Products admin page with full CRUD via server actions.

---

## Requirements

### UI (Steve)
- [ ] Product grid with pagination
- [ ] Create product modal/form
- [ ] Edit product drawer
- [ ] Delete confirmation (soft delete)
- [ ] Image upload placeholder (Bob to wire actual upload)
- [ ] Category dropdown (fetch from DB)
- [ ] Status toggle (active/draft/archived)

### Backend (Layla)
- [ ] `getProducts()` — paginated list with filters
- [ ] `getProductById(id)` — single product for edit
- [ ] `createProduct(formData)` — Zod validation
- [ ] `updateProduct(id, formData)` — partial updates
- [ ] `deleteProduct(id)` — soft delete (set deleted_at)
- [ ] `getCategories()` — for dropdown

### Integration
- [ ] Error handling with toast notifications
- [ ] Optimistic updates for status toggle
- [ ] Revalidate on mutations

---

## Handoff Path

```
Steve (UI skeleton) → Layla (server actions) → Steve (wire together) → Bob (test deploy)
```

---

## References

- Pattern: See `frontend/app/[locale]/dashboard/orders/` for similar implementation
- Types: Use generated Supabase types
- i18n: Add keys to `messages/es.json` and `messages/en.json`

---

## Notes

Products table exists in Supabase. Schema:
```sql
id, name, description, price, category_id, image_url, 
stock, status, created_at, updated_at, deleted_at
```
