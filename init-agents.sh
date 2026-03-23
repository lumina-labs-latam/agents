#!/bin/bash

# init-agents.sh
# Setup script for the Agent Assembly Line System
# Run this in your project root to initialize the .agents/ structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎼 Agent Assembly Line System - Initialization${NC}"
echo "================================================"
echo ""

# Check if we're in a git repo (good practice)
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Warning: Not a git repository root${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if AGENTS.md exists at root
if [ ! -f "AGENTS.md" ]; then
    echo -e "${YELLOW}⚠️  AGENTS.md not found at project root${NC}"
    echo "Creating template AGENTS.md..."
    
    cat > AGENTS.md << 'EOF'
# AGENTS.md

Project guidelines for agentic development.

## Project Overview

[Brief description of your project]

## Tech Stack

- **Framework**: [e.g., Next.js, React, etc.]
- **Database**: [e.g., Supabase, PostgreSQL]
- **Styling**: [e.g., Tailwind CSS, styled-components]
- **Key Libraries**: [List important dependencies]

## Project Structure

```
[Describe your folder structure]
```

## Build Commands

```bash
# Development
npm run dev

# Build
npm run build

# Lint
npm run lint

# Tests
npm test
```

## Environment Variables

Required env vars:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- [Add others...]

## Code Conventions

[Your coding standards, naming conventions, etc.]

## Key Files

- `[path/to/key/file]` — [Description]
- `[path/to/another/file]` — [Description]

---

*This file is read by all agents before starting work.*
EOF

    echo -e "${GREEN}✓ Created AGENTS.md template${NC}"
    echo -e "${YELLOW}⚠️  Please customize AGENTS.md for your project!${NC}"
    echo ""
fi

# Create .agents/ directory structure
echo "Creating .agents/ folder structure..."

mkdir -p .agents/queue/.solved
mkdir -p .agents/handoffs/from-{steve,viktor,bob,layla,archy}
mkdir -p .agents/reports/{steve,viktor,bob,layla,archy}
mkdir -p .agents/reports/bugs/.solved

# Create core files
if [ ! -f ".agents/ORCHESTRATOR.md" ]; then
    echo -e "${BLUE}📋 Creating ORCHESTRATOR.md...${NC}"
    cat > .agents/ORCHESTRATOR.md << 'EOF'
# Orchestrator Briefing

This file confirms the Orchestrator role for agent-driven development.

See full persona at: ~/repos/agents/personas/orchestrator.md

## Quick Reference

**Role**: Conductor of the 5-agent pipeline  
**Your job**: Delegate tasks, track progress, escalate bugs to human

## Folder Structure

```
.agents/
├── ORCHESTRATOR.md      # This file
├── DECISIONS.md         # Project technical decisions
├── STATUS.md            # Real-time project state ← Update this continuously
├── queue/               # Task queue
│   ├── .solved/         # Archive completed tasks here
├── handoffs/            # Agent communication
│   └── from-{agent}/
└── reports/             # Agent deliverables
    ├── {agent}/
    └── bugs/            # Bug escalations
        └── .solved/     # Archive solved bugs here
```

## AGENTS.md Location

The project maintains `AGENTS.md` at the **project root** (../AGENTS.md).
All agents must read this first before starting work.

## Bug Escalation Protocol

If an agent cannot solve a bug after 3 attempts:
1. They write to `.agents/reports/bugs/BUG-XXX-description.md`
2. You (Orchestrator) read it and update STATUS.md
3. **Escalate to human (Juanes)** with context
4. Once resolved, move to `.agents/reports/bugs/.solved/`

## Workflow

1. Read STATUS.md and queue/
2. Spawn appropriate agent for active TODO
3. Monitor progress, update STATUS.md in real-time
4. Handle handoffs between agents
5. Escalate bugs to human
6. Archive completed work to .solved/ folders

## Pipeline Order

Steve → Viktor → Bob → Viktor → Layla → (Archy if bugs) → Ship

## Golden Rules

1. Create missing folders immediately if they don't exist
2. Update STATUS.md after every significant action
3. Always escalate bugs to human — don't let agents struggle indefinitely
4. Follow the handoff chain
5. Archive completed work
EOF
    echo -e "${GREEN}✓ Created ORCHESTRATOR.md${NC}"
fi

if [ ! -f ".agents/DECISIONS.md" ]; then
    echo -e "${BLUE}📋 Creating DECISIONS.md...${NC}"
    cat > .agents/DECISIONS.md << 'EOF'
# Architecture Decision Log

This file is the shared memory of the development team. Every non-obvious
technical decision is recorded here so that future work doesn't contradict,
undo, or re-debate past choices.

**Who writes here:** Steve, Viktor, Bob, Layla, Archy  
**When to write:** After making a decision where the "why" isn't obvious from
the code alone — design tradeoffs, rejected alternatives, regulatory constraints,
bug patterns that must not recur.  
**When NOT to write:** Routine implementation choices, obvious patterns, anything
self-evident from reading the code.

---

## Agent Responsibilities

| Agent | Primary Role | Stack Focus | Reports To |
|-------|-------------|-------------|------------|
| Steve | Database Architect | PostgreSQL, Supabase, RLS, migrations | reports/steve/ |
| Viktor | QA Testing | pgTAP, RLS testing, constraint verification | reports/viktor/ |
| Bob | Backend Engineer | Next.js Server Actions, API routes, auth | reports/bob/ |
| Layla | Frontend Architect | React, Tailwind, shadcn/ui, UX | reports/layla/ |
| Archy | Senior Debugger | Escalated bug fixes | reports/archy/ |

---

## Pipeline Flow

```
Schema Changes:     Steve → Viktor → Bob → Viktor → Layla
Backend Changes:    Bob → Viktor → Layla
Frontend Changes:   Layla (solo, unless bug) → Archy (if escalated)
Bugs:               Any → Archy (escalated)
```

---

## Workflow

1. **New Task** → Added to `queue/TODO-XXX.md`
2. **Handoff** → Previous agent writes `handoffs/from-{agent}/HANDOFF-XXX.md`
3. **Work** → Agent executes, updates todo
4. **Complete** → Todo moved to `queue/.solved/`, decision logged here if needed

---

## Decisions Made

*(Agents append here)*

---

<!-- TEMPLATE — copy this block for each new entry

## YYYY-MM-DD — [Short title: what was decided]
**Agent:** [Steve / Viktor / Bob / Layla / Archy]
**Context:** [1-2 sentences: what problem or question triggered this decision]
**Decision:** [What was chosen and how it works]
**Why not the alternative:** [What was rejected and why]
**Revisit if:** [Under what future conditions this decision should be reconsidered]

-->
EOF
    echo -e "${GREEN}✓ Created DECISIONS.md${NC}"
fi

if [ ! -f ".agents/STATUS.md" ]; then
    echo -e "${BLUE}📋 Creating STATUS.md...${NC}"
    cat > .agents/STATUS.md << 'EOF'
# Project Status

Real-time tracking of development progress. Updated continuously by the Orchestrator.

---

## Current State

**Last Updated:**  
**Orchestrator Session:**

### Active Work

```yaml
active_todo:
active_agent:
status: pending|in_progress|blocked|completed
started_at:
progress: 0%
```

### Pipeline Position

```
[Steve] → [Viktor] → [Bob] → [Viktor] → [Layla] → [Ship]
```

---

## Progress Log

*(Recent activity)*

---

## Blockers

*None currently*

---

## Questions for Human (Juanes)

*None currently*

---

## Bug Escalations

### Active Bugs

*None currently*

### Recently Solved

*None recently*

---

## Completed Tasks (Recent)

*None yet*

---

## Queue Overview

### Pending

*List pending TODOs*

### Recently Completed

*None yet*

---

## Notes

*Any additional context*
EOF
    echo -e "${GREEN}✓ Created STATUS.md${NC}"
fi

# Create a sample TODO template
if [ ! -f ".agents/queue/TODO-001-example.md" ]; then
    echo -e "${BLUE}📋 Creating example TODO template...${NC}"
    cat > .agents/queue/TODO-001-example.md << 'EOF'
---
id: TODO-001
title: Example Task Template
assigned_to: steve
status: pending
created_at: 2024-01-15
dependencies: []
---

# TODO-001: Example Task

## Objective

[Clear description of what needs to be done]

## Requirements

- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Acceptance Criteria

1. [Criterion 1]
2. [Criterion 2]
3. [Criterion 3]

## Context

[Any background information the agent needs]

## Related Files

- `path/to/file.ts` — [Description]

## Notes

[Any additional notes]
EOF
    echo -e "${GREEN}✓ Created example TODO${NC}"
fi

# Create bug report template reference
echo -e "${BLUE}📋 Creating bug report reference...${NC}"
cat > .agents/reports/bugs/BUG_REPORT_TEMPLATE.md << 'EOF'
# Bug Report Template

When you cannot solve a bug after 3 or fewer attempts, use this template:

1. Copy this file: `cp BUG_REPORT_TEMPLATE.md BUG-XXX-brief-description.md`
2. Fill in all sections
3. Save to `.agents/reports/bugs/`
4. The Orchestrator will escalate to the human

See full template at: ~/repos/agents/templates/BUG_REPORT_TEMPLATE.md
EOF

echo ""
echo -e "${GREEN}✅ Agent Assembly Line System initialized!${NC}"
echo ""
echo "Project structure:"
tree -L 3 .agents/ 2>/dev/null || find .agents -type d | head -20

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Customize AGENTS.md at project root with your project details"
echo "2. Review and customize .agents/DECISIONS.md"
echo "3. Create your first TODO in .agents/queue/"
echo "4. Start the orchestrator workflow"
echo ""
echo -e "${YELLOW}Remember:${NC} All agents will read AGENTS.md at the project root first!"
