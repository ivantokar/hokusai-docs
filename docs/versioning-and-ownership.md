# Versions and source ownership

## Documented version

The site documents released versions, never `main`. They are recorded in two places that must agree (`npm run coverage:check` enforces it):

- `src/versions.json` — shown in the header and on the home page.
- `inventory/coverage.json` → `target` — the versions `inventory/public-api.json` was extracted from.

Currently: Hokusai 2.2.2, Hokusai Vapor 2.1.0, Hokusai Hummingbird 2.1.0.

### Advancing the version

1. Check out the new release tags of the library repositories.
2. Regenerate the inventory (see `inventory/README.md`) and run `npm run coverage:check`. New public symbols appear as unmapped; map them to a family and document them.
3. Update `src/versions.json` and `coverage.json` → `target`, `package` dependency versions in examples, the changelog page, and both languages.
4. Run `npm run check`.

Dependencies shown in examples (`from: "2.0.0"`) state the lowest version that has the API the page uses; they advance only when an example needs newer API.

Unreleased material (main, future work such as moving PDF into `HokusaiPDF` in 3.0) is kept out of stable pages. It is listed under "Future library work" in `inventory/COVERAGE.md` and may be described only on pages that say plainly that it is not released. There is no archive of older site versions unless a concrete need appears.

## Who owns what

| Concern | Owner |
| --- | --- |
| Exact signatures, parameter ranges, defaults, thrown errors | Source comments / DocC in the library repositories |
| Teaching, behavior in context, comparisons, troubleshooting, recipes | This site |
| Code in pages and generated output images | Executable Swift examples run by Hokusai (verification and visuals are added in the examples work) |
| Which public symbol is documented where | `inventory/` |

The site does not copy signatures or defaults by hand. A page names an operation and links to the symbol; where a number matters (a default, a bound), it is stated once on that operation's page and checked against the target version. A claim that cannot be derived from the source comments is checked against the source before it is written.

## Operation page template

Every operation page follows this order:

1. **Problem / use case** — what you reach for it to do.
2. **Minimal working example** — the shortest code that runs.
3. **Parameter table** — types, units, defaults, bounds.
4. **Visual variants** — outputs produced by Hokusai from a licensed fixture, never illustrations.
5. **Detailed semantics** — what exactly happens, including edge cases.
6. **Combinations and order** — how it interacts with neighboring operations.
7. **Errors and capability constraints** — what throws, and what depends on the libvips build.
8. **Related** — reference symbols, interaction guides and recipes.

Both languages carry every section; code, fixtures and images are shared.
