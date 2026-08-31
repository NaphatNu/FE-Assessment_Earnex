# 05 — Figma extraction (grounded spec for phase 04/05)

Every value below was read live from the Figma file `FE-Assessment_Earnex (Copy)`
via Figwright `get_design_context` / `get_reactions` / `save_screenshots` calls in
this session — none are estimated from a screenshot or from `docs/03-ui-and-figma.md`'s
prose. Where a call returned nothing (e.g. reactions), that is stated explicitly
rather than filled in with a guess.

Source nodes:
- Component section: `22:8707` (screenshot: `.ai/figma/22-8707.png`)
- Portfolio List screen (`UI 1`): `21:5215` (screenshot: `.ai/figma/21-5215.png`)
- Filter sheet (`Frame 23`, nested inside `UI 1`): `22:7051` (screenshot: `.ai/figma/22-7051.png`)

This file supersedes `docs/03-ui-and-figma.md` for every exact number, color, and
label. `03-ui-and-figma.md` remains the source for *rationale* (why the three
deviations were made) — this file only re-confirms those deviations still hold
against the live design and gives the numbers to build against.

## Design tokens (from `boundVariables` on the nodes read)

Colors:
| Token | Hex | Used for |
|---|---|---|
| `bg/primary` | `#FFFFFF` | screen / sheet background |
| `bg/secondary` | `#F5F5F5` | tag-chip default fill, avatar-badge fill, `Mock` button fill |
| `bg/brand` | `#F0B90B` | `Copy` button fill, selected-chip badge fill, range-slider track dots |
| `bg/brand-light` | `#FEF6D8` | filter icon badge background (selected state) |
| `bg/disabled` | `#F0F0F0` | disabled `Reset` button fill |
| `text/primary` | `#1E2329` | primary text (names, values, button labels) |
| `text/secondary` | `#707A8A` | field labels ("AUM", "30 Days PNL (USD)", "ROI", section headers) |
| `text/success` | `#0ECB81` | positive PNL/ROI/AUM values (all sample values in this screen are positive) |
| `border/default` | `#EAECEF` | card divider, chip outline, dashed chart baseline |
| `border/strong` | `#1E2329` | selected-chip outline |
| `icon/primary` | `#707A8A` | default icons |
| `icon/brand` | `#F0B90B` | brand-colored icon accents |

Spacing scale (Figma variables, px): `spacing/2`=2, `spacing/4`=4, `spacing/8`=8,
`spacing/12`=12, `spacing/16`=16, `spacing/24`=24, `spacing/32`=32.

Radius: `radius/md`=8 (cards, buttons, chips, text fields), `radius/xl`=16 (sheet
top corners), grabber/badge use full-pill radius (`100`/`99`).

Type styles used (family always `Inter`):
| Role | Weight | Size | Line height |
|---|---|---|---|
| Sheet title ("Advanced Filters") / card user name | Semi Bold | 16 | 22 |
| Card value ("15,879.46" — the big PNL number) | Bold | 20 | 28 |
| Section label ("AUM", "30 Days MDD", "Tags", "30D PnL", "7D ROI") | Regular | 12 | 16 |
| Secondary metric value ("442,547.04", "4.15%", "250") | Medium | 12 | 16 |
| Chip / button label ("Mock", "Copy", "Reset", "Confirm", tag chip text) | Semi Bold | 12 | 16 |
| Text-field value / "Mock"/"Copy" button label (14px variant) | Semi Bold | 14 | 20 |
| "API" label in sheet | Medium | 14 | 20 |
| ROI-chip label ("≥0%" etc., no explicit line-height token on this instance) | Semi Bold | 12 | 17 |

## TraderCard (`Link` frame, node `21:5299`)

- Card: 350×250 (hugs height), `radius/md` (8px) corners, `border/default` 1px
  bottom border on the content container, vertical auto-layout, `itemSpacing: 16`.
- Background: gradient `#FFF7E0` → `#FFFFFF` (43%→70% stop) behind a translucent
  `#FFFFFF33` glass fill + drop shadow (`0,0,20,0` `#0000001A`) — this is the `BG`
  instance (`Property 1=spot`), opacity 0.5 on the instance itself. Two blurred
  brand-colored (`#D89F00`) ellipses sit behind it (200px and 150px layer blur).
- Header row (padding 15px sides, 17.5px top, gap 12px):
  - Avatar: 48×48 outer container (2px padding), 44×44 circular image
    (`radius: 22`), fill token `bg/brand` behind it as the loading/fallback color.
  - Name: `User name` text, Semi Bold 16/22, `text/primary`.
  - Below name (4px gap row): copier badge — `radius: 2` pill, `bg/secondary` fill,
    padding `0 5 0 5`, icon 12×12 (`icon/primary`) + "28 / 300" text (Regular
    12/16, `text/primary`). For API traders an "API" pill sits inline after it —
    plain text, no background fill (see e.g. node `21:5397`/`21:5479`).
- PNL block (margin container, `paddingTop: 12`, content padded 15px horizontal
  from the outer container):
  - Label "30 Days PNL (USD)" — Regular 12/16, `text/secondary`.
  - Value e.g. "15,879.46" — Bold 20/28, `text/success` (green) for positive.
  - "ROI" label (Regular 12/16, `text/secondary`) + value e.g. "4.46%" (Medium
    12/16, `text/success`), 4px gap between label and value.
  - A 92×48 sparkline chart sits to the right (Highcharts-exported vector paths —
    render as a custom sparkline/chart widget, not a literal asset).
- Stats row (3 equal columns, `paddingTop: 12`): `AUM`, `30 Days MDD`,
  `Days Leading Trading` — each a label (Regular 12/16, `text/secondary`) over a
  value (Medium 12/16, `text/primary`, right-aligned for the third column). **This
  confirms deviation ① in `docs/03-ui-and-figma.md`: the design's third column is
  literally "Days Leading Trading" with no Sharpe Ratio field anywhere in this
  card.** `lib/src/domain/trader.dart` has `sharpeRatio` and no
  `daysLeadingTrading`/leading-trading field, and `assets/data/mock_data.json` has
  no such values either — the deviation still holds exactly as documented: keep
  the design's 3-column layout, replace the third column's label/value with
  Sharpe Ratio, drop Days Leading Trading entirely.
- Actions row (`paddingTop: 12`, gap `spacing/8`=8): `Mock` button — fixed
  85×32, `radius/md`, `bg/secondary` fill, Semi Bold 14/20 label, `minWidth: 52`.
  `Copy` button — fills remaining width, 32 tall, `radius/md`, `bg/brand` fill,
  Semi Bold 14/20 label.

## Portfolio List screen (`UI 1`, node `21:5215`)

- Status bar (native, 62 tall) → promo/header block (banner text "Spot Copy
  Trading", "Follow the world's top crypto traders...", an "Elite Trader
  Program" promo card) → tab bar → card list. The promo/header/tabs are outside
  this assessment's scope (phase 04 builds `HeaderSection`/`TabBarSection` per
  `docs/03-ui-and-figma.md`'s existing description — nothing here contradicts it,
  the header block was not itemized to the pixel since it is not part of the
  scored deliverable).
- Tab bar row (39 tall): "Recommended", "All Portfolios", "My Favorites" tabs,
  plus a "Smart Copy" pill button on the trailing side (24 tall, out of scope).
- List content row above the cards (44 tall): "High PNL" sort label (left,
  Regular text + chevron icon) and "More" (right, text + chevron icon) — sits
  directly above the card stack, 44px tall, 16px horizontal padding.
- Cards stack vertically with **no gap between cards in this node tree** — each
  `Link` frame is 250 tall and the next starts immediately after (`y: 0, 266, 532`
  → 16px gap, since 250+16=266). So: **16px vertical gap between cards**, 20px
  horizontal inset from the screen edge on each side (`x: 20`, `width: 350` inside
  a 390-wide screen).
- **No filter icon/badge instance exists directly in this screen's node tree** —
  the "Filter list" component with badge (node `22:5871`, state=selected) lives
  only in the Component section (`22:8707`), not instantiated inside `UI 1`. The
  filter icon shown at approximately `x:722,y:669` in the section-relative
  overview is a design annotation arrow pointing at where it *would* sit, not a
  live instance with a resolvable subtree. Build `FilterIconWithBadge` from the
  Component-section instance styling below — it is the actual source of truth for
  that widget's visuals.

### Filter icon + badge (`Filter list`, state=selected, node `22:5871`)

- Container: 40×40, `radius/md` (8px), fill `bg/brand-light` (`#FEF6D8`).
- Icon: 24×24 centered, `Filter list` component instance.
- Badge: 20×20 pill (`radius: 99`), positioned top-right (`x:28,y:-7` relative to
  the 40×40 container — i.e. overlapping the top-right corner), fill `bg/brand`
  (`#F0B90B`), count text centered, Regular 10/14, `text/primary` (`#1E2329`).
- Design shows badge count "2" on this instance — per `docs/03-ui-and-figma.md`'s
  own note, **this is sample data, not a spec**: bind it to the real
  `filteredCountProvider`, do not hardcode "2".

## Filter sheet (`Frame 23`, node `22:7051`)

- Sheet frame: 390×685, **absolutely positioned at `y: 167`** inside the 852-tall
  screen (i.e. covers the bottom ~80.4% of the screen, top 167px shows the dimmed
  list behind it). Top corners `radius/xl` = 16px, bottom corners square (it's
  full-bleed to the screen bottom). Sheet background: `bg/primary` (`#FFFFFF`).
- A separate `dim` instance (`22:5771`, full 390×852, `mainComponentId: 22:5766`)
  sits behind the sheet as the scrim.
- Header (`Frame 22`, 63 tall): 4px top padding, grabber pill (36×5, `radius:100`,
  fill `#CCCCCC`, `blendMode: LINEAR_BURN`, centered horizontally) then 20px gap
  then title "Advanced Filters" (Semi Bold 16/22, `text/primary`, full-width).
  16px horizontal padding, 12px bottom padding.
- Body (`Frame 18`, scroll content, 16px horizontal padding, **32px gap between
  sections**):
  1. **Tags** section (label: Regular 12/16, `text/secondary`) — 4 rows of chip
     pairs, `itemSpacing: 8` both directions, each chip pair `FILL`-width /
     50-50 split except the last row's single chip (fixed 178px wide, not
     stretched). The 7 chip labels, verbatim, in row order: **"Top Performer",
     "Money Maker", "Most Resilient", "Whale Manager", "Solid Growth", "Low
     Leverage", "Most Consistent"**. Chip: 38 tall, `radius/md`, `bg/primary`
     fill + `border/default` (`#EAECEF`) 1px outline in the **default/unselected**
     state (component `21:5541`, `state=default, type=outline`); Semi Bold 12/16
     label, `text/primary`. **Selected** state (component `21:5543`,
     `state=active, type=outline`): same size, `border/strong` (`#1E2329`, 1px)
     outline instead of `border/default`, label fill also `#1E2329` (same as
     border color; visually unchanged text color from unselected — the color
     change is the border only). No fill-color change between selected/unselected
     — selection reads purely through the border weight/color.
     Confirms **deviation ③** in `docs/03-ui-and-figma.md`: these 7 labels are
     the complete chip set in the design; `High Risk` (present on 2 traders in
     `assets/data/mock_data.json`, confirmed via grep) has no corresponding chip
     anywhere in the Component section or this sheet — do not invent one.
  2. **30D PnL** section — label + two text-field instances ("0" / "500000",
     Semi Bold 14/20, `bg/secondary` fill, `radius/md`, joined by a "-" glyph)
     representing a min/max range, plus a track-and-handles graphic below
     (`Frame 20`: a `border/strong` 2px line with two `bg/brand` 16px circular
     handles at each end) — a **range slider control**, not wired to any
     provider per `docs/03-ui-and-figma.md` deviation ②.
  3. **7D ROI** section — label + 2×2 grid of chips: **"≥0%", "≥25%", "≥50%",
     "≥100%"** (Semi Bold 12/17, unselected style identical to the Tags chips).
  4. **API** row (`Frame 27`, 50 tall) — "API" label (Medium 14/20) on the left,
     a toggle switch on the right (64×28 pill, `State=Off` in this snapshot,
     off-fill `#3C3C434D`, knob `#FFFFFF`).
- Footer (`Frame 24`, outside the scrollable body, 16px top padding + **60px
  bottom padding** for safe-area/home-indicator clearance): `Reset` /
  `Confirm` buttons, `itemSpacing: 8`, each `FILL`-width/50-50, 38 tall,
  `radius/md`. In this snapshot `Reset` is `state=disabled` (fill `bg/disabled`
  `#F0F0F0`) and `Confirm` is `state=enabled, type=filled` (fill `bg/brand`
  `#F0B90B`) — i.e. **Reset starts disabled and only enables once a draft
  selection differs from the reset state; Confirm is always enabled/filled.**

## Prototype transition (sheet open/close)

`get_reactions` was called on the list screen (`21:5215`), the sheet frame
(`22:7051`), the scrim instance (`22:5771`), the filter-icon instance (`21:5218`
— status bar, checked as a smoke test), and the prototype root (`22:12253`).
**Every call returned an empty `reactions` array.** This file/section is a static
multi-frame mockup (`UI 1`…`UI 7`, one frame per state) with hand-drawn arrow
annotations between frames, not a wired Figma prototype with click reactions —
so there is no real animation/transition data to extract.

Given that, and the frame's own geometry (sheet occupies the bottom 685 of 852px,
i.e. ~80% of screen height, top corners rounded 16px, backed by a full-screen
scrim), phase 04/05 should use Flutter's standard
`showModalBottomSheet(isScrollControlled: true, ...)` sized to that same
proportion (or `DraggableScrollableSheet` if drag-to-resize is wanted — the
design's grabber pill implies drag-to-dismiss, not drag-to-resize, so a fixed
height with swipe-down-to-dismiss is the closer match). This is a documented
default, not a value read from Figma — noted here explicitly per the
acceptance criteria.

## Reconciliation against `docs/03-ui-and-figma.md`'s three claimed deviations

All three were re-checked against the live file/data in this session and **still
hold exactly as documented**:

1. **Sharpe Ratio replacing Days Leading Trading** — confirmed. The design's
   third stat column literally reads "Days Leading Trading" (node `21:5367`/
   `21:5449`/`21:5507` etc.); `Trader` has `sharpeRatio` and no matching field.
2. **Sheet has more sections than the task requires** — confirmed. The sheet has
   Tags / 30D PnL range / 7D ROI chips / API toggle / Reset+Confirm; only Tags
   (+ Reset/Confirm) needs live logic.
3. **`High Risk` tag has no chip** — confirmed. The 7 chip labels in the Tags
   section (listed above) do not include "High Risk", which mock data does
   carry (2 traders, verified via grep on `assets/data/mock_data.json`).

## Component/token reuse check

`lib/src/ui/` does not exist yet (phase 04/05 have not run) — there is no
existing Flutter widget code to cross-reference against `component_map`/
`token_map`/`icon_map` yet. The token table above is the reuse surface phase
04/05 should build against (map each hex/spacing value to a Dart
`ThemeExtension`/constant using these names, not raw literals).
