# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A suite of agent skills (Markdown, written in Spanish) for building software projects under the "SDD harness engineering" methodology, with Notion as the task/context/documentation manager. There is no application code, build system, or test suite — the only executables are the packaging script and the neutrality checker.

> **This repo is public and written for third parties** — people who do not know
> the author's projects and will run these skills against their own systems. Two
> consequences govern everything below: nothing identifiable from a real project
> may enter the repo, and no example may bias the reader toward a domain or a
> stack that is not theirs.

## Commands

```bash
./scripts/package.sh                     # packages each skills/<name>/ (that has a SKILL.md) into dist/<name>.skill
./scripts/install-hooks.sh               # enables the neutrality hooks (once per clone)
./scripts/check-neutralidad.sh --all     # full neutrality audit of the tree
./scripts/seed-permitidos.sh             # regenerates the allowlist from the tree (only if the tree is verified clean)
```

The script is bash (run via Git Bash on Windows). For each skill it copies `shared/interop-notion.md` into the skill's `references/` and zips the folder into `dist/`. `dist/` is generated output and not versioned.

## Architecture

- `shared/interop-notion.md` — the interoperability contract between all skills: canonical Notion project structure, single P-table (open questions) per project, page ownership per skill, handoffs as the interface between skills, cross-skill gates, shared "Lecciones SDD" page. **This is the single source of truth.** Copies inside packaged skills are build artifacts — never edit the contract anywhere but `shared/`. A change to it affects the whole suite and should be reviewed as such.
- `skills/<name>/` — one skill per folder: `SKILL.md` (frontmatter with `name` + trigger `description`, then the skill body) plus optional `references/` and `templates/`.

Most skills operate over a shared Notion project: `derivar-proyecto` and `sdd-harness-notion` build it, `project-onboarding` documents it and `project-deck` presents it, and the QA skills test it. `git-workflow` is cross-cutting — it governs how agents use Git in any repo (pipeline project or not) and coordinates through the same Notion contract:

| Skill | Integración prevista | Role |
|---|---|---|
| `derivar-proyecto` | Claude | Discovery for projects derived from an existing one: inheritance matrix, anti-carryover guards |
| `sdd-harness-notion` | Claude | Construction: phases with human-review gates, stages atomized in Notion, evidence per acceptance criterion |
| `project-onboarding` | Claude | Documentation: one-shot Notion snapshot of a project (vision, architecture, flows, data model, integrations, setup) with Mermaid diagrams; feeds `project-deck` |
| `project-deck` | Claude | Presentation: generates a project PPTX as a point-in-time snapshot; audience-driven (technical / stakeholder / user manual); consumes `project-onboarding`'s `diagrams-export` |
| `qa-discovery` | Kiro | QA planning: test-surface map, L1–L6 taxonomy; entry point of the QA suite |
| `qa-generator` | Kiro | QA execution: materializes discovery handoffs into test suites per mode (unitario/integracion/e2e/infraestructura) |
| `git-workflow` | Any agent | Cross-cutting: governs Git usage in any repo — proposes commits/branches/PRs, protects history, coordinates branching decisions with Notion; never acts without user confirmation |

> *"Integración prevista" indica el runtime para el que se diseñó cada skill originalmente. Todas las skills son portables a Kiro y Claude/Claude Code; ver* `shared/interop-notion.md` *para las equivalencias de herramienta por runtime.*

Skills communicate only through Notion artifacts (P-table, handoffs, gates), not by reading each other's files — that contract is what `shared/interop-notion.md` defines.

## Repo rules

1. Behavior changes to a skill → edit its `SKILL.md` or `references/`, and record version + reason in `CHANGELOG.md`.
2. **No real-project material, on any surface.** No client, company, product,
   repo or internal-system names; no business rules with their actual values; no
   identifiers, tables, endpoints or paths from a real system; no real domains,
   emails or DOM selectors. This applies equally to `SKILL.md`, `references/`,
   `templates/`, `CHANGELOG.md`, **file names, branch names and commit
   messages** — the commit message is the surface that is easiest to forget and
   the one no diff review looks at.
   The correct place to keep the learning from a real case is the user's
   **"Lecciones SDD"** page in Notion, which is private. What stays in the repo
   is the *shape* of the finding, never the datum nor the project it came from:
   "an identifier that differs between two systems" is method; naming the two
   systems is exposure.
3. No secrets: no tokens, credentials, or private Notion URLs.
3b. **Examples come from the synthetic universe** defined in
   `UNIVERSOS-SINTETICOS.md`: one file, one universe, declared in its header.
   Skills are stack- and domain-agnostic — a stack may appear as a *declared
   example*, never as a requirement.
3c. **Neutrality is verified before committing, not after.** The hooks installed
   by `./scripts/install-hooks.sh` check staged content, file names, commit
   messages and branch names. The CI workflow is an **audit, not a barrier**: it
   runs after the push, when the content is already on the server.
   The mechanical check cannot catch semantic leakage — an example with no
   forbidden string that still draws a recognisable sector or architecture. When
   editing a skill's examples, also run Prompt C of `UNIVERSOS-SINTETICOS.md`
   over the touched files.
4. Skill content is written in Spanish; keep new/edited content in Spanish for consistency.
5. SKILL.md frontmatter must be valid YAML: quote the `description`
   (it contains colons). package.sh does not validate — a broken
   frontmatter packages fine and fails at install time.
6. The frontmatter `description` is the skill's trigger — editing it
   changes WHEN the skill activates, not just its docs. Treat trigger
   edits as behavior changes (CHANGELOG) and preserve the existing
   trigger keywords unless the change is deliberate.
