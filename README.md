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
locally, shows you their full content for approval, and only then pushes — see
[`OUTPUT-CONTRACT.md` §3](https://github.com/nikhilappasani/grimoire/blob/main/skills/loreweaver/references/OUTPUT-CONTRACT.md#3-the-compendium-write-and-publish).

```bash
grimoire compendium-push <slug> --review              # prints the content and a digest
grimoire compendium-push <slug> --auto --reviewed <digest>
```

The digest binds the approval to the exact bytes reviewed: if the capture changes in between, the
push is blocked rather than shipping something nobody read. The script then secret-scans the
capture, commits it to a `compendium/<slug>` branch cut from `main`'s tip, and pushes that branch.
It never pushes to `main`, never uses `--force`, and never merges.

`.github/workflows/compendium-ci.yml` in this repo picks it up from there:

1. **validate-structure** — every changed path must be an allow-listed repo file or part of a
   well-formed capture: `<slug>/transcript.md` (required), `<slug>/documents/**`, and
   `<slug>/capability-spec.md` if someone chooses to file a copy of the spec alongside its evidence
   by hand — Grimoire itself writes specs to a separate `specs` root, never here. Reports every
   violation, not just the first.
2. **secret-scan** — gitleaks, as a backstop to the client-side scan that a modified client could
   skip.
3. **open-pr** — opens the review pull request, but only if both checks passed.

The pull request is opened *here*, by CI, precisely so the machine that ran the interview never
needs the `gh` CLI or an API token — only git push access. **A human reviews and merges. Nothing in
this repo merges, approves, or closes anything on its own.**

### Required repository settings — do this once

GitHub disables both of these by default, and the `open-pr` job cannot work without them. Until
they are set, pushes still succeed and the checks still run; only the automatic PR fails, and the
job explains exactly this.

**Settings → Actions → General → Workflow permissions**

1. Select **Read and write permissions**
2. Tick **Allow GitHub Actions to create and approve pull requests**

Then re-run any failed `open-pr` job — nothing needs re-pushing, because the branch is already here.

If you would rather not grant those permissions, the flow still works; you just open the pull
request yourself from the pushed branch. `grimoire compendium-push` prints a ready-made compare URL
for exactly that case.

### Pointing Grimoire at this repo

Pick whichever suits the machine. If more than one applies, the first one here wins.

**1. You already have a clone** — point an environment variable at it:

```bash
export GRIMOIRE_COMPENDIUM_ROOT=~/code/compendium
```

**2. Same idea, written into config** — `roots.compendium` in `grimoire.config.json`:

```json
{
  "roots": { "compendium": "/home/you/code/compendium" }
}
```

**3. You have neither, and want zero setup** — give Grimoire the repo URL and let it manage its own
clone under `~/.grimoire/compendium`, created on first use:

```json
{
  "compendiumRepository": "git@github.com:nikhilappasani/compendium.git"
}
```

Option 3 is the one that makes a brand-new machine work without anybody preparing it. Use the SSH
URL if the machine authenticates to GitHub with an SSH key, or the `https://` URL if it uses a git
credential helper.

## Status

_No capabilities captured yet._
