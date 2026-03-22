# Agent Hub

**Purpose:** The command center for our 5-agent development pipeline.  
**Who we are:** Juanes and Kimi — the conductors.  
**Who they are:** Steve, Viktor, Bob, Layla, Archy — the virtuosos.

---

## Quick Reference

| Agent | Role | Writes To | Reads From |
|-------|------|-----------|------------|
| **Steve** | Database architect | `handoffs/from-steve/` | Business requirements |
| **Viktor** | QA testing | `handoffs/from-viktor/` | `handoffs/from-steve/` |
| **Bob** | Backend engineer | `handoffs/from-bob/` | `handoffs/from-viktor/` |
| **Layla** | Frontend architect | `handoffs/from-layla/` | `handoffs/from-bob/` |
| **Archy** | Senior debugger | `handoffs/from-archy/` | `handoffs/from-layla/` |

---

## Folder Structure

```
.agents/
├── README.md              # This file — start here
├── DECISIONS.md           # Shared memory for technical decisions
│
├── personas/              # Who the agents are
│   ├── README.md          # Agent quick-reference cards
│   ├── steve.md           # Database architect
│   ├── viktor.md          # QA testing
│   ├── bob.md             # Backend engineer
│   ├── layla.md           # Frontend architect
│   └── archy.md           # Senior debugger
│
├── skills/                # Reusable knowledge (the "how")
│   ├── README.md          # Skill index
│   ├── framer-motion.md
│   ├── supabase-implementation.md
│   ├── supabase-checklist.md
│   └── testing-guide.md
│
├── handoffs/              # Work passes between agents
│   ├── from-steve/        # Migration reports → Bob
│   ├── from-viktor/       # QA reports → Bob/Steve
│   ├── from-bob/          # Implementation reports → Layla
│   ├── from-layla/        # Bug escalations → Archy
│   └── from-archy/        # Resolutions → All
│
├── feedback/              # Agents improve themselves here
│   ├── steve-suggestions.md
│   ├── viktor-suggestions.md
│   ├── bob-suggestions.md
│   ├── layla-suggestions.md
│   └── archy-suggestions.md
│
└── reports/               # Structured outputs per agent
    ├── steve/
    ├── viktor/
    ├── bob/
    ├── layla/
    └── archy/
```

---

## The Pipeline

```
Business Need
     ↓
   STEVE (schema design)
     ↓
   VIKTOR (QA tests)
     ↓
   BOB (backend implementation)
     ↓
   VIKTOR (verify server actions)
     ↓
   LAYLA (frontend polish)
     ↓
   (If bugs) → ARCHY (debug)
     ↓
   Ship
```

---

## How to Use This Template

**Starting a new project:**
```bash
cp -r ~/.openclaw/agents/ ./my-project/.agents/
```

**Spawning an agent:**
1. Read their persona from `personas/[agent].md`
2. Check the latest handoff in `handoffs/from-[previous]/`
3. Tell them what to build
4. They write to `handoffs/from-[theirname]/`

**Improving the agents:**
Review `feedback/[agent]-suggestions.md` periodically. Update their prompts or add skills based on what they report.

---

## Golden Rules

1. **No agent skips handoffs** — Always read the previous agent's report
2. **DECISIONS.md is sacred** — Non-obvious choices go here, not in code comments
3. **Feedback loops matter** — Agents write to feedback/; we act on it
4. **Skills are shared** — Any agent can reference any skill
5. **Reports are structured** — Follow the templates in each agent's persona

---

*We conduct. They execute. The music plays.*
