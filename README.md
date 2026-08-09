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

LoreWeaver writes a capability's `transcript.md` and `documents/` locally at the close of an
interview — see
[`OUTPUT-CONTRACT.md` §3](https://github.com/nikhilappasani/grimoire/blob/main/skills/loreweaver/references/OUTPUT-CONTRACT.md#3-the-compendium-write).
That write is local by design; LoreWeaver never pushes to git itself. Getting a capability's folder
from a local clone onto this remote is a separate, manual step for now.

Point Grimoire at this repo by setting `GRIMOIRE_COMPENDIUM_ROOT` to your local clone of it, or by
setting `roots.compendium` in `grimoire.config.json`.

## Status

_No capabilities captured yet._
