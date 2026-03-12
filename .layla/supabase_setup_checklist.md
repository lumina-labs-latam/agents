# Supabase CLI Setup Checklist

A complete guide for setting up Supabase with CLI-first workflow (minimal dashboard usage).

## Phase 1: Initial Project Setup

### 1.1 Install Supabase CLI
```bash
# Option A: Global install (recommended)
npm install -g supabase

# Option B: Use npx (no install)
npx supabase <command>
```

### 1.2 Login to Supabase
```bash
supabase login
# Opens browser for authentication
# Stores credentials securely for CLI access
```

### 1.3 Initialize Project
**Run from within your frontend/ directory:**
```bash
cd frontend
supabase init
```

**Creates:**
```
frontend/supabase/
├── config.toml          # Project configuration
├── seed.sql             # Database seed data
├── migrations/          # SQL migrations folder
└── .temp/               # Auth tokens & temp files (gitignored)
```

### 1.4 Link to Remote Project
```bash
supabase link --project-ref <your-project-ref>
# Get project-ref from: https://app.supabase.com/project/_/settings/general
# Or ask your client for the project reference
```

**What this does:**
- Associates local CLI with remote Supabase project
- Enables pulling/pushing database changes
- Syncs configurations

---

## Phase 2: Local Development Environment

### 2.1 Start Local Supabase
```bash
supabase start
```

**Output shows:**
- Studio URL: http://127.0.0.1:54323
- API URL: http://127.0.0.1:54321
- Database URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
- Anon Key: (copy this)
- Service Role Key: (copy this)

### 2.2 Access Local Services

| Service | URL | CLI Access |
|---------|-----|------------|
| **Studio (GUI)** | http://127.0.0.1:54323 | `supabase start` shows this |
| **REST API** | http://127.0.0.1:54321 | `supabase status` |
| **Database** | postgresql://...:54322 | Direct connection |
| **Mailpit** | http://127.0.0.1:54324 | Test emails locally |

### 2.3 Check Status Anytime
```bash
supabase status
# Shows running services and credentials
```

### 2.4 Stop Local Environment
```bash
supabase stop
# Gracefully stops all services
```

**Note:** Keys change each time you start/stop. This is normal and secure for local dev.

---

## Phase 2.5: Local Supabase Studio

When you run `supabase start`, you get a **complete Supabase dashboard** running locally at `http://127.0.0.1:54323`.

**This is NOT a mock** - it's the real Supabase Studio connected to your local database.

### What You Can Do in Local Studio

| Feature | What It Does |
|---------|--------------|
| **Table Editor** | View/edit database tables visually |
| **SQL Editor** | Run queries, save snippets |
| **Auth → Users** | View/manage test users |
| **Auth → Policies** | Create/edit RLS policies |
| **Storage** | Manage buckets and files |
| **Edge Functions** | Deploy/test edge functions |
| **Logs** | View real-time logs |

### Key Difference: Local vs Production

| Aspect | Local Studio | Production Dashboard |
|--------|-------------|---------------------|
| **URL** | `http://127.0.0.1:54323` | `https://app.supabase.com` |
| **Data** | Local only (resets on stop) | Persistent |
| **OAuth** | N/A (configured in production) | Real user credentials |
| **Users** | Test accounts | Real users |
| **Billing** | Free | Based on plan |

### When to Use Local Studio

**✅ Use Local Studio for:**
- Viewing local database schema
- Testing SQL queries
- Debugging local auth issues
- Exploring Supabase features

**❌ Don't Use Local Studio for:**
- OAuth configuration (use production dashboard)
- Production configuration
- Real user management

### Pro Tip: Local Studio Workflow

```bash
# 1. Start local Supabase
supabase start

# 2. Open Studio in browser
open http://127.0.0.1:54323

# 3. Configure OAuth providers for testing
# Authentication → Providers → Enable Google/Discord
# (Use test credentials, not production!)

# 4. Build and test your app
npm run dev

# 5. When done
supabase stop
```

**Note:** OAuth providers configured in Local Studio only work for local development (`http://127.0.0.1:54321`). They don't sync to production.

---

## Phase 3: Environment Variables

### 3.1 Create .env.local (Next.js)
**File:** `frontend/.env.local`

```bash
# Local Development (from `supabase start` output)
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon_key_from_status>

# Production (from Supabase dashboard or client)
# NEXT_PUBLIC_SUPABASE_URL=https://<project-ref>.supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=<production_anon_key>
```

### 3.2 Access Keys Later (No Dashboard Needed)
```bash
# View current local keys
supabase status

# View project details
supabase projects list

# Get specific project info
supabase projects show <project-ref>
```

---

## Phase 4: OAuth Provider Configuration (Production)

**⚠️ OAuth providers can only be configured via the Supabase Dashboard**

Since we are using production-ready credentials directly, the client (or you, if given dashboard access) must configure OAuth providers in the production Supabase dashboard.

### 4.1 What You Need From the Client

You need either **Dashboard Access** or the **OAuth Credentials** from the client.

#### Option A: Dashboard Access (Recommended)

**Ask the client to add you as a team member:**
1. Go to: `https://app.supabase.com/project/[PROJECT-REF]/settings/team`
2. Click **"Invite"**
3. Add your email address
4. Set role: **Developer** (can configure auth) or **Admin** (full access)
5. You accept the invite via email
6. You can then configure everything yourself in the dashboard

**Benefits:**
- You control the entire OAuth setup
- Faster iteration (no back-and-forth)
- You can view logs and debug issues

---

#### Option B: Client Provides Credentials

If the client cannot give you dashboard access, send them this email template:

```
Subject: OAuth Login Setup - Action Required

Hi [Client Name],

To enable Google and Discord login on the website, please configure OAuth 
apps using the instructions below.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REQUIRED: OAUTH CREDENTIALS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I need the following credentials added to the Supabase project:

**Google OAuth:**
1. Go to: https://console.cloud.google.com/
2. Create/select a project
3. APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID
4. Application type: Web application
5. Configure these URLs:

   Authorized JavaScript origins:
   • http://localhost:3000
   • https://yourdomain.com (your production domain)

   Authorized redirect URIs:
   • https://[PROJECT-REF].supabase.co/auth/v1/callback
   • http://127.0.0.1:54321/auth/v1/callback (for local testing)

6. Copy the Client ID and Secret

7. Go to Supabase Dashboard → Authentication → Providers → Google
   • Toggle: Enabled ✅
   • Paste Client ID and Secret
   • Save

**Discord OAuth:**
1. Go to: https://discord.com/developers/applications
2. Click "New Application"
3. Go to OAuth2 → General
4. Add these Redirects:
   • https://[PROJECT-REF].supabase.co/auth/v1/callback
   • http://127.0.0.1:54321/auth/v1/callback (for local testing)

5. Copy the Client ID and Secret

6. Go to Supabase Dashboard → Authentication → Providers → Discord
   • Toggle: Enabled ✅
   • Paste Client ID and Secret
   • Save

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ALTERNATIVE: GIVE ME DASHBOARD ACCESS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Instead of the above, you can add me to the Supabase project:
1. Go to: https://app.supabase.com/project/[PROJECT-REF]/settings/team
2. Click "Invite"
3. Add my email: [YOUR_EMAIL]
4. Role: Developer
5. I'll configure everything myself

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Questions? Let me know!
```

---

### 4.2 Environment Variables You Need

Once OAuth is configured in the dashboard, update your `.env.local` file:

**File:** `frontend/.env.local`

```bash
# Local Development (from `supabase status`)
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_...

# Production (from Supabase Dashboard → Project Settings → API)
# Uncomment when deploying:
# NEXT_PUBLIC_SUPABASE_URL=https://[PROJECT-REF].supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=[production-anon-key]
```

**No additional env vars are needed for OAuth** - Supabase handles provider credentials internally.

---

### 4.3 Verify OAuth Configuration

**After the client configures OAuth:**

1. **Check Providers are Enabled:**
   - Visit: `https://app.supabase.com/project/[PROJECT-REF]/auth/providers`
   - Verify Google and Discord show as "Enabled"

2. **Test Locally:**
   ```bash
   # Start your Next.js app
   npm run dev
   
   # Visit login page
   open http://localhost:3000/login
   
   # Click Google/Discord buttons
   # Should redirect to provider, then back to callback
   ```

3. **Verify User Created:**
   - Supabase Dashboard → Authentication → Users
   - Should see new user after successful login

---

### 4.4 Troubleshooting OAuth

**"Redirect URI mismatch" error:**
- Provider dashboard redirect URL must EXACTLY match Supabase callback
- Check for trailing slashes, http vs https
- Local dev: `http://127.0.0.1:54321/auth/v1/callback`
- Production: `https://[PROJECT-REF].supabase.co/auth/v1/callback`

**"Client ID invalid" error:**
- Wrong Client ID copied
- OAuth app not saved properly in Supabase dashboard
- Check the provider is "Enabled" (toggle is ON)

**Login succeeds but user not created:**
- Check Supabase Dashboard → Authentication → Users
- Verify provider is enabled in dashboard
- Check browser console for errors

**Login succeeds but user not created:**
- Check Supabase Dashboard → Authentication → Users
- Verify provider is enabled in config.toml or dashboard
- Check browser console for errors
- Restart Supabase after changing config.toml

---

## Phase 5: Database Operations (CLI-First)

### 5.1 Generate Types from Schema
```bash
# Generate TypeScript types
supabase gen types typescript --local > types/supabase.ts

# Or for linked project
supabase gen types typescript --linked > types/supabase.ts
```

### 5.2 Database Migrations
```bash
# Create new migration
supabase migration new <name>

# Apply migrations to local db
supabase db reset

# Push migrations to remote
supabase db push

# Pull remote changes
supabase db pull
```

### 5.3 Execute SQL (No Dashboard)
```bash
# Run SQL file
supabase db execute --file <path-to-sql>

# Connect with psql
psql postgresql://postgres:postgres@127.0.0.1:54322/postgres
```

---

## Phase 6: Production Deployment

### 6.1 Get Production Keys (CLI)
```bash
# List all projects
supabase projects list

# Get project details
supabase projects show <project-ref>

# Or access from dashboard (only if client shares)
# Project Settings > API
```

### 6.2 Configure Production Environment
**Add to your hosting platform (Vercel, etc.):**
```bash
NEXT_PUBLIC_SUPABASE_URL=https://<project-ref>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<production-anon-key>
```

### 6.3 Update Site URL and Redirects
**Option A: Dashboard (Easiest)**
1. Go to Supabase Dashboard > Authentication > URL Configuration
2. Set Site URL: `https://yourdomain.com`
3. Add Redirect URLs: `https://yourdomain.com/auth/callback`

**Option B: Edit config.toml + Push**
Edit `supabase/config.toml`:
```toml
[auth]
site_url = "https://yourdomain.com"
additional_redirect_urls = ["https://yourdomain.com/auth/callback"]
```

Then push:
```bash
supabase config push
```

---

## Quick Reference: Essential CLI Commands

```bash
# Status & Info
supabase status                 # Show running services and keys
supabase --version             # CLI version
supabase projects list         # List all projects
supabase projects show <ref>   # Show project details

# Local Development
supabase start                 # Start local stack
supabase stop                  # Stop local stack
supabase db reset              # Reset local database

# Database
supabase migration new <name>  # Create migration
supabase migration list        # List migrations
supabase db push               # Push to remote
supabase db pull               # Pull from remote
supabase db diff               # Show schema diff

# Types
supabase gen types typescript --local   # Generate from local
supabase gen types typescript --linked  # Generate from linked

# Config (edit config.toml directly, then push)
supabase config push             # Push local config.toml to remote

# Logs
supabase functions logs        # Edge function logs
```

---

## CLI-Only vs Dashboard Tasks

| Task | CLI | Dashboard |
|------|-----|-----------|
| Start/stop local | ✅ | ❌ |
| Run migrations | ✅ | ❌ |
| Generate types | ✅ | ❌ |
| View logs | ✅ | ✅ |
| Configure OAuth providers | ❌ | ✅ |
| Create/edit RLS policies | ⚠️ (via SQL) | ✅ |
| Manage users | ⚠️ (via API) | ✅ |
| Configure storage buckets | ⚠️ (via SQL) | ✅ |

**Legend:**
- ✅ = Best done here
- ⚠️ = Possible but dashboard is easier
- ❌ = Not available

---

## Troubleshooting

### "supabase: command not found"
```bash
# Use npx instead
npx supabase <command>

# Or install globally
npm install -g supabase
```

### "Project not linked"
```bash
# Link first
supabase link --project-ref <ref>
```

### "Port already in use"
```bash
# Stop any running supabase
supabase stop

# Or force stop
supabase stop --no-backup

# Check what's using port 54321
lsof -i :54321
```

### Keys not working
- Local keys change on every `supabase start` - this is normal
- Update `.env.local` after each restart
- Use `supabase status` to get current keys

### OAuth redirect errors
- Verify redirect URLs match exactly in provider dashboard
- Check http vs https
- Ensure localhost ports match

---

## Security Notes

- **Never commit `.env.local`** - it's in `.gitignore` by default
- **Local keys are temporary** - change on every restart
- **Service role key** - never expose to frontend, only use server-side
- **Anon key** - safe for frontend, respects RLS

---

## Next Steps After Setup

1. ✅ Run `supabase start` and copy the keys
2. ✅ Create `frontend/.env.local` with those keys
3. ⏳ Ask client to configure OAuth providers (Google/Discord)
4. ✅ Generate TypeScript types: `supabase gen types typescript --local`
5. ✅ Create auth callback route in Next.js
6. ✅ Build OAuth buttons using local Supabase

---

**Document Version:** 1.0  
**Last Updated:** 2024-03-11  
**Supabase CLI Version:** Latest (check with `supabase --version`)
