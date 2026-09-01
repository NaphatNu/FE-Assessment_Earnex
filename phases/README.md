# Execution phases — Trader Portfolio List with Filter

Design rationale lives in `docs/`. These files are the **work orders**: one file = one branch = one PR.

Run in order. Each phase is self-contained — the executing agent should read **only its own phase file**, never the whole folder.

| # | Phase | Depends on |
|---|---|---|
| 01 | Data layer — model, mock asset, repository | — |
| 02 | State layer — FilterState + 5 providers | 01 |
| 03 | State layer tests | 02 |
| 03.5 | Ground UI in real Figma file (Figwright, not delegable) | 01 |
| 04 | Portfolio list UI | 02, 03.5 |
| 05 | Filter bottom sheet (decoupled) | 02, 04, 03.5 |
| 06 | UI states and README | 04, 05 |

## Remediation phases (07–12)

Phases 01–06 shipped the app. An audit of the merged result against `docs/` and the phase files
then found gaps that the `format`/`analyze`/`test` gate cannot see: the tree used the
package-only `lib/src/` convention, the data layer had drifted from its phase-01 contract, two
behaviours recorded as decided in `docs/04` were never built, and some documents no longer
described the code. These phases close that list.

**Precondition: the Figma-alignment UI branch must be merged into `main` before phase 07 runs.**
Phase 07 moves every file the UI work touches; in the other order every UI file conflicts as
rename-vs-modify.

| # | Phase | Depends on | Tier |
|---|---|---|---|
| 07 | Restructure `lib/src/` to feature-first | UI branch merged | coding |
| 08 | Data layer: conform to the phase-01 contract | 07 | coding |
| 09 | `99+` badge, avatar initials, format helpers | 07, 08 | coding |
| 10 | Finish the token migration in `widgets/states/` | 07 | cheap |
| 11 | Reconcile the documents with what was built | 07–10 | cheap |
| 12 | Convention cleanup (optional) | 07–11 | cheap |

Phase 07 runs alone. 08, 09 and 10 touch disjoint files and may run in parallel afterwards —
though 09 reads field names that 08 renames, so merge 08 first if you run them one at a time.
11 must be last but one, because it describes the merged result; 12 is optional.

Each of these files pins every value the executing agent needs, and each names the exact files
it may read and touch. **The agent should not open `docs/` from inside phases 07–12** — the
relevant values are already copied into the phase file.

## How to run one phase

```bash
git checkout -b phase-01 && cat phases/01.md
```

See `phases/RUN.md` for the prompt to start a phase. Then hand that file's contents to the OpenRouter coding tier (`ccr code`) — every phase is scoped so no design decisions remain, **except phase 03.5, which needs live Figma MCP access and must be run directly by Claude, not delegated**. Gate before every PR:

```bash
dart format . && flutter analyze && flutter test
```

## Standing rules for all phases

- Hand-written Riverpod. No `riverpod_generator`, no `build_runner`.
- No `late`, no `!`, no `dynamic` in production code.
- Filtering logic lives only in `FilterState.matches` — never inside a widget.
- Only `TraderList`, `FilterIconWithBadge`, `TagChipGroup` and `SheetActions` may `watch` a
  provider. `SheetActions` watches `draftFilterProvider` because the Figma footer spec makes
  `Reset` disabled until the draft is non-empty. Every other widget takes plain constructor
  params.
- `FilterBottomSheet` must stay constructible as `const FilterBottomSheet()`.
- Do not edit files outside the phase's stated scope.

## Corrections after phases 01-06

1. Layout. `lib/src/...` (a package convention, wrong for an app) was replaced by feature-first
   in phase 07. Path map: `lib/src/data/` -> `lib/data/`; `lib/src/domain/` ->
   `lib/features/portfolio/domain/`; `lib/src/providers.dart` ->
   `lib/features/portfolio/presentation/portfolio_providers.dart`; `lib/src/ui/theme/tokens.dart`
   -> `lib/theme/tokens.dart`; the rest of `lib/src/ui/` ->
   `lib/features/portfolio/presentation/{,widgets/,widgets/states/,filter/}`. `test/` mirrors
   `lib/`, shared fakes in `test/support/`.
2. Tag vocabulary. Phase 01 named 5 tags. Phase 03.5 read the real Figma file and found 7 chips,
   and the data carries an 8th (`High Risk`) with no chip. The 8 tags in
   `assets/mock/traders.json` are authoritative; the 5-tag list in phase 01 is superseded.
3. Field names. Phase 08 restored the phase-01 spelling (`isApi`, `copiers`, `copiersMax`, `roi`,
   `sharpe`) and the asset path `assets/mock/traders.json`.
4. `mocktail` was not added (phase 01 listed it). The suite fakes the repository and the asset
   bundle by hand, so the package would be an unused dependency.
5. Test file names. Phase 03 asked for `test/filter_state_test.dart` and `test/providers_test.dart`;
   the suite is instead split per provider and mirrors `lib/`.
