# Skill: Framer Motion Animations

Implement smooth, natural UI animations with Framer Motion. Avoid over-engineered keyframes and follow established patterns for common interactions.

## When to Use This Skill

- Adding micro-interactions (hovers, clicks, state changes)
- Implementing notification badges, bell shakes, or alerts
- Creating modal/dialog enter/exit animations
- Adding page transitions or list reordering
- Anytime you're tempted to write complex CSS keyframes

---

## Core Principle: Natural Motion Over Complexity

**Bad animations scream "Look at me!"**  
**Good animations feel invisible** — they guide attention and provide feedback without distraction.

### The Test
Ask: *"Does this animation help the user understand what just happened?"*

- Yes → Keep it
- No / "It looks cool" → Simplify or remove

---

## Established Patterns — Copy These

### 1. Bell / Notification Shake

For alerting users to new notifications. Mimics a physical bell's swing.

```tsx
import { motion } from 'framer-motion'

function NotificationBell({ hasNew }: { hasNew: boolean }) {
  return (
    <motion.div
      animate={hasNew
        ? { rotate: [0, -14, 14, -10, 10, -6, 6, 0], scale: [1, 1.06, 1] }
        : { rotate: 0, scale: 1 }
      }
      transition={{ duration: 0.7, ease: 'easeInOut' }}
      className="origin-top"
    >
      <BellIcon className="w-6 h-6" />
    </motion.div>
  )
}
```

**Key points:**
- `origin-top` — Bell pivots from top (like real bells)
- Max 8 rotation values — More feels mechanical
- Subtle scale (1.05–1.1x) — Large jumps feel cartoony
- 0.6–0.8s duration — Longer feels sluggish
- Wrap icon in `motion.div`, don't animate the button itself

---

### 2. Card / Button Hover Lift

Subtle elevation on hover suggests interactivity.

```tsx
<motion.div
  whileHover={{ y: -2 }}
  transition={{ duration: 0.2, ease: 'easeOut' }}
  className="bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow"
>
  {/* Card content */}
</motion.div>
```

**Key points:**
- `-2px` to `-4px` lift — Subtle but noticeable
- Pair with shadow transition for depth
- Keep duration under 0.3s — Instant response feels better

---

### 3. Modal / Dialog Enter & Exit

```tsx
import { motion, AnimatePresence } from 'framer-motion'

function Modal({ isOpen, onClose, children }: ModalProps) {
  return (
    <AnimatePresence>
      {isOpen && (
        <>
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.2 }}
            className="fixed inset-0 bg-black/50"
            onClick={onClose}
          />
          
          {/* Modal content */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95, y: 10 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 10 }}
            transition={{ duration: 0.2, ease: 'easeOut' }}
            className="fixed inset-0 m-auto max-w-md h-fit bg-white rounded-xl p-6"
          >
            {children}
          </motion.div>
        </>
      )}
    </AnimatePresence>
  )
}
```

**Key points:**
- Always use `AnimatePresence` for exit animations to work
- Scale 0.95 → 1 is subtler than 0.9 → 1
- Slight `y` offset (10px) adds directionality
- Backdrop fades separately — faster feels snappier

---

### 4. Badge / Dot Pulse

For drawing attention to status indicators.

```tsx
<motion.span
  animate={{ scale: [1, 1.2, 1] }}
  transition={{ 
    duration: 1.5, 
    repeat: Infinity, 
    ease: 'easeInOut',
    repeatDelay: 0.5 
  }}
  className="w-2 h-2 bg-red-500 rounded-full"
/>
```

**Key points:**
- Single property animation — cleaner than multi-property
- `repeatDelay` prevents constant pulsing (annoying)
- 1.2x scale is enough — 1.5x+ feels urgent/alarm-like

---

### 5. List Item Enter / Exit

For adding/removing items from lists.

```tsx
<motion.li
  layout
  initial={{ opacity: 0, x: -20 }}
  animate={{ opacity: 1, x: 0 }}
  exit={{ opacity: 0, x: 20 }}
  transition={{ duration: 0.2 }}
>
  {item.name}
</motion.li>
```

**Key points:**
- `layout` prop enables smooth repositioning of siblings
- Directional exit (opposite of enter) feels natural
- Wrap list in `AnimatePresence mode="popLayout"` for best results

---

### 6. Page / Route Transitions

```tsx
import { motion } from 'framer-motion'

const pageVariants = {
  initial: { opacity: 0, y: 20 },
  animate: { opacity: 1, y: 0 },
  exit: { opacity: 0, y: -20 }
}

const pageTransition = {
  duration: 0.3,
  ease: 'easeInOut'
}

export default function Page() {
  return (
    <motion.div
      initial="initial"
      animate="animate"
      exit="exit"
      variants={pageVariants}
      transition={pageTransition}
    >
      {/* Page content */}
    </motion.div>
  )
}
```

---

### 7. Staggered Children

For lists or grids that should animate in sequence.

```tsx
const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1
    }
  }
}

const item = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0 }
}

<motion.ul
  variants={container}
  initial="hidden"
  animate="show"
>
  {items.map(i => (
    <motion.li key={i.id} variants={item}>
      {i.name}
    </motion.li>
  ))}
</motion.ul>
```

**Key points:**
- `staggerChildren` in parent controls delay between items
- 0.05–0.15s is the sweet spot for stagger
- Individual items define their own animation variants

---

### 8. Loading / Skeleton Pulse

```tsx
<motion.div
  animate={{ opacity: [0.5, 1, 0.5] }}
  transition={{ duration: 1.5, repeat: Infinity, ease: 'easeInOut' }}
  className="h-4 bg-gray-200 rounded w-3/4"
/>
```

---

## Anti-Patterns — Avoid These

### ❌ Over-Engineered Keyframes

```tsx
// BAD — 20+ values, feels chaotic
animate={{
  scale: [1, 1.7, 0.85, 1.6, 0.9, 1.5, 1, 1.4, 1.05, 1.2, 1],
  rotate: [0, -75, 75, -60, 60, -50, 50, -40, 40, -30, 30, -20, 20, -10, 10, 0]
}}
```

**Why:** Too many values feel random and unpolished. Natural motion is simple.

---

### ❌ Animating Layout Properties

```tsx
// BAD — Triggers layout recalculation (expensive)
<motion.div animate={{ width: isOpen ? 300 : 100 }} />

// GOOD — Use transform instead
<motion.div animate={{ scaleX: isOpen ? 1 : 0.33 }} />
```

**Why:** `width`, `height`, `top`, `left` cause reflow. Use `transform` and `opacity` only.

---

### ❌ Long Durations

```tsx
// BAD — Feels sluggish
transition={{ duration: 1.5 }}

// GOOD — Snappy and responsive
transition={{ duration: 0.2 }}
```

**Rule of thumb:**
- Micro-interactions: 0.15–0.3s
- Modals/page transitions: 0.2–0.4s
- Ambient (loops): 1–3s

---

### ❌ Missing Reduced Motion Support

```tsx
// BAD — Ignores accessibility preferences
<motion.div animate={{ rotate: 360 }} />

// GOOD — Respects user preference
const prefersReducedMotion = 
  typeof window !== 'undefined' 
    ? window.matchMedia('(prefers-reduced-motion: reduce)').matches 
    : false

<motion.div 
  animate={prefersReducedMotion ? {} : { rotate: 360 }} 
/>
```

---

## Quick Reference: Timing & Easing

### Duration Guidelines

| Animation Type | Duration | Notes |
|----------------|----------|-------|
| Hover feedback | 0.15–0.2s | Instant feel |
| Button press | 0.1s | Almost instant |
| Modal open/close | 0.2–0.3s | Snappy but visible |
| Page transition | 0.3–0.4s | Allows orientation |
| Notification | 0.5–0.8s | Draws attention |
| Ambient (pulse) | 1.5–3s | Background, not urgent |

### Easing Functions

```tsx
// Standard — Most UI transitions
ease: 'easeInOut'

// Entering — Decelerates (natural arrival)
ease: 'easeOut'

// Exiting — Accelerates (natural departure)
ease: 'easeIn'

// Custom cubic-bezier (spring-like)
ease: [0.34, 1.56, 0.64, 1] // Slight overshoot
```

### Spring Physics (Alternative to Duration)

```tsx
<motion.div
  animate={{ scale: 1.2 }}
  transition={{ 
    type: 'spring', 
    stiffness: 300, 
    damping: 20 
  }}
/>
```

| Property | Effect | Typical Range |
|----------|--------|---------------|
| `stiffness` | Higher = snappier | 100–500 |
| `damping` | Higher = less bounce | 10–30 |
| `mass` | Heavier = slower | 1–2 |

---

## Performance Best Practices

1. **Animate only `transform` and `opacity`** — These are GPU-accelerated
2. **Use `will-change` sparingly** — Framer Motion handles this automatically
3. **Avoid animating `layout` on many items** — Can be expensive in large lists
4. **Use `layoutId` for shared element transitions** — Smooth morphing between states
5. **Test on low-end devices** — Animations that stutter are worse than no animation

---

## Before You Animate

Checklist:

- [ ] Does this animation serve a purpose (feedback, orientation, delight)?
- [ ] Is the duration under 0.5s for interactive elements?
- [ ] Am I animating only transform/opacity?
- [ ] Does it respect `prefers-reduced-motion`?
- [ ] Does it feel natural, not mechanical?

---

## Common Animation Decisions

| Scenario | Recommended Approach |
|----------|---------------------|
| New notification | Bell shake (pattern #1) |
| Button hover | Lift + shadow (pattern #2) |
| Modal open/close | Scale + fade (pattern #3) |
| Live indicator | Pulse (pattern #4) |
| List add/remove | Slide + AnimatePresence (pattern #5) |
| Page navigation | Fade + slight Y offset (pattern #6) |
| Content loading | Skeleton pulse (pattern #8) |

---

## Resources

- [Framer Motion Documentation](https://www.framer.com/motion/)
- [Animation Principles (Disney)](https://en.wikipedia.org/wiki/Twelve_basic_principles_of_animation)
- `prefers-reduced-motion` [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion)

---

*Simple, purposeful animations beat complex ones. When in doubt, reduce.*
