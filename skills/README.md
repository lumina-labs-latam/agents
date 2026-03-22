# Agent Skills Library

Shared capabilities for Sakus Store agents.

---

## Critical: Task Queue Workflow

The `.agents/todos/` folder is the **central task queue**. This is how work flows through the pipeline.

### For Humans (You + Kimi Claw)

1. **Create todos** in `.agents/todos/TODO-XXX-description.md`
2. **Commit and push** — `git add . && git commit -m "add: TODO-001 products page"`
3. **Pull on workstation** — agents pick up work from the todos folder

### For Agents (OpenCode)

Every agent session starts with:

```bash
# 1. Check for assignments
ls -la .agents/todos/

# 2. Read relevant TODO files
cat .agents/todos/TODO-001-products-page.md

# 3. Claim the task (edit the file)
# Change: Assigned to: (pending)
# To: Assigned to: Steve (or your name)

# 4. Do the work

# 5. When complete, move to archive
mv .agents/todos/TODO-001-products-page.md .agents/archive/

# 6. Log decisions if needed
echo "### DECISION-001: ..." >> .agents/DECISIONS.md
```

### Todo File Format

```markdown
# TODO-XXX: Task Title

**Status:** 🔴 Ready to assign / 🟡 In progress / 🟢 Complete  
**Priority:** High / Medium / Low  
**Estimated:** X hours  
**Assigned to:** (pending) / Steve / Viktor / Bob / Layla / Archy

---

## Objective

[What needs to be done]

---

## Requirements

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

---

## Handoff Path

Steve → Viktor → Bob → Viktor → Layla

---

## References

- Related files: `frontend/app/...`
- Pattern: See existing implementation in `...`

---

## Notes

[Any additional context]
```

---

## Available Skills

### shadcn-component

Add a new shadcn/ui component:

```bash
cd frontend
npx shadcn add [component-name]
```

Common components: button, card, dialog, drawer, form, input, select, table, toast

---

### supabase-typegen

Generate TypeScript types from database:

```bash
npx supabase gen types typescript --project-id [project-ref] --schema public > src/lib/supabase/database.types.ts
```

Or from local:
```bash
npx supabase start
npx supabase gen types typescript --local > src/lib/supabase/database.types.ts
```

---

### i18n-add-key

Add translation keys to both files:

```bash
# Add to frontend/messages/es.json AND frontend/messages/en.json

# Pattern:
"section": {
  "key": "Spanish text",
  "nested": {
    "action": "Action text"
  }
}
```

Usage in component:
```typescript
const t = useTranslations('section');
t('key') // or t('nested.action')
```

---

### server-action-template

```typescript
'use server';

import { z } from 'zod';
import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

const Schema = z.object({
  // fields
});

export async function actionName(formData: FormData) {
  const supabase = await createClient();
  
  // Validate
  const data = Object.fromEntries(formData);
  const parsed = Schema.safeParse(data);
  
  if (!parsed.success) {
    return { error: parsed.error.flatten().fieldErrors };
  }
  
  // Execute
  const { error } = await supabase
    .from('table')
    .insert(parsed.data);
  
  if (error) {
    return { error: error.message };
  }
  
  revalidatePath('/path');
  return { success: true };
}
```

---

### vercel-deploy

Deploy to Vercel:

```bash
# Preview (from any branch)
vercel

# Production
vercel --prod
```

Check deployment:
```bash
vercel logs [deployment-url]
```

---

## Agent Report Directories

Each agent writes reports to their own folder:

```
.steve/reports/     # Database migration reports
.viktor/reports/    # QA test results
.bob/reports/       # Backend implementation reports
.layla/reports/     # Frontend implementation reports
.archy/reports/     # Bug resolution reports
```

---

## Adding New Skills

Create a new `.md` file in this folder with:
- Skill name
- When to use it
- Commands/code
- Examples
