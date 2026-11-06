# Homelab Public agent rules

`CLAUDE.md` and `AGENTS.md` are the same document under two names so Claude
Code and Codex follow identical rules. Change both together and keep their
contents identical.

## 1. Purpose and audience

This repository documents a small home server built from a retired desktop:
what it is used for, why the pieces are there, and what a reader could try in
their own setup. Everything committed here is public and must be suitable for
anyone on the internet to read, copy, or quote.

The audience includes people who have never run a server. Explain what
something does and why it is useful before naming technical details. Define
unfamiliar terms on first use. Keep the writing grounded and approachable;
avoid command-heavy instructions, marketing language, and claims of security,
performance, cost, or reliability that the evidence does not support.

Keep the repository focused on setup documentation, tooling references, and
technical lessons. Do not add blog posts, article drafts, topic lists, or
publishing code here.

## 2. Layout

| Path | What lives there |
|---|---|
| `README.md` | The entry point for new readers |
| `docs/` | Architecture, decisions, projects, tooling, lessons, and the publishing checklist |
| `docs/images/` | Images the README and docs embed |
| `examples/` | Newly written examples with fictional values |
| `.github/workflows/checks.yml` | Link check and secret scan |

Before editing, read `README.md`, `docs/architecture.md`, and
`docs/before-you-publish.md`, then the pages the change affects.

## 3. What belongs in public documentation

Broad hardware descriptions, the purpose of each environment, software names,
conceptual diagrams, and general recovery lessons are useful. Existing content
sets the current level of detail; it is not blanket approval to disclose more.

- Use generic roles such as "applications", "games", and "personal
  experiments".
- Diagrams explain relationships without mapping an actual network.
- Prefer newly written examples with fictional values over edited real
  configuration.
- Avoid exact versions, detailed resource allocations, schedules, and provider
  choices unless they add clear reader value.
- Do not invent experiences or imply something is deployed, tested, secure,
  inexpensive, or currently healthy because it sounds plausible. Date
  historical evidence where useful; these notes are a curated snapshot, not a
  live status page.

## 4. What never goes in

- Credentials, private keys, recovery codes, tokens, environment files,
  infrastructure state, vaults, logs, database exports, backups, disk images,
  or raw configuration.
- Real IP addresses, internal hostnames, personal domains, access URLs, port
  mappings, administration paths, network details, account or player IDs,
  usernames, email addresses, location clues, device serials, or personal file
  paths.
- Screenshots or photos that have not been reviewed for identifying content
  and metadata.

Use `docs/before-you-publish.md` for the content review. If it is unclear
whether a detail belongs in public, leave it out. The automated checks support
review; they do not prove a file is safe to publish.

## 5. Checks, branch model and landing

- Single branch `main`, no prod branch; changes land on `main`, and outside
  contributions arrive as pull requests against it.
- CI (`.github/workflows/checks.yml`) checks Markdown links and scans history
  for secrets. Before committing, run `git diff --cached --check` and verify
  local document links.
- Never force-push or rewrite published history, and never change the
  repository's visibility or settings.
- Commits carry no AI attribution trailers.

## 6. Writing rules

- **No em dashes.** Never write an em dash in this repository: docs, READMEs,
  comments, commit messages. Reword with a colon, semicolon, comma,
  parentheses or a new sentence; do not substitute a hyphen or en dash. Use
  ASCII punctuation.
- A change to what a page or diagram shows updates the README images in
  `docs/images/` in the same change.
