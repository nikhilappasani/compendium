#!/usr/bin/env bash
# Structure gate for the Compendium repo.
#
# Input: a file containing changed paths (one per line, relative to the repo root).
# Every changed path must be either an allow-listed repo file or part of a well-formed
# capability capture: <slug>/transcript.md, optional <slug>/capability-spec.md,
# <slug>/documents/**, and <slug>/knowledge/**. Anything else is a violation.
#
# <slug>/knowledge/ holds the OKF concepts distilled from the interview. Everything one interview
# produced lives under its slug, so a capture reviews as a single unit.
#
# Reports EVERY violation found, then exits non-zero if any exist — never stops at the first.
# Self-contained on purpose: this repo must not depend on Grimoire's internal tooling.

set -euo pipefail

CHANGED_FILE="${1:?usage: validate-structure.sh <changed-paths-file>}"

violations=0
declare -A checked_slugs=()

report() {
  echo "VIOLATION: $1" >&2
  violations=$((violations + 1))
}

is_allowlisted() {
  case "$1" in
    README.md|LICENSE|.gitignore) return 0 ;;
    .github/*) return 0 ;;
    *) return 1 ;;
  esac
}

while IFS= read -r path; do
  [ -z "$path" ] && continue
  is_allowlisted "$path" && continue

  top="${path%%/*}"

  # A bare file at the repo root that isn't allow-listed is never valid.
  if [ "$top" = "$path" ]; then
    report "unexpected top-level file \"$path\" — expected a slug directory"
    continue
  fi

  # Slug directories are lowercase kebab-case.
  if ! [[ "$top" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    report "top-level directory \"$top\" is not a valid slug (lowercase kebab-case)"
    continue
  fi

  # Each changed file inside a slug must match the expected shape.
  rest="${path#"$top"/}"
  case "$rest" in
    transcript.md|capability-spec.md) ;;
    documents/*) ;;
    knowledge/*) ;;
    *) report "\"$path\" is outside the expected <slug>/ shape (transcript.md, documents/**, knowledge/**)" ;;
  esac

  # Once per slug: the transcript must exist in the tree (deleted files still appear in the diff,
  # so check the working tree, not the changed list).
  if [ -z "${checked_slugs[$top]:-}" ]; then
    checked_slugs[$top]=1
    if [ -d "$top" ] && [ ! -f "$top/transcript.md" ]; then
      report "slug \"$top\" has no transcript.md — a capture without a transcript is not reviewable"
    fi
  fi
done < "$CHANGED_FILE"

if [ "$violations" -gt 0 ]; then
  echo "" >&2
  echo "validate-structure: FAIL — $violations violation(s)" >&2
  exit 1
fi

echo "validate-structure: PASS"
