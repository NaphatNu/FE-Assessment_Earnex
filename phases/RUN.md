# Start prompt (paste into a fresh Claude Code session)

Replace `NN` with the phase number. Run phases in order: 01 → 02 → 03 → 04 → 05 → 06.

```
Run phase NN.

Read ONLY phases/NN.md and phases/README.md. Do not read docs/ or any other
phase file unless phases/NN.md tells you to — token budget is tight.

Steps:
1. git checkout main && git pull && git checkout -b phase-NN
2. Delegate the whole implementation to OpenRouter via the openrouter-agent
   skill (`ccr code`, coding tier). Pass it the full contents of phases/NN.md
   plus the "Standing rules" section of phases/README.md. Do not write the
   production code yourself.
3. Gate: dart format . && flutter analyze && flutter test
   If it fails, send the error output back to ccr for a second pass. Only fix
   it yourself if ccr fails twice on the same error.
4. Commit, push, open a PR titled "Phase NN — <phase title>". PR body: the
   acceptance evidence that phases/NN.md asks for (real command output, pasted
   verbatim — never paraphrased or invented).
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
| 04 | `Run phase 04.` |
| 05 | `Run phase 05.` |
| 06 | `Run phase 06.` |

## Shortcut

After phase 01, later phases can just be:

```
Run phase NN — same procedure as phases/RUN.md.
```

if the session already ran an earlier phase and still has the procedure in context.
