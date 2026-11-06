# Contributing

## Local setup

```sh
npm install
npm run dev      # http://localhost:4321/oss/hokusai/ (English) and /oss/hokusai/uk/ (Ukrainian)
```

`npm run check` runs everything CI runs: translation parity, the production build, and checks of the built site.

## Languages

English (root, `src/content/docs/`) and Ukrainian (`src/content/docs/uk/`) are both part of every release. A page exists in both languages, at the same relative path, with the same `pageId`.

- Routes: English stays at `/oss/hokusai/…`; Ukrainian is at `/oss/hokusai/uk/…`. The language switch keeps the current page and `#anchor`; nothing redirects by browser language or IP.
- Terminology: see [docs/glossary.md](docs/glossary.md). Code, API names, commands and paths are never translated.
- Shared material (code samples, fixtures, generated images) is reused by both editions; translate prose, tables, labels, captions and alt text only.

### Add a page

1. Create the English page with `pageId` (stable, language-independent, e.g. `guide.resize`) and add it to the sidebar in `astro.config.mjs`.
2. Create `uk/<same path>` with the same `pageId` and a translated `title`/`description`.
3. Give every Ukrainian heading the English anchor so links and the language switch keep working:
   `## Встановлення пакета {#install-the-package}`. (In `.mdx`, write `\{#id}`.) The English anchor is the heading text slugified: lowercase, punctuation removed, spaces to hyphens.
4. Link to the Ukrainian version of other pages (`/oss/hokusai/uk/...`), not the English one.
5. Run `npm run i18n:stamp` to record which English revision the translation matches.

### Change a page

Edit the English page, then update the Ukrainian page and run `npm run i18n:stamp`. `npm run i18n:check` fails while a translation's recorded revision (`translatedFrom`) differs from the English file, so a change can't be forgotten. For a work-in-progress translation add `translationStatus: draft` to the Ukrainian page: it only warns during development, and `npm run i18n:check -- --release` rejects it.

### What CI checks

`i18n:check` (every English page has a Ukrainian pair with a matching `pageId` and a current `translatedFrom`) and `check:dist` after the build: both languages exist for every route, `<html lang>`, canonical and `hreflang` alternates, sitemap entries, identical heading anchors in both languages, and that every internal link and anchor resolves.

## Pull requests

`main` is protected: open a pull request, keep history linear (squash merge) and wait for `CI complete`.
