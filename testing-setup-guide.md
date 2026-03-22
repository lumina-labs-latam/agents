# Testing Setup Guide (pgTAP + Local Supabase)

## What you need (one-time setup)

### 1. Install Supabase CLI

If you don't have it yet:

```bash
# macOS
brew install supabase/tap/supabase

# Linux
curl -sSL https://raw.githubusercontent.com/supabase/cli/main/install.sh | bash

# npm (any OS)
npm install -g supabase
```

Verify: `supabase --version` (must be v1.11.4 or later)

### 2. Initialize local Supabase (if not already done)

```bash
# In your project root
supabase init    # Creates supabase/ directory with config.toml
supabase start   # Starts local Postgres, Auth, Storage, etc.
```

`supabase start` launches a local Supabase stack via Docker. First run
downloads images and takes a few minutes. Subsequent starts are fast.

After starting, you'll see local URLs and keys printed to the terminal.
You don't need to configure anything — tests run against this local instance
automatically.

### 3. Apply your migrations locally

```bash
# If you have existing migrations in supabase/migrations/
supabase db reset   # Drops and recreates the local DB from migrations
```

**Every time Steve creates a new migration**, run `supabase db reset` to
apply it locally before running tests.

### 4. That's it

Viktor will create the `supabase/tests/` directory and all test files,
including the setup file that installs the test helpers extension.
You just need local Supabase running.

---

## How to use Viktor

### After Steve finishes a schema change:

```
1. supabase db reset              # Apply latest migrations locally
2. Tell Viktor: "Steve finished a migration. Test the new schema."
3. Viktor reads Steve's business rules + migration report
4. Viktor generates .sql test files in supabase/tests/
5. Viktor runs: supabase test db
6. Viktor writes results to .viktor/reports/
```

### Running tests yourself:

```bash
# Run all tests
supabase test db

# Output looks like:
# ./00000-test-helpers.sql .. ok
# ./00001-rls-enabled.sql .. ok
# ./01001-sessions-rls.sql .. ok
# All tests successful.
# Files=3, Tests=24, 0 wallclock secs
# Result: PASS
```

### If tests fail:

Viktor's report in `.viktor/reports/` tells you which business rule failed
and assigns it to Steve (schema bug) or Bob (server action bug). That agent
fixes the issue, you run `supabase db reset`, then tell Viktor to re-test.

---

## The full pipeline

```
You: "Add appointment scheduling"
  ↓
Steve → designs schema, writes migration report → .steve/reports/
  ↓
You: supabase db reset (apply migration locally)
  ↓
Viktor → tests schema against business rules → .viktor/reports/
  ↓ (all pass? continue. failures? Steve fixes first)
Bob → implements server actions → writes report → .bob/reports/
  ↓
Viktor → can test DB-level behavior of new actions → .viktor/reports/
  ↓ (all pass? continue. failures? Bob fixes first)
Layla → reads Bob's report, builds the UI
  ↓
You: test UI manually
  ↓
(If Layla hits a bug she can't fix after 3 attempts)
  ↓
Layla → writes bug report → .layla/reports/
  ↓
Archy → fixes it, writes resolution → same report file
  ↓
You: use resolution to improve agent prompts
```

---

## Quick reference

| Command | When to use |
|---|---|
| `supabase start` | Start local Supabase (first time or after restart) |
| `supabase stop` | Stop local Supabase |
| `supabase db reset` | Reapply all migrations from scratch |
| `supabase test db` | Run all pgTAP tests |
| `supabase test new test-name` | Create a new blank test file |

## Report directories

| Agent | Directory |
|---|---|
| Steve | `.steve/reports/` |
| Bob | `.bob/reports/` |
| Layla | `.layla/reports/` |
| Viktor | `.viktor/reports/` |
| Archy | Writes into the original agent's report file |
