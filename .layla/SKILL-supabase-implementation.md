---
name: Supabase Implementation
description: Comprehensive patterns for implementing Supabase correctly in production-oriented apps, including Auth, Realtime, database access, RLS, server/client boundaries, and debugging.
---

## When to Use This Skill

Use this skill when the user is:
- Implementing Supabase features in Next.js, React, Node.js, or server environments.
- Adding authentication, OAuth, Realtime, Storage, or secure database access.
- Unsure whether logic should run in the browser, server component, route handler, server action, edge function, or background worker.
- Debugging RLS, auth sessions, OAuth redirects, Realtime subscriptions, or permission issues.
- Asking for the safest default architecture rather than a custom implementation.

## Core Defaults

- Prefer Supabase-managed features over custom implementations when Supabase already supports the use case.
- In Next.js App Router, prefer server-side, cookie-based auth.
- Treat RLS as mandatory for app data; authentication alone is not authorization.
- Never expose service role keys or OAuth client secrets to the browser.
- Use official Supabase flows first, then customize only where necessary.
- Separate browser-safe clients from privileged server-only clients.

## Quick Decision Rules

Use these defaults unless the user has a strong reason not to:

- Auth in Next.js: Supabase Auth with App Router and cookie-based auth.
- Google/Discord/GitHub login: Supabase social login via `signInWithOAuth`.
- User-facing database reads/writes: browser or server client with RLS enabled.
- Admin tasks, bots, cron jobs, webhooks: server-only client with service role key.
- Realtime in UI: browser client that respects RLS.
- Realtime in workers/bots: Node.js server process using service role key.
- Signed uploads/downloads or file permissions: Supabase Storage with bucket policies.
- Business logic with secrets: route handlers, server actions, Edge Functions, or backend services.

## Auth

### Default Recommendation

For Next.js projects, the default recommendation is:

- Use Supabase Auth.
- Use App Router.
- Use server-side, cookie-based auth.
- Use OAuth providers through `signInWithOAuth`.
- For Google, Discord, and similar providers, use a callback route that exchanges the auth code for a session.

Do not recommend building a custom OAuth flow unless the user has a very unusual requirement.

### Why This Is the Default

Supabase already handles:
- OAuth provider integration.
- Session issuance and refresh.
- Secure cookie-based session persistence.
- User identity storage in `auth.users`.
- Provider token handling where supported.

This avoids common security mistakes around token storage, redirect handling, and session management.

### Next.js Pattern

Recommended flow:

1. User clicks “Continue with Google” or “Continue with Discord”.
2. Call `supabase.auth.signInWithOAuth({ provider, options: { redirectTo } })`.
3. Provider redirects back to `/auth/callback?code=...`.
4. In `app/auth/callback/route.ts`, call `exchangeCodeForSession(code)`.
5. Redirect the user to a safe in-app path.
6. Session is stored in cookies.

### Minimal Implementation Notes

#### Browser client
Use the browser Supabase client only to initiate sign-in, read session state in client components, and perform user-scoped operations allowed by RLS.

#### Server client
Use the server Supabase client in route handlers, server components, and server actions where cookie-backed auth is needed.

#### Callback route
Always implement a callback route for PKCE/server-side auth.

```ts
import { NextResponse } from 'next/server'
import { createClient } from '@/utils/supabase/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  let next = searchParams.get('next') ?? '/'

  if (!next.startsWith('/')) next = '/'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    if (!error) {
      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  return NextResponse.redirect(`${origin}/auth/auth-code-error`)
}
```

### Social Login Example

```ts
'use client'

import { createClient } from '@/utils/supabase/client'

export async function signInWithGoogle() {
  const supabase = createClient()

  await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${location.origin}/auth/callback?next=/dashboard`,
    },
  })
}

export async function signInWithDiscord() {
  const supabase = createClient()

  await supabase.auth.signInWithOAuth({
    provider: 'discord',
    options: {
      redirectTo: `${location.origin}/auth/callback?next=/dashboard`,
    },
  })
}
```

### Provider Setup

#### Google
- Create a Google OAuth client of type Web application.
- Add your app origin under Authorized JavaScript origins.
- Add the Supabase callback URL under Authorized redirect URIs.
- Add the Google client ID and secret in Supabase Auth > Providers > Google.
- Prefer branding verification and a custom auth domain for user trust.

#### Discord
- Create an application in the Discord Developer Portal.
- Copy the client ID and client secret into Supabase Auth > Providers > Discord.
- Configure the redirect URL exactly as required by Supabase.

### Security Rules

- Never put OAuth client secrets in frontend code.
- Never expose the Supabase service role key to the browser.
- Prefer cookie-based auth over manually storing tokens in local storage.
- Restrict post-login redirects to relative paths only.
- Enable RLS on app tables and write explicit policies.
- Separate authentication concerns from authorization concerns.

### Common Gotchas

Issue: OAuth login succeeds at provider but user does not end up signed in.
Fix: Make sure the callback route exists and calls `exchangeCodeForSession(code)`.

Issue: Redirect mismatch error from Google or Discord.
Fix: Verify the provider dashboard redirect URI exactly matches the Supabase callback URL.

Issue: User is authenticated but still cannot read/write app data.
Fix: Check RLS policies; auth success does not bypass database authorization.

Issue: Works locally but fails in production.
Fix: Check Site URL, redirect allow list, forwarded host handling, provider origins, and environment variables.

Issue: Open redirect risk after login.
Fix: Only allow relative `next` paths.

## RLS

### Golden Rule

Authentication proves who the user is. RLS determines what that user can access. If RLS is missing or wrong, auth alone does not protect your data correctly.

### Defaults

- Enable RLS on application tables.
- Write explicit `SELECT`, `INSERT`, `UPDATE`, and `DELETE` policies as needed.
- Base policies on `auth.uid()` or approved JWT claims.
- Test policies as an authenticated user, not only with admin queries.

### Common Failure Pattern

A frequent issue is: login works, queries still fail, and developers assume Supabase Auth is broken. In most cases, the real cause is missing or overly strict RLS policies.

### Debug Checklist

```sql
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```

```sql
SELECT policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'yourtable';
```

## Realtime

### When to Use Realtime

Use Realtime for live dashboards, notifications, collaborative UIs, status updates, chat-like experiences, or bots/workers reacting to database changes.

### Database Setup: The Critical First Step

The most common reason Realtime does not work is that the table is not actually in the `supabase_realtime` publication.

Always verify publication membership with SQL. Do not rely on comments, assumptions, or dashboard memory.

```sql
ALTER PUBLICATION supabase_realtime ADD TABLE yourtable;
```

```sql
SELECT *
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
  AND tablename = 'yourtable';
```

Must return 1 row. If it returns 0 rows, events will not arrive.

### Table Requirements

1. The table must be in the Realtime publication.
2. The subscription respects RLS policies in browser usage.
3. Tables without a suitable replica identity may need `REPLICA IDENTITY FULL`.

```sql
ALTER TABLE yourtable REPLICA IDENTITY FULL;
```

### Filter Syntax Common Pitfall

Correct:

```ts
filter: `organization_id=eq.${organizationId}`
```

Wrong:

```ts
filter: `organization_id = eq.${organizationId}`
filter: `organization_id=${organizationId}`
```

Rules:
- No spaces in the filter expression.
- Include the operator such as `eq.`.
- Supported operators include `eq`, `neq`, `gt`, `gte`, `lt`, `lte`, `in`.

### React Hook Pattern: Browser Client

```ts
'use client'

import { useEffect, useRef } from 'react'
import { getSupabaseBrowserClient } from '@/lib/supabase/client'

interface UseRealtimeOptions<T> {
  organizationId: string | null
  onInsert?: (record: T) => void
  onUpdate?: (record: T) => void
  onDelete?: (id: string) => void
}

export function useRealtimeTable<T extends { id: string }>({
  organizationId,
  onInsert,
  onUpdate,
  onDelete,
}: UseRealtimeOptions<T>) {
  const callbacksRef = useRef({ onInsert, onUpdate, onDelete })

  useEffect(() => {
    callbacksRef.current = { onInsert, onUpdate, onDelete }
  }, [onInsert, onUpdate, onDelete])

  useEffect(() => {
    if (!organizationId) return

    let mounted = true
    const supabase = getSupabaseBrowserClient()

    const channel = supabase
      .channel(`yourtable-${organizationId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'yourtable',
          filter: `organization_id=eq.${organizationId}`,
        },
        payload => {
          if (!mounted) return
          callbacksRef.current.onInsert?.(payload.new as T)
        }
      )
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'yourtable',
          filter: `organization_id=eq.${organizationId}`,
        },
        payload => {
          if (!mounted) return
          callbacksRef.current.onUpdate?.(payload.new as T)
        }
      )
      .on(
        'postgres_changes',
        {
          event: 'DELETE',
          schema: 'public',
          table: 'yourtable',
          filter: `organization_id=eq.${organizationId}`,
        },
        payload => {
          if (!mounted) return
          callbacksRef.current.onDelete?.((payload.old as { id: string }).id)
        }
      )
      .subscribe((status, err) => {
        console.log('Realtime status', status)
        if (err) console.error('Realtime error', err)
      })

    return () => {
      mounted = false
      supabase.removeChannel(channel)
    }
  }, [organizationId])
}
```

### Why This Pattern Works

- `useRef` for callbacks prevents unnecessary re-subscription when parent callbacks change.
- A `mounted` flag avoids state updates after unmount during async work.
- Logging subscription status is essential for debugging.
- Cleanup with `removeChannel` prevents leaks and duplicate listeners.

### Node.js Bot Pattern: Service Role

Use a server-side Supabase client with the service role key for bots, workers, and backend processes. Never expose this key to the browser.

```ts
import { createClient } from '@supabase/supabase-js'

export class RealtimeNotifier {
  private supabase
  private channel: ReturnType<typeof this.supabase.channel> | null = null

  constructor(
    private orgId: string,
    supabaseUrl: string,
    serviceRoleKey: string
  ) {
    this.supabase = createClient(supabaseUrl, serviceRoleKey)
  }

  start() {
    this.channel = this.supabase
      .channel(`bot-${this.orgId}`)
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'appointment_requests',
          filter: `organization_id=eq.${this.orgId}`,
        },
        payload => this.handleUpdate(payload)
      )
      .subscribe((status, err) => {
        console.log('Realtime status', status)
        if (err) console.error('Realtime error', err)
      })
  }

  private async handleUpdate(payload: any) {
    const newRecord = payload.new as { id: string; status: string }

    if (newRecord.status !== 'approved' && newRecord.status !== 'rejected') {
      return
    }

    await this.sendNotification(newRecord)
  }

  private async sendNotification(record: { id: string; status: string }) {
    // Implement notification logic here
  }

  stop() {
    if (this.channel) {
      this.supabase.removeChannel(this.channel)
    }
  }
}
```

### The `payload.old` Trap

Supabase Realtime often sends minimal data in `payload.old` for UPDATE events.
Do not rely on `payload.old.status` or other old fields being complete.
Check the new record state instead.

Wrong:

```ts
if (payload.old.status === 'pending') {
  // unreliable
}
```

Correct:

```ts
const newStatus = payload.new.status
if (newStatus === 'approved' || newStatus === 'rejected') {
  // process final state
}
```

### Debugging Checklist

1. Check subscription status.
2. Verify the table is in the publication.
3. Test with a manual INSERT or UPDATE.
4. Temporarily remove filters.
5. Check RLS policies.
6. Confirm the client is using the expected user/session.

```ts
.subscribe((status, err) => {
  console.log('Status', status)
  if (err) console.error(err)
})
```

```sql
SELECT *
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
  AND tablename = 'yourtable';
```

### Common Gotchas

- Table not in publication: no events arrive.
- Filter contains spaces: events are silently filtered out.
- Missing `eq.` in filter: events do not match.
- Only listening for INSERT: updates and deletes are missed.
- No status callback: failures are hard to diagnose.
- RLS blocks SELECT: browser client shows SUBSCRIBED but receives no data.
- Reusing channel names carelessly: odd collisions can happen.
- No cleanup on unmount: duplicate listeners and memory leaks.

## Storage

### Defaults

- Use Supabase Storage for user-uploaded files instead of storing binary data in Postgres.
- Protect private buckets with policies; do not assume bucket privacy alone is enough.
- Generate signed URLs for temporary access when files should not be public.
- Perform privileged file operations on the server when secrets or elevated permissions are required.

### Common Pattern

- Public assets: public bucket, cache-friendly URLs.
- Private assets: private bucket plus signed URLs.
- User uploads: browser upload only when RLS and policies are correct; otherwise, upload through a secure server path.

## Server vs Browser

### Browser client
Use for user-scoped reads/writes, initiating auth, and Realtime in the UI. It must rely on RLS and only use safe public configuration.

### Server client
Use for cookie-backed auth in Next.js, secure joins, route handlers, server actions, and trusted backend logic.

### Service role client
Use only on the server for admin tasks, bots, cron jobs, imports, webhooks, and maintenance operations. It bypasses RLS, so treat it like root access.

## Environment Variables

### Browser-safe
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` or the current browser-safe public key used by your project setup

### Server-only
- `SUPABASE_SERVICE_ROLE_KEY`
- OAuth client secrets
- Any other backend integration secrets

Rule: if leaking the value would grant elevated access, it must stay server-only.

## Implementation Checklist

When helping a user implement Supabase, prefer this order:

1. Identify whether the code belongs in browser, server, or privileged backend.
2. Choose the default supported Supabase feature before suggesting custom code.
3. Check auth and session handling.
4. Check RLS and policies.
5. Add status logging and verification queries for anything stateful or realtime.
6. Only then debug edge cases.

## Recommendation Logic For The Agent

When a user asks for the most straightforward and secure approach, default to the official Supabase-supported path:

- Auth: Supabase Auth with cookie-based Next.js setup.
- Social login: provider setup in Supabase plus `signInWithOAuth`.
- Data access: RLS-protected queries.
- Realtime: publication verification, correct filters, and status logging.
- Privileged tasks: service role on the server only.

Only recommend alternatives such as custom auth systems or third-party abstractions when the user's requirements clearly exceed what Supabase handles well.

## Related Documentation To Check

- Supabase Auth quickstart for Next.js.
- Supabase social login docs.
- Supabase Realtime and Postgres changes docs.
- Supabase RLS policy guides.
- Supabase Storage guides.

When in doubt, prefer official Supabase documentation and operational verification over assumptions.
