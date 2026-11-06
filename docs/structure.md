# Site structure and URL policy

## Navigation

The sidebar has sixteen groups, in this order. Every group is collapsible; only *Getting Started* starts open.

1. Getting Started
2. Core Concepts
3. Sources & Input
4. Geometry
5. Effects & Color
6. Channels & Transparency
7. Text & Composition
8. Encoding & Output
9. Inspection
10. PDF
11. Recipes
12. Integrations
13. Runtime & Performance
14. CLI
15. API Reference
16. Troubleshooting & Migration

Each family (3–10, 12, 13, 16) has a landing page at `/<family>/` listing what the library provides there. The home page offers three entry points: start (installation and first pipeline), find an operation (`/reference/operations/`) and solve a task (`/examples/`).

Group labels are translated in `astro.config.mjs` (`translations: { uk: … }`).

## URLs

Published URLs never disappear. `inventory/legacy-urls.json` lists every URL that existed before this structure; `npm run check:dist` fails if one stops resolving, in English or Ukrainian. Existing pages keep their paths and are only placed in the new groups. If a page is ever moved or merged, add an Astro `redirects` entry (the base path `/oss/hokusai` and the locale prefix apply) and keep its URL in the list.

New pages use the family directory (`geometry/resize.md`, not `guide/resize.md`). English stays at `/oss/hokusai/…`, Ukrainian at `/oss/hokusai/uk/…`.

## What happened to each existing page

| Page | Decision |
| --- | --- |
| `/` | Retained; updated to the documented release, three entry points added |
| `/guide/getting-started/`, `/guide/installation/` | Retained, corrected (Swift/libvips/Cairo baselines, `from: "2.0.0"`, `HokusaiPDF`) |
| `/guide/pipelines/` | Retained, corrected (`metadata()` is async, `MetadataPolicy`, no shutdown) |
| `/guide/transformations/` | Retained, corrected (`rotate(by:)`); will be split into operation pages (geometry guides) and redirected |
| `/guide/composition-and-pdf/` | Retained, corrected (`TextStyle`, `drawText(placement:)`, `.pdf(pageSize:)`); will be split into text, composition and PDF pages and redirected |
| `/examples/` | Retained as the Recipes entry; examples corrected |
| `/reference/api/` | Retained as the API reference entry; links the operation index |
| `/reference/cli/` | Rewritten around `hokusai run`; deprecated commands documented as such |
| `/reference/formats-and-compatibility/` | Retained, corrected (HEIF, TIFF, GIF, baselines) |
| `/vapor/overview/`, `/vapor/uploads-and-responses/` | Retained, rewritten for the 2.x response API |
| `/guide/migration/` | Retained, rewritten (`HokusaiLegacy` no longer exists; behavior changes within 2.x) |
| `/changelog/` | Retained, rewritten as a 2.x release summary that links the repository changelog |

Nothing was removed.
