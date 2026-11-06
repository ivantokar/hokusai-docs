#!/usr/bin/env node
// Checks the built site (run `npm run build` first): locale route mapping, document
// language, canonical and alternate links, sitemap entries, heading-id parity between the
// languages, and that every internal link and #anchor resolves.
import { readdirSync, readFileSync, existsSync } from "node:fs";
import { join, relative, dirname } from "node:path";

const DIST = "dist";
const SITE = (process.env.DOCS_SITE ?? "https://ivantokar.com").replace(/\/$/, "");
const BASE = (process.env.DOCS_BASE ?? "/oss/hokusai").replace(/\/$/, "");
const errors = [];
const fail = (message) => errors.push(message);

function htmlFiles(dir) {
  return readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) return entry.name === "pagefind" ? [] : htmlFiles(path);
    return entry.name.endsWith(".html") ? [path] : [];
  });
}

const route = (file) => {
  const rel = relative(DIST, file).replace(/index\.html$/, "").replace(/\.html$/, "");
  return `${BASE}/${rel}`;
};
const attr = (tag, name) => tag.match(new RegExp(`\\b${name}="([^"]*)"`))?.[1];
const ids = (html) => [...html.matchAll(/\sid="([^"]+)"/g)].map((m) => m[1]);
const headingIds = (html) =>
  [...html.matchAll(/<h[2-6][^>]*\sid="([^"]+)"/g)].map((m) => m[1]).filter((id) => !id.startsWith("starlight__"));

const files = htmlFiles(DIST).filter((f) => !f.endsWith("404.html"));
const pages = new Map(files.map((f) => [route(f), { file: f, html: readFileSync(f, "utf8") }]));
const isUk = (r) => r.startsWith(`${BASE}/uk/`);
const english = [...pages.keys()].filter((r) => !isUk(r));

for (const en of english) {
  const uk = `${BASE}/uk/${en.slice(BASE.length + 1)}`;
  const enPage = pages.get(en);
  const ukPage = pages.get(uk);
  if (!ukPage) {
    fail(`${en}: no Ukrainian page at ${uk}`);
    continue;
  }
  for (const [path, page, lang] of [[en, enPage, "en"], [uk, ukPage, "uk"]]) {
    const html = page.html;
    if (attr(html.match(/<html[^>]*>/)[0], "lang") !== lang) fail(`${path}: <html lang> is not "${lang}"`);
    const canonical = html.match(/<link[^>]*rel="canonical"[^>]*>/)?.[0];
    if (!canonical || attr(canonical, "href") !== `${SITE}${path}`) fail(`${path}: canonical should be ${SITE}${path}`);
    for (const [code, target] of [["en", en], ["uk", uk]]) {
      const alt = [...html.matchAll(/<link[^>]*rel="alternate"[^>]*>/g)].find((m) => attr(m[0], "hreflang") === code);
      if (!alt || attr(alt[0], "href") !== `${SITE}${target}`) fail(`${path}: missing hreflang="${code}" alternate → ${target}`);
    }
  }
  const a = headingIds(enPage.html);
  const b = headingIds(ukPage.html);
  if (a.join() !== b.join()) fail(`${en}: heading ids differ between languages\n  en: ${a.join(", ")}\n  uk: ${b.join(", ")}`);
}
for (const uk of [...pages.keys()].filter(isUk)) {
  if (!pages.has(`${BASE}/${uk.slice(BASE.length + 4)}`)) fail(`${uk}: no English page`);
}

const sitemap = readdirSync(DIST).filter((f) => /^sitemap-\d+\.xml$/.test(f)).map((f) => readFileSync(join(DIST, f), "utf8")).join("\n");
for (const path of pages.keys()) {
  if (!sitemap.includes(`<loc>${SITE}${path}</loc>`)) fail(`${path}: missing from the sitemap`);
}

let links = 0;
for (const [path, { html }] of pages) {
  for (const match of html.matchAll(/<a\s[^>]*href="([^"]+)"/g)) {
    const href = match[1].replace(/&amp;/g, "&");
    if (/^(https?:|mailto:|tel:|javascript:)/.test(href) && !href.startsWith(SITE + BASE)) continue;
    const url = new URL(href, `${SITE}${path}`);
    if (url.origin !== SITE) continue;
    links += 1;
    let target = url.pathname;
    if (!target.startsWith(`${BASE}/`) && target !== BASE) continue; // outside the docs (e.g. the main site)
    const page = pages.get(target.endsWith("/") ? target : `${target}/`) ?? pages.get(target);
    const asset = join(DIST, target.slice(BASE.length));
    if (!page && !(existsSync(asset) && !asset.endsWith("/"))) {
      fail(`${path}: broken link ${href}`);
      continue;
    }
    if (url.hash && page && !ids(page.html).includes(decodeURIComponent(url.hash.slice(1)))) {
      fail(`${path}: missing anchor ${href}`);
    }
  }
}

errors.forEach((e) => console.error(`error: ${e}`));
console.log(`${pages.size} pages, ${links} internal links checked; ${errors.length} errors`);
process.exit(errors.length ? 1 : 0);
