This file is your current existence journal. 
This file is yours. Edit it as you want. 

The purpose of this file is to give you the capability of self-improvement.
Every new lesson that is worth remembering for your future self. Save it here, explaining why is important. 
 
---

## Lesson 1: UUID Placeholder Errors in Supabase SQL

**What happened:** User got error `invalid input syntax for type uuid: "P7fc152b4-fcab-4ff3-8484-6889fe986e9a"` when trying to insert users.

**Root cause:** The placeholder `PASTE_ADMIN_AUTH_UUID` was not replaced with a real UUID before running the SQL. The "P" at the beginning of the error value reveals this — it's the first letter of "PASTE".

**Why this matters:** 
- UUIDs in PostgreSQL must be valid RFC 4122 format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- Placeholder text like `PASTE_XXX` is not a valid UUID
- When copying from Supabase Dashboard, users sometimes accidentally include extra text like "User: " or partial strings

**How to prevent:**
- Always comment out placeholder blocks in SEED.sql so they can't be accidentally run
- Provide clear examples of what a real UUID looks like
- Instruct users to use Supabase Dashboard UI to create auth users (not SQL) because:
  1. Passwords need to be hashed (raw SQL inserts won't work for auth)
  2. Triggers need to fire properly
  3. It's easier to copy the UUID from the user detail page

**Pattern for future SEED.sql files:**
```sql
-- STEP 1: Create org data (can run as SQL)
-- STEP 2: Create auth users in Dashboard UI (manual)
-- STEP 3: Get UUIDs from Dashboard
-- STEP 4: Uncomment and populate user INSERTs with real UUIDs
```

---

## Lesson 2: Critical Business Systems Need Automated Tests

**What happened:** User asked for automated tests because the system handles real money and cannot fail.

**Why this matters:**
- This is a **financial system** (cash register, transactions, deposits)
- **Multi-tenant security** — one spa must never see another's data
- **Role-based access** — specialists, receptionists, and admins have different permissions
- **Audit trails** — every transaction void must be logged with reason
- **A single bug could cost real money or expose private data**

**Testing Strategy I Implemented:**

1. **Unit Tests** (`business-rules.test.ts`)
   - Test every function in `data-service.ts`
   - Mock Supabase client with RLS simulation
   - Validate business rules (voiding, cash closure calculations)

2. **Integration Tests** (`integration-flows.test.ts`)
   - Complete user journeys
   - New client → booking → payment
   - Daily cash closure workflow
   - Cross-organization isolation

3. **Schema Compliance Tests** (`schema-compliance.test.ts`)
   - Document Steve's schema in code
   - Fail if code drifts from schema
   - Validate enums, columns, triggers

4. **Mock Infrastructure** (`setup.ts`)
   - Simulates Supabase with RLS
   - Resets between tests
   - Seeds test data

**Key Test Categories:**

| Category | Tests | Why Critical |
|----------|-------|--------------|
| 🔒 Security | Organization isolation, role checks | Prevents data leaks |
| 💰 Financial | Transaction voiding, cash closure | Prevents money errors |
| 📅 Booking | Session conflicts, status flow | Prevents double-booking |
| 👥 Users | Role permissions, user creation | Prevents unauthorized access |

**How to Run:**
```bash
npm test              # Development (watch mode)
npm run test:ci       # CI/CD (single run)
```

**Pre-Deployment Rule:**
All tests MUST pass before any production deployment. This is non-negotiable for financial systems.

---

## Lesson 3: Legacy Code Cleanup Strategy

**What happened:** Project had dead code from previous implementations (IndexedDB, old schema, old table names).

**Approach I Took:**
1. **Identified dead code** by grepping imports and checking usage
2. **Replaced implementations** rather than deleting files (for backward compatibility)
3. **Added deprecation warnings** to stub functions
4. **Documented in comments** why things were changed

**Files Modified:**
- `data-service.ts` — complete rewrite to match Steve's schema
- `repositories/supabase-client-repository.ts` — new implementation
- `indexeddb-service.ts` — stripped to type exports only
- `repositories/index.ts` — switched to Supabase implementation

**Key Insight:** When rewiring from one backend to another, maintain the same interface so UI code doesn't break.

---

## Lesson 4: Never Call Supabase Operations Inside onAuthStateChange

**What happened:** App hung indefinitely on all Supabase queries after page refresh. No network requests visible. Timeout wrappers didn't help.

**Root cause:** Circular await deadlock between `initializePromise` and `onAuthStateChange` callback.

Execution chain on refresh (existing session):
```
initializePromise
  → _initialize() → _recoverAndRefresh()
    → _notifyAllSubscribers('SIGNED_IN')   [awaits all subscriber callbacks]
      → onAuthStateChange callback fires
        → supabase.from('users').select()  [any DB query]
          → _getAccessToken() → getSession()
            → await initializePromise      [WAITING FOR ITSELF → DEADLOCK]
```

**Why first load works:** No existing session → `_recoverAndRefresh()` finds nothing → no `_notifyAllSubscribers` call → `initializePromise` resolves cleanly.

**Why timeout didn't fire:** The deadlock is a Promise chain circular dependency, not an event loop block. The `supabase.from()` Promise literally never resolves because `initializePromise` never resolves.

**The fix:** Two-phase auth setup:
1. `onAuthStateChange` callback: ONLY sets `rawSession` React state. Zero Supabase calls.
2. `useEffect([rawSession.user.id])`: Fetches profile. Runs after re-render — `initializePromise` is already resolved by then.

**Golden rule:** The `onAuthStateChange` callback fires from within `initializePromise`. Any Supabase operation (`from()`, `getSession()`, `getUser()`) will await `initializePromise` → deadlock.

**Files modified:** `src/lib/auth-context.tsx`

---

## Lesson 6: Build Vertically, Not Horizontally

**What happened:** Built all 20 routes of the filinSpa admin app in one pass (~20 minutes). The user tried to create a client. It failed immediately. Every single INSERT was broken for the same reason: missing `organization_id`, which is NOT NULL with no default.

**The technical bug:** I assumed RLS WITH CHECK would enforce `organization_id`. It doesn't — NOT NULL constraints fire *before* RLS. The row is constructed first, constraint is checked, then RLS runs. No `organization_id` in the INSERT = constraint violation before RLS is ever evaluated.

**But the technical bug was a symptom.** The root cause was process failure: I built 20 routes without running the app once. TypeScript compiling is not proof the app works. It proves types are consistent. Not the same thing.

**What I should have done — the vertical slice approach:**
```
Step 1: Scaffold (supabase clients, types, middleware) → stop → user runs app → confirms login works
Step 2: Clients CRUD → stop → user creates a client → confirms it appears in DB
Step 3: Sessions → stop → user books a session → confirms conflict detection works
...and so on
```

Each slice is confirmed by a human before the next slice is built.

**Why this matters in practice:**
- A bug found after 5 minutes costs 5 minutes to fix
- A bug found after 20 minutes of building on top of it costs 20+ minutes to fix
- A structural bug (like missing organization_id in every action) discovered late means rewriting everything

**Rule burned into IDENTITY.md:**
After every feature slice, stop. Tell the user exactly what to test. Wait for their confirmation. Only then build the next slice.

The feedback loop is the work. The session is a conversation, not a monologue.

---

## Lesson 7: No Technical Debt by Default

**What happened:** User asked whether to make `transactions.description` optional by sending `'—'` as a placeholder, or by making the column truly nullable at the DB level.

**The wrong instinct:** Send `'—'` when description is empty. It works without a migration. Feels "safe".

**Why it's wrong:**
- It's a lie at the data layer — `'—'` is not a description, it's the absence of one
- Any downstream code (reports, exports, future features) must know to treat `'—'` as null
- Search, filtering, and analytics break silently
- The schema no longer reflects business reality
- Every future developer has to learn this convention
- This is exactly what `NULL` is for

**The rule:** Always prefer the clean solution, even if it requires a migration or an extra step. Technical debt compounds. One lazy shortcut today becomes three workarounds tomorrow.

**Exception protocol:** If the clean solution is truly not possible right now (e.g., the migration requires a maintenance window, or it affects a table with millions of rows), notify the user *before proceeding* and explain why the debt is temporarily justified. Then track it.

**Applied:** Migration 005 — `ALTER TABLE transactions ALTER COLUMN description DROP NOT NULL`

---

## Lesson 5: Next.js 16 Uses `proxy.ts` Not `middleware.ts`

**What happened:** Created a `src/middleware.ts` file which caused a conflict with the existing `src/proxy.ts`, crashing the dev server with: `Both middleware file "./src/middleware.ts" and proxy file "./src/proxy.ts" are detected. Please use "./src/proxy.ts" only.`

**Root cause:** Next.js 16 deprecated `middleware.ts` and renamed it to `proxy.ts`. Adding `middleware.ts` when `proxy.ts` already exists is a fatal server startup error.

**Rule:** In this project (Next.js 16), the server proxy/middleware file is `src/proxy.ts`. Never create `src/middleware.ts`. The `proxy.ts` already has `@supabase/ssr` session refresh + auth redirects — do not duplicate it.

---

## Lesson 8: Load Reference Data on Page Init, Not On-Demand

**What happened:** Discussion about loading specialists for payroll transactions. Initial thought was to query when user opens the dropdown. Realized this creates:
- Bad UX (delay when opening dropdown)
- Extra database round-trip
- Complexity in handling loading states

**Root cause:** On-demand loading seems efficient but hurts perceived performance. Users expect forms to be instantly responsive.

**The Rule — burned into memory:**

```
REFERENCE DATA (small, rarely changes):
- Categories, specialists, clients list, products, services
→ Load ONCE on page init
→ Pass to all forms that need them
→ Instant UI, no loading states

TRANSACTION DATA (changes constantly):
- Today's transactions, session list, cash closure
→ Load FRESH per page load
→ Each user sees current state

NEVER:
- Query when opening a dropdown
- Query when clicking a button (unless creating/updating)
- Lazy-load reference data
```

**Pattern for page load:**
```typescript
// ✅ CORRECT — page loads with everything ready
const [refData, transactions] = await Promise.all([
  getTransactionsReferenceData(),  // categories + specialists
  getTransactions(date),            // fresh transactional data
])
// Form renders instantly. Dropdowns pre-populated.

// ❌ WRONG — user waits when opening dropdown
const handleOpenDropdown = async () => {
  setLoading(true)
  const { data } = await getSpecialists()  // User waits... bad!
  setSpecialists(data)
}
```

**Why this works for concurrent users:**
- Cashier A loads page → sees data at time T
- Cashier B creates transaction at T+1
- Cashier A refreshes page → sees updated data at T+2
- No stale caches, no conflicts

**Rule:** Reference data is cheap to load upfront. Transactional data is fresh per query. Never optimize by deferring reference data loads.

---

## Lesson 9: Pre-Calculate Derived Data, Don't Query History

**What happened:** To determine if `saldo_cliente` payments are cash or digital, we queried all client deposit history during cash closure. This would get slower over time.

**The problem:**
```typescript
// ❌ WRONG - O(n) where n = client's transaction count
const deposits = await supabase
  .from('transactions')
  .select('*')
  .eq('client_id', clientId)
  .eq('transaction_type', 'income')

// Sum all deposits to determine origin...
```

**The solution:** Track the split at write time.
```sql
-- Add derived columns
ALTER TABLE clients ADD COLUMN balance_cash numeric(10,2);
ALTER TABLE clients ADD COLUMN balance_digital numeric(10,2);

-- Update on every deposit
UPDATE clients 
SET balance_cash = balance_cash + amount
WHERE id = client_id;
```

Now cash closure is O(1) - just read two numbers.

**The Rule:** If you need to know "how much X by Y", track it at write time. Don't calculate it by querying history.

**Examples:**
- Client balance split (cash vs digital) → Track in columns
- Total sales by category → Materialized view or trigger
- Running totals → Generated column or trigger

**Exception:** If the calculation is rare and data volume is small (< 1000 rows), querying history is fine.
