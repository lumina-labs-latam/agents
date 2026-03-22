# TODO-004: Products Page — UI Scaffold

**Project:** ~/repos/sakus-store/frontend
**Working Directory:** `~/repos/sakus-store`
**Status:** 🔴 Ready to assign  
**Priority:** High  
**Estimated:** 2 hours  
**Depends on:** TODO-003 (Layla's migration of existing pages)  
**Assigned to:** Layla

---

## Objective

Build the Products admin page UI on top of existing server actions.

---

## Context

Server actions already exist in `lib/catalog/actions.ts`:
- `getAllProducts()` — list all products
- `getProductById(id)` — single product
- `createProduct(formData)` — create
- `updateProduct(id, formData)` — update  
- `softDeleteProduct(id)` — soft delete
- `toggleProductActive(id, state)` — toggle status

Categories also available via `lib/catalog/actions.ts`.

---

## UI Requirements

- [ ] Product grid/table with pagination
- [ ] Search/filter by name, category, status
- [ ] Create product modal
- [ ] Edit product drawer/sheet
- [ ] Image upload (placeholder for now, Bob to wire later)
- [ ] Category dropdown (from existing getAllCategories)
- [ ] Status toggle (active/draft/archived)
- [ ] Soft delete with confirmation
- [ ] Stock management UI

---

## Data Model

```typescript
interface Product {
  id: string;
  name: string;
  description: string | null;
  price: number;
  category_id: string;
  image_url: string | null;
  stock: number;
  status: 'active' | 'draft' | 'archived';
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  category?: { name: string }; // joined
}
```

---

## Pattern to Follow

See `app/admin/currencies/page.tsx` for the established pattern:
- Server Component for data fetching
- Client components for interactivity
- Server actions for mutations
- Toast notifications for errors/success

---

## Deliverable

Working Products page at `/admin/products` with full CRUD.
