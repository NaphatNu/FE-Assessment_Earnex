# Execution phases — Trader Portfolio List with Filter

Design rationale lives in `docs/`. These files are the **work orders**: one file = one branch = one PR.

Run in order. Each phase is self-contained — the executing agent should read **only its own phase file**, never the whole folder.

| # | Phase | Depends on |
|---|---|---|
| 01 | Data layer — model, mock asset, repository | — |
| 02 | State layer — FilterState + 5 providers | 01 |
| 03 | State layer tests | 02 |
| 04 | Portfolio list UI | 02 |
| 05 | Filter bottom sheet (decoupled) | 02, 04 |
| 06 | UI states and README | 04, 05 |

## How to run one phase

```bash
git checkout -b phase-01 && cat phases/01.md
```

Then hand that file's contents to the OpenRouter coding tier (`ccr code`) — every phase is scoped so no design decisions remain. Gate before every PR:

```bash
dart format . && flutter analyze && flutter test
```

## Standing rules for all phases

- Hand-written Riverpod. No `riverpod_generator`, no `build_runner`.
- No `late`, no `!`, no `dynamic` in production code.
- Filtering logic lives only in `FilterState.matches` — never inside a widget.
- Only `TraderList`, `FilterIconWithBadge` and `TagChipGroup` may `watch` a provider.
- `FilterBottomSheet` must stay constructible as `const FilterBottomSheet()`.
- Do not edit files outside the phase's stated scope.
