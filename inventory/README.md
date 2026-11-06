# Inventory

The committed record of what Hokusai publicly offers and where it is documented.

| File | What it is |
| --- | --- |
| `public-api.json` | Public declarations of the documented releases, extracted from source by `scripts/extract-api.mjs` |
| `coverage.json` | Maps every symbol to a documentation family, with docs/example/visual status, the CLI commands, native restrictions and future work |
| `COVERAGE.md` | The generated coverage matrix (`npm run coverage:report`); do not edit |
| `legacy-urls.json` | URLs that must keep resolving |

`npm run coverage:check` fails when a public symbol is unmapped, a mapping matches nothing, a page named in a family does not exist in both languages, the matrix is stale, or the operation index misses a method.

## Regenerating `public-api.json`

Check out the release tags, then point the extractor at each `Sources` directory:

```sh
git -C hokusai archive v2.2.2 | tar -x -C /tmp/hokusai-2.2.2
node scripts/extract-api.mjs inventory/public-api.json \
  hokusai@v2.2.2=/tmp/hokusai-2.2.2/Sources:Hokusai,HokusaiNIO,HokusaiPDF \
  hokusai-vapor@v2.1.0=/tmp/hokusai-vapor-2.1.0/Sources:HokusaiVapor \
  hokusai-hummingbird@v2.1.0=/tmp/hokusai-hummingbird-2.1.0/Sources:HokusaiHummingbird
npm run coverage:report
```

The extractor is a line-oriented scanner (comments and strings skipped, brace depth tracked), not a compiler. Its count was checked against `grep` for explicit `public` declarations. The CLI command list in `coverage.json` is maintained by hand from `Sources/HokusaiCommandLine`.
