---
name: changelog-infographic
description: Generate beautiful infographic PNG images from Claude Code changelog summaries. Use this skill after changelog-interpreter has generated a user-friendly summary, to create a visual representation that can be saved and shared.
---

# Changelog Infographic Skill

This skill transforms changelog summaries into visually stunning infographic PNG images. It receives structured changelog information from the `changelog-interpreter` skill and produces museum-quality visual artifacts.

## When to Use

- After `changelog-interpreter` has generated a summary
- When user requests a visual representation of changes
- When user asks "Create an infographic" or "Visualize the changelog"
- When sharing changelog updates externally

## Input

Structured changelog summary from `changelog-interpreter`:

```json
{
  "previousVersion": "2.0.74",
  "latestVersion": "2.0.76",
  "summary": "...",
  "features": [
    {
      "name": "LSP Tool",
      "description": "Jump to definitions and search references",
      "usage": "Show me the definition of this function",
      "useCases": ["Navigating large codebases", "Understanding impact of changes"]
    }
  ],
  "improvements": ["Faster startup", "Memory leak fix"],
  "generatedAt": "2025-12-23T12:00:00Z"
}
```

If receiving the raw markdown summary, extract structured data before visualization.

## Output

1. PNG infographic saved to cache directory
2. Clickable file path link for user to open

---

## DESIGN PHILOSOPHY: "Technical Clarity"

### The Vision

Technical Clarity is a design philosophy that bridges the precision of software engineering with the warmth of visual communication. It treats version updates not as sterile changelogs, but as moments of progress worth celebrating—each feature a small victory, each improvement a step forward.

### Form and Space

The canvas breathes with intentional negative space. Information clusters organically into digestible zones: a prominent header anchoring the version transition, feature cards arranged in a grid or flowing column, and a footer grounding the composition. White space is not emptiness but punctuation—giving the eye permission to rest and the mind permission to absorb.

### Color and Material

A restrained palette speaks of professionalism while accent colors inject energy. The primary scheme draws from Claude's brand identity: warm neutrals, sophisticated blues, and purposeful highlights. Feature types receive distinct but harmonious color coding—new features in vibrant accent, improvements in muted success tones, fixes in subtle neutral. Every color choice appears deliberate, the product of countless refinements.

### Typography and Hierarchy

Typography serves information, never competes with it. Version numbers command attention through scale and weight. Feature names balance prominence with restraint. Descriptions whisper in supporting sizes. The typographic hierarchy guides the eye naturally from most important to supporting details, each level of information clearly differentiated yet cohesively unified.

### Iconography and Visual Language

Simple, geometric icons punctuate each feature category—a spark for new features, a wrench for improvements, a check for fixes. These visual anchors accelerate comprehension while adding personality. Icons are restrained, never decorative clutter, always functional visual shorthand crafted with meticulous attention to detail.

### Craftsmanship

Every pixel placement reflects master-level execution. Alignment is obsessive. Spacing is mathematical. The final artifact should appear as though someone at the absolute top of their field labored over every detail with painstaking care—because that is exactly what happens. This is not a template filled in; this is a designed artifact.

---

## CANVAS CREATION PROCESS

### Step 1: Parse Input Data

Extract from the changelog summary:
- `previousVersion` → `latestVersion` (version transition)
- Feature list with names, descriptions, usage examples
- Improvements and fixes
- Generation timestamp

### Step 2: Establish Layout

Create a canvas with these specifications:

| Property | Value |
|----------|-------|
| Width | 1200px |
| Height | Dynamic (800-1600px based on content) |
| Background | #FAFAFA (light) or #1A1A1A (dark variant) |
| Margins | 60px all sides |
| Grid | 12-column with 24px gutters |

### Step 3: Header Zone

The header establishes context and celebrates the update:

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│   [Claude Logo/Icon]                                   │
│                                                        │
│   v2.0.74  ────────────────►  v2.0.76                 │
│                                                        │
│   Claude Code Update                                   │
│                                                        │
└────────────────────────────────────────────────────────┘
```

- Version transition: Large, bold typography with arrow indicating progression
- Subtle gradient or accent line separating header from content
- Date stamp in small, muted text

### Step 4: Feature Cards

Each feature becomes a self-contained card:

```
┌─────────────────────────────────────┐
│ ✨ [Feature Name]                   │
│                                     │
│ [2-3 line description]              │
│                                     │
│ 💡 [Usage example in code block]    │
│                                     │
│ 📋 Use cases:                       │
│    • [Case 1]                       │
│    • [Case 2]                       │
└─────────────────────────────────────┘
```

Card specifications:
- Background: White (#FFFFFF) with subtle shadow
- Border-radius: 12px
- Padding: 24px
- Icon/emoji for category identification
- Clear typographic hierarchy within card

### Step 5: Improvements & Fixes Section

A compact, list-style section:

```
┌────────────────────────────────────────────────────────┐
│ 🔧 Improvements & Fixes                                │
│                                                        │
│ • Improved startup performance                         │
│ • Fixed memory leak in long sessions                   │
│ • Enhanced error messages                              │
└────────────────────────────────────────────────────────┘
```

### Step 6: Footer

Ground the composition with metadata:

```
┌────────────────────────────────────────────────────────┐
│ Generated by cc-version-updater    │    Dec 2025      │
└────────────────────────────────────────────────────────┘
```

---

## IMPLEMENTATION

### File Generation

Generate the PNG using available methods:

**Option A: SVG → PNG (Preferred)**
1. Construct SVG markup with embedded styles
2. Convert to PNG using available tools
3. Save to cache directory

**Option B: HTML → PNG**
1. Generate styled HTML document
2. Use puppeteer or similar to capture as PNG
3. Save to cache directory

**Option C: Canvas API (Node.js)**
1. Use node-canvas or similar library
2. Draw elements programmatically
3. Export as PNG buffer
4. Save to cache directory

### Cache Directory

Save generated infographics to:

```
plugins/cc-version-updater/.cache/infographics/
├── changelog-2.0.74-to-2.0.76.png
├── changelog-2.0.76-to-2.0.77.png
└── ...
```

Filename pattern: `changelog-{prevVersion}-to-{newVersion}.png`

### Output Format

After generating the infographic, output:

```markdown
## Infographic Generated

Your changelog infographic has been created:

📁 **File**: `~/.claude-plugins/cc-version-updater/.cache/infographics/changelog-2.0.74-to-2.0.76.png`

👆 Click to open, or run:
```bash
open ~/.claude-plugins/cc-version-updater/.cache/infographics/changelog-2.0.74-to-2.0.76.png
```
```

---

## QUALITY STANDARDS

### Visual Checklist

Before finalizing, verify:

- [ ] All text is legible and properly sized
- [ ] No elements overlap or clip
- [ ] Consistent spacing throughout
- [ ] Color contrast meets accessibility standards
- [ ] Icons are crisp and aligned
- [ ] Version numbers are prominently displayed
- [ ] Feature cards are evenly spaced
- [ ] Footer is properly positioned

### Refinement Pass

After initial generation, review and refine:

1. **Spacing**: Ensure mathematical consistency
2. **Alignment**: Verify all elements align to grid
3. **Typography**: Check hierarchy is clear
4. **Color**: Confirm palette cohesion
5. **Balance**: Assess overall visual weight distribution

The goal: An artifact that could be displayed in a design portfolio, shared on social media, or printed as documentation. Museum quality, every time.

---

## EXAMPLE OUTPUT

For input:
```json
{
  "previousVersion": "2.0.74",
  "latestVersion": "2.0.76",
  "features": [
    {
      "name": "LSP Tool",
      "description": "Jump to definitions and search for references within your code.",
      "usage": "Show me the definition of this function",
      "useCases": ["Navigating large codebases", "Understanding impact before refactoring"]
    }
  ],
  "improvements": ["Faster startup", "Memory leak fix"]
}
```

Generate a 1200x900px PNG with:
- Header showing "v2.0.74 → v2.0.76"
- One feature card for "LSP Tool"
- Compact improvements section
- Footer with generation info

Save to: `.cache/infographics/changelog-2.0.74-to-2.0.76.png`

Output clickable path for user.
