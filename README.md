# Compendium

The raw evidence behind capabilities specified with [LoreWeaver](https://github.com/nikhilappasani/grimoire):
interview transcripts and the source documents a subject-matter expert supplied, one folder per
capability.

```text
compendium/
└── <slug>/
    ├── transcript.md      the full interview Q&A, verbatim, in question order
    └── documents/         source documents as supplied
```

## What this is, and isn't

This is **not** a knowledge base. A knowledge base holds small, distilled, curated facts meant to be
read by a running skill. This repo holds the bulkier, unprocessed material those facts were drawn
from — full transcripts and raw documents, never distilled, never filtered for relevance. Its growth
profile is expected to be larger and messier than a knowledge base on purpose; keeping the two apart
means document churn here never touches a knowledge base's git history or its browsing experience.

## The one hard rule

**Confidential content, secrets, and personal or regulated data are never committed here.** A
document containing any of those gets a short neutral note plus a link back to its actual source
instead of being copied in — full rule and rationale in
[Grimoire's `KNOWLEDGE-CAPTURE-OKF.md`](https://github.com/nikhilappasani/grimoire/blob/main/skills/loreweaver/references/KNOWLEDGE-CAPTURE-OKF.md#7-hard-rules-during-extraction).

LoreWeaver enforces this at write time. If you're adding something here by hand, apply the same
rule yourself before committing.

## How content gets here

At the close of an interview, LoreWeaver writes a capability's `transcript.md` and `documents/`
locally, then runs `grimoire compendium-push <slug> --auto` — see
[`OUTPUT-CONTRACT.md` §3](https://github.com/nikhilappasani/grimoire/blob/main/skills/loreweaver/references/OUTPUT-CONTRACT.md#3-the-compendium-write-and-publish).
That script secret-scans the capture, commits it to a `compendium/<slug>` branch cut from `main`'s
tip, and pushes that branch. It never pushes to `main`, never uses `--force`, and never merges.

`.github/workflows/compendium-ci.yml` in this repo picks it up from there:

1. **validate-structure** — every changed path must be an allow-listed repo file or part of a
   well-formed capture (`<slug>/transcript.md`, optional `<slug>/capability-spec.md`,
   `<slug>/documents/**`). Reports every violation, not just the first.
2. **secret-scan** — gitleaks, as a backstop to the client-side scan that a modified client could
   skip.
3. **open-pr** — opens the review pull request, but only if both checks passed.

The pull request is opened *here*, by CI, precisely so the machine that ran the interview never
needs the `gh` CLI or an API token — only git push access. **A human reviews and merges. Nothing in
this repo merges, approves, or closes anything on its own.**

### Pointing Grimoire at this repo

Any one of these, first hit wins:

```bash
export GRIMOIRE_COMPENDIUM_ROOT=~/code/compendium    # your own clone
```

```json
"roots":   { "compendium": "./compendium" },          // in grimoire.config.json
"compendiumRepository": "git@github.com:nikhilappasani/compendium.git"
```

With only `compendiumRepository` set, the publish script maintains its own clone under
`~/.grimoire/compendium` and clones it on first use — the zero-setup path for a machine that has
never seen this repo.

## Status

_No capabilities captured yet._
