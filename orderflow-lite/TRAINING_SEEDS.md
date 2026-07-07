# Training Seeds

This repository intentionally contains **two seeded findings** so the DevOps
training course has real material for the Trivy (dependency/image scanning)
and GitLeaks (secret scanning) labs. Both are documented here so they are
easy to find, explain, and remove once the labs are done.

**Do not "fix" these findings without updating or removing this document.**
Trainees fixing them as part of the lab exercise is expected and fine —
just don't let a well-meaning cleanup PR silently remove the training
material outside of the lab context.

---

## Seed 1 — Trivy: known-vulnerable npm dependency

- **What**: `jest-junit` is pinned to an exact version, `16.0.0` (no `^`),
  instead of a caret range. That version depends on a vulnerable version of
  `uuid` (`<11.1.1`), which has a moderate-severity advisory:
  [GHSA-w5hq-g745-h8pq](https://github.com/advisories/GHSA-w5hq-g745-h8pq)
  — "Missing buffer bounds check in v3/v5/v6 when `buf` is provided."
- **Where**:
  - [`package.json`](package.json) — the `"//jest-junit-seeded-for-training"`
    comment key sits directly above the `devDependencies` block and marks
    the pin as `SEEDED FOR TRAINING — DO NOT UPDATE`.
  - [`package-lock.json`](package-lock.json) — locks `jest-junit` at
    `16.0.0` and `uuid` at a vulnerable `<11.1.1` version accordingly.
  - Introduced in the same commit as this file (see `git log
    TRAINING_SEEDS.md package.json`).
- **Why this one**: it's a real, currently-flagged advisory (confirm with
  `npm audit` or a Trivy filesystem/image scan), moderate severity, and
  fully contained to `devDependencies` — `jest-junit` is never installed in
  the production Docker image (the `Dockerfile`'s `builder` stage runs
  `npm ci --omit=dev`), so this carries no runtime risk. It was chosen over
  pinning a vulnerable `express` version because that cascaded into
  several unrelated high-severity transitive findings (`body-parser`,
  `path-to-regexp`, `qs`), which is more noise than a single clean lab
  finding needs.
- **How to see it flagged**:
  - `npm audit` from `orderflow-lite/`
  - `trivy fs orderflow-lite/` or `trivy image <built-image>` (the
    `node_modules` layer only exists in a `builder`-stage scan or an image
    built without `--omit=dev`; for a realistic "this shipped to prod" scan
    scenario, point Trivy at the repo filesystem/lockfile instead of the
    final runtime image)
- **Expected remediation**: change `"jest-junit": "16.0.0"` back to a caret
  range (e.g. `"^17.0.0"` or later, whichever resolves the `uuid` advisory),
  run `npm install`, confirm `npm audit` is clean, and confirm `npm test`
  still passes and still produces `junit.xml`. Then remove the
  `"//jest-junit-seeded-for-training"` comment key and this section of this
  file.

---

## Seed 2 — GitLeaks: hardcoded secret

- **What**: A hardcoded AWS-style access key ID committed into a shell
  script that simulates a legacy integration hardcoding credentials instead
  of reading them from the environment.
- **Where**:
  - [`scripts/legacy-webhook-notify.sh`](scripts/legacy-webhook-notify.sh)
    — the `AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"` line.
  - Introduced in the same commit as this file (see `git log
    scripts/legacy-webhook-notify.sh`), so it is present in git history as
    well as the working tree — GitLeaks' default detect (history) mode will
    find it either way.
- **The value used is not a real credential.** `AKIAIOSFODNN7EXAMPLE` is
  AWS's own published example Access Key ID, used throughout official AWS
  documentation (e.g. the
  [IAM access keys guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html))
  as a non-functional placeholder. It matches GitLeaks' default
  `aws-access-token` detection pattern (`AKIA` + 16 alphanumeric
  characters) so the lab produces a real, expected finding without any risk
  of leaking or resembling an actual secret.
- **Why this one**: a single, unambiguous, high-confidence finding for one
  of GitLeaks' built-in rules, isolated to one file with no other side
  effects (the script is not called from anywhere else in the app).
- **How to see it flagged**:
  - `gitleaks detect --source orderflow-lite -v` (scans history)
  - `gitleaks protect --source orderflow-lite -v` (scans working tree /
    staged changes)
- **Expected remediation**: remove the hardcoded key, read it from an
  environment variable instead (consistent with every other credential in
  this repo — see `.env.example`), and — since GitLeaks flags git
  *history*, not just the current file — either rewrite history to purge it
  (`git filter-repo` / BFG) or, more realistically for a training exercise,
  add the finding's fingerprint to a `.gitleaks.toml` allowlist with a
  comment explaining it's a rotated/placeholder value, and discuss with
  trainees why "delete the line" alone doesn't fully remediate a secret
  that's already been committed.

---

## Removing both seeds

1. Revert `package.json` / `package-lock.json` to a non-pinned, non-vulnerable
   `jest-junit` range and reinstall.
2. Delete `scripts/legacy-webhook-notify.sh` (and, if you want history fully
   clean rather than just the working tree, rewrite history to purge it).
3. Delete this file.
4. Re-run `npm audit`, a Trivy scan, and a GitLeaks scan to confirm both
   labs' findings are gone.
