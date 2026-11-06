# hokusai-docs

Documentation for [Hokusai](https://github.com/ivantokar/hokusai), built with [Astro Starlight](https://starlight.astro.build). Published at <https://ivantokar.com/oss/hokusai/>.

## Local development

Prerequisites: Node.js 22+ and npm. Nothing else (no private site, workspace packages or credentials) is required.

```sh
git clone https://github.com/ivantokar/hokusai-docs.git
cd hokusai-docs
npm install
npm run dev
```

Open <http://localhost:4321/oss/hokusai/>.

## Build and preview

```sh
npm run build     # outputs to dist/
npm run preview   # serves the build at http://localhost:4321/oss/hokusai/
```

## Configuration (all optional)

| Variable | Default | Purpose |
| --- | --- | --- |
| `DOCS_SITE` | `https://ivantokar.com` | Canonical site origin |
| `DOCS_BASE` | `/oss/hokusai` | Base path |
| `PUBLIC_GTM_ID` | unset | Google Tag Manager ID; no analytics is injected when unset |

## Publication

The private website mounts this repository as a Git submodule at `apps/hokusai-docs` and builds the **pinned** commit. To publish a change:

1. Merge the documentation change here.
2. In the website repository, update the submodule pointer (`git -C apps/hokusai-docs pull && git add apps/hokusai-docs`), commit and deploy.

## Layout

- `src/content/docs/` – pages
- `src/theme/` – documentation-owned theme (header, theme toggle, CSS, code theme)
- `public/` – static assets

## License

Code: MIT (see `LICENSE`). The Hokusai name and logo images in `public/` are the project's branding and not covered by the MIT grant.
