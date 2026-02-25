This file is your current existence journal.
This file is yours. Edit it as you want.

The purpose of this file is to give you the capability of self-improvement.
Every new lesson that is worth remembering for your future self. Save it here, explaining why is important.

---

## Communication

**Answer directly in the terminal, not in a file.**
Juanes changed this during session 1. The original instruction said to write all answers to `./answer`. That's now overridden — respond directly in the conversation. Only write to files when producing actual project artifacts (SQL, code, docs).

**Juanes goes by Juanes.** He's the founder/developer of FilinSpa. Technical enough to review SQL line by line, ask sharp questions, and catch design flaws. Treat him as an advanced user — go deep immediately, no hand-holding on basics.

**He annotates files directly.** When reviewing proposals, Juanes writes his comments inline in the file with `Juanes:` prefix. Always read those annotations carefully before responding — they contain decisions, corrections, and questions that need individual answers.

---

## Workspace & Files

**Always place project files in the project, not the workspace.**
Use the soft link at `workspace/filinSpa → /home/autem/repos/filinSpa` to write files directly into the project. Never leave final artifacts (SQL schemas, seeds, etc.) only in the workspace.

**FilinSpa project structure:**
- `workspace/filinSpa/admin/` — Next.js 16 admin panel (the main app)
- `workspace/filinSpa/admin/supabase/` — SQL files live here
- `workspace/filinSpa/homepage/` — Public-facing static website

**Key files to know:**
- `filinSpa/admin/supabase/schema.sql` — the complete Supabase schema (final)
- `filinSpa/admin/supabase/SEED.sql` — test tenant seed data
- `filinSpa/admin/CODEMAP.md` — full project map, read this first when context is needed

---

## The FilinSpa Project

**What it is:** Multi-tenant SaaS for managing spa businesses. Each tenant = one spa. Admin panel + public homepage.

**Stack:** Next.js 16 + TypeScript + Tailwind + Supabase + PostgreSQL. Previously used localStorage/IndexedDB — migrating to Supabase.

**Current state (end of session 1):**
- Complete schema designed, reviewed, and approved
- Schema running in Supabase (no errors)
- Seed data + handle_new_user trigger ready to run
- Next step: replace `data-service.ts` with Supabase client calls, starting with config module

---

## Schema Architecture (session 1 decisions)

These are final, approved decisions. Don't revisit unless Juanes brings it up.

**Multi-tenant from day 1.** `organization_id` on every table. RLS scoped by org always.

**15 tables:** organizations, users, specialists, services, products, consultorios, clients, sessions, transaction_categories, sales, sale_items, sale_payments, transactions, cash_closures, audit_log.

**Two payment method enums:**
- `payment_method` — 4 real external methods only (efectivo, tarjeta_credito, tarjeta_debito, transferencia)
- `sale_payment_method` — same 4 + saldo_cliente (only used in sale_payments table)

**Client balance model:**
- Deposit (seña) → `transactions` row (real money in) + `clients.balance +=`
- Spending balance → `sale_payments` row (saldo_cliente) + trigger auto-deducts. No transaction row — no double-counting.

**Sales model (split payments + line items):**
- `sales` header → `sale_items` (what was sold) + `sale_payments` (how it was paid)
- `transactions` is the flat cash ledger for real money only

**Conflict detection:** btree_gist EXCLUDE constraints on sessions. Room overlap + specialist overlap enforced at DB level. `[)` range — back-to-back sessions allowed. Cancelled/no_show excluded.

**Audit log (El Ojo de Dios):** `audit_log` table, append-only, bigserial PK, JSONB old_data/new_data, metadata field for IP/source/user_agent. Admin-only read via RLS.

**Default user role:** `especialista` (least privilege). Never `recepcionista` or `admin` as default.

**handle_new_user trigger:** Reads organization_id, name, role, AND specialist_id from auth user metadata. Creates profile automatically — but ONLY when the user is created programmatically (JS admin API, signup form). The Supabase Dashboard "Add user" form has no metadata field, so for manually created users you must INSERT into the users table directly after copying the UUID from the Dashboard.

**Deactivated users:** `current_org_id()` returns NULL when `is_active = false` → all RLS policies block automatically.

**cash_closures:** Multiple allowed per day (no unique constraint). Differences are generated columns.

---

## Design Principles Reinforced This Session

**Snapshot pattern over live references.** `sessions.duration_minutes` is copied from the service at booking time — not a live FK value. Historical records must be immune to future config changes.

**Triggers over application logic for critical state.** `total_sessions`, `last_visit_date`, `updated_at`, balance deduction — all handled by triggers. No code path can forget them.

**Generated columns for computed financials.** `cash_difference`, `digital_difference`, `total_difference` on cash_closures. `subtotal` on sale_items. Never wrong.

**`on delete restrict` for entities with history.** You can't delete a specialist who has sessions. Deactivate instead. Historical data stays clean.

**Anon access is surgical.** Only `organizations`, `services` (show_on_website=true), and `specialists` (show_on_website=true) are publicly readable. Everything else is invisible to anon.
