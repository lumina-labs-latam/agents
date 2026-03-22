# TODO-005: Categories Page — Full Implementation

**Status:** 🔴 Ready to assign  
**Priority:** High  
**Estimated:** 1.5 hours  
**Depends on:** TODO-003  
**Assigned to:** Layla

---

## Objective

Build the Categories admin page.

---

## Context

Server actions exist in `lib/catalog/actions.ts`:
- `getAllCategories()` — list all
- `createCategory(formData)` — create
- `updateCategory(id, formData)` — update
- `softDeleteCategory(id)` — soft delete

---

## UI Requirements

- [ ] Category list with product count
- [ ] Create category modal
- [ ] Edit category drawer
- [ ] Soft delete with confirmation
- [ ] Drag-to-reorder (optional, nice to have)
- [ ] Color/icon picker for category

---

## Data Model

```typescript
interface Category {
  id: string;
  name: string;
  description: string | null;
  color: string | null;
  icon: string | null;
  sort_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
}
```

---

## Notes

Simpler than Products — use as a warm-up if TODO-004 is too big.
