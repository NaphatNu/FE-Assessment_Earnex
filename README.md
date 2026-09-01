# Trader Portfolio List with Filter

A Flutter + Riverpod app showing a list of Lead Traders, filterable through a
bottom sheet that is fully decoupled from the list screen. Built as a
front-end assessment focused on Riverpod state design.

## Running it

```bash
flutter pub get
flutter run            # or: flutter run -d chrome
flutter test           # run the test suite
```

## Architecture

Data flows one way, down: a local JSON asset (`assets/data/mock_data.json`) is
read by `AssetTradersRepository` behind the `TradersRepository` interface,
loaded once by `tradersProvider`, combined with the active filter in
`filteredTradersProvider`, and rendered by `TraderList`. Writes flow the other
way, up: widgets never mutate state directly, they only call methods on a
`Notifier` (`toggleTag`, `reset`, `apply`, `clear`), and the derived providers
recompute automatically. All filtering logic lives in `FilterState.matches` —
no widget contains filtering logic itself.

## The 5 providers

| Provider | Type | Lifetime | Purpose |
|---|---|---|---|
| `tradersProvider` | `FutureProvider<List<Trader>>` | app lifetime | Loads and parses the mock trader data once |
| `appliedFilterProvider` | `NotifierProvider<AppliedFilterNotifier, FilterState>` | keepAlive (app lifetime) | The filter that actually affects the visible list |
| `draftFilterProvider` | `NotifierProvider.autoDispose<DraftFilterNotifier, FilterState>` | sheet lifetime | What the user is currently picking inside the open filter sheet, seeded from `appliedFilterProvider` |
| `filteredTradersProvider` | `Provider<AsyncValue<List<Trader>>>` | derived | Combines `tradersProvider` and `appliedFilterProvider` into the list the UI renders |
| `filteredCountProvider` | `Provider<int?>` | derived | Feeds the badge on the filter icon; `null` while loading |

## How the bottom sheet stays decoupled

`FilterBottomSheet` has a `const` constructor with no fields other than `key`
— it takes **zero** filter data from its caller. It reads the user's current
selection from `draftFilterProvider` and writes changes back to it
(`toggleTag`, `reset`); only "Confirm" copies the draft into
`appliedFilterProvider`, which is the value the list actually reacts to. The
call site is just:

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (_) => const FilterBottomSheet(),
);
```

The fact that `const FilterBottomSheet()` compiles at all is a one-line,
compiler-checked proof that no filter state is threaded through the
constructor — if the sheet ever needed parent-supplied data, it could no
longer be `const`.

## Deliberate deviations from the Figma design

See [`docs/03-ui-and-figma.md`](docs/03-ui-and-figma.md) for the full
reasoning; in short:

1. **Sharpe Ratio replaces "Days Leading Trading"** in the card's third stat
   column. The design's own layout shows "Days Leading Trading" there, but
   neither `Trader` nor the mock data has that field, while the task
   explicitly asks for Sharpe Ratio to be visible — Sharpe Ratio was placed in
   the design's existing third-column slot instead of adding a new one.
2. **Several filter sheet sections are drawn but not wired**: the 30D PnL
   range, the 7D ROI chips, and the API toggle render exactly as designed but
   have no `onChanged`/provider behind them. Only the **Tags** section is
   live, since that's the only filter dimension the task scope covers.
3. **The card sparkline is illustrative, not data.** The design puts a 92x48
   performance chart beside the PNL figure; the mock data carries no time
   series to plot. `Sparkline` therefore draws a bounded random walk seeded
   from the trader id (so a given trader always draws the same curve) and
   tinted by the sign of their PNL. No fabricated number is ever shown as
   text.
4. **The card's background glow is a radial fade, not a 200px blur.** Figma
   builds the card wash from a gold ellipse under a 200px layer blur. Blurring
   at that radius once per card is a real cost in a scrolling list, so the
   ellipse is drawn as an equivalent `RadialGradient`.
5. **Selecting multiple tags is OR, not AND.** See
   [`docs/04-data-and-ui-states.md`](docs/04-data-and-ui-states.md) for the
   numbers: with the given mock data, AND across 3 selected tags leaves at
   most 1 trader out of 18 in almost every combination, which makes the
   filter unusable. OR (any selected tag matches) was chosen instead.

## Tests

```bash
flutter test
```

Covers: `FilterState` matching logic, all 5 providers (including the
draft/applied separation and `autoDispose` discard-on-close behavior), the
mock data's tag-distribution invariants, the filter bottom sheet's full
interaction flow, and the trader list's loading/error/empty UI states.
