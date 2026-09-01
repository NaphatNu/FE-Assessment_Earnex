# Start prompt (paste into a fresh Claude Code session)

Replace `NN` with the phase number.

- **Build phases (done):** 01 → 02 → 03 → 03.5 → 04 → 05 → 06.
- **Remediation phases:** 07 → 08 → 09 → 10 → 11 → 12. Phase 07 must run alone and only after
  the Figma-alignment UI branch is merged into `main` — it moves every file that branch touches.
  After 07 is merged, 08 / 09 / 10 touch disjoint files; if you run them one at a time, merge 08
  before 09 (09 uses field names 08 renames). 11 second-to-last, 12 optional.

**Phase 03.5 is different: do not delegate it.** It needs live Figma MCP tool access
(Figwright) that only this Claude Code session has. For 03.5, skip step 2 below and
instead follow `phases/03.5.md` directly — load the `figma-design-to-code` skill
first, confirm Figwright is connected with `ping` before doing anything else, and
write the output to `docs/05-figma-extraction.md`. Everything else in the procedure
(branch, gate, PR, report, stop) still applies.

**Phases 08 and 09 are also different: Claude writes the code directly, not `openrouter-agent`.**
Each phase file says so at the top ("Execution: Claude writes this directly"). For those two,
skip step 2 below entirely — write the implementation yourself against the phase file, then go
straight to step 3 (the gate). Every other phase (01–07, 10–12) delegates per step 2.

```
Run phase NN.

Read ONLY phases/NN.md and phases/README.md. Do not read docs/ or any other
phase file unless phases/NN.md tells you to — token budget is tight.

Steps:
1. git checkout main && git pull && git checkout -b phase-NN
2. Check the "Execution" line at the top of phases/NN.md.
   - **If it says "Claude writes this directly":** skip to step 3 and write the
     implementation yourself, exactly against the phase file.
   - **Otherwise ("delegate via the openrouter-agent skill"):** delegate the whole
     implementation via the openrouter-agent skill (`ccr code`), using the tier named
     at the top of phases/NN.md. Pass it the full contents of phases/NN.md plus the
     "Standing rules" section of phases/README.md. Do not write the production code
     yourself in this case. If phases/NN.md lists "Files this phase may touch", pass
     that list as a hard boundary: nothing outside it may be opened or edited.
3. Gate: dart format . && flutter analyze && flutter test
   If it fails and phases/NN.md was delegated, send the error output back to ccr for
   a second pass — only fix it yourself if ccr fails twice on the same error. If
   phases/NN.md was Claude-direct, just fix it and re-run the gate.
4. Commit, push, open a PR titled "Phase NN — <phase title>". PR body: the
   acceptance evidence that phases/NN.md asks for (real command output, pasted
   verbatim — never paraphrased or invented), and say which execution mode was used.
5. Report to me: what landed, the gate output, and anything in phases/NN.md you
   could NOT do and why. Stop there — do not merge and do not start phase NN+1.

If phases/NN.md is ambiguous or conflicts with the code you find, stop and ask
me. Do not invent a design decision.
```

## Ready to paste

| Phase | First line to send |
|---|---|
| 01 | `Run phase 01.` … (rest of the block above) |
| 02 | `Run phase 02.` |
| 03 | `Run phase 03.` |
| 03.5 | `Run phase 03.5.` — figma-grounding, not delegated, see note above |
| 04 | `Run phase 04.` |
| 05 | `Run phase 05.` |
| 06 | `Run phase 06.` |
| 07 | `Run phase 07.` — requires the UI branch merged first; delegated, pure `git mv` + imports |
| 08 | `Run phase 08.` — **Claude writes directly** |
| 09 | `Run phase 09.` — **Claude writes directly**; merge 08 first |
| 10 | `Run phase 10.` — delegated, cheap tier |
| 11 | `Run phase 11.` — delegated, cheap tier, docs only, run after 07–10 are merged |
| 12 | `Run phase 12.` — delegated, cheap tier, optional |

## Shortcut

After phase 01, later phases can just be:

```
Run phase NN — same procedure as phases/RUN.md.
```

if the session already ran an earlier phase and still has the procedure in context.
