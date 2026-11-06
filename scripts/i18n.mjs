#!/usr/bin/env node
// Translation parity for the English (root) and Ukrainian (uk/) editions.
//
//   node scripts/i18n.mjs check [--release]   verify pairs, ids and translation freshness
//   node scripts/i18n.mjs stamp [path...]     record the current English source in uk pages
//
// A Ukrainian page records `translatedFrom`, a fingerprint of the English file it was
// written against. When the English page changes the fingerprints differ and `check` fails
// until the translation is updated and re-stamped (or the page is marked
// `translationStatus: draft`, which only `--release` rejects).
import { createHash } from "node:crypto";
import { readdirSync, readFileSync, writeFileSync, existsSync } from "node:fs";
import { join, relative } from "node:path";

const DOCS = "src/content/docs";
const UK = join(DOCS, "uk");

function pages(dir, skipUk) {
  const out = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) {
      if (skipUk && path === UK) continue;
      out.push(...pages(path, skipUk));
    } else if (/\.mdx?$/.test(entry.name)) out.push(path);
  }
  return out;
}

const normalise = (text) => text.replace(/\r\n/g, "\n").trim();
const fingerprint = (path) =>
  createHash("sha256").update(normalise(readFileSync(path, "utf8"))).digest("hex").slice(0, 12);

function field(path, name) {
  const match = readFileSync(path, "utf8").match(new RegExp(`^${name}:\\s*(.+)$`, "m"));
  return match ? match[1].trim().replace(/^['"]|['"]$/g, "") : undefined;
}

const [command, ...args] = process.argv.slice(2);
const english = pages(DOCS, true);
const rel = (path) => relative(DOCS, path);

if (command === "stamp") {
  const only = args.filter((a) => !a.startsWith("--"));
  for (const source of english) {
    const target = join(UK, rel(source));
    if (!existsSync(target)) continue;
    if (only.length && !only.some((p) => target.includes(p))) continue;
    let text = readFileSync(target, "utf8");
    const stamp = fingerprint(source);
    text = /^translatedFrom:/m.test(text)
      ? text.replace(/^translatedFrom:.*$/m, `translatedFrom: ${stamp}`)
      : text.replace(/^pageId:.*$/m, (line) => `${line}\ntranslatedFrom: ${stamp}`);
    writeFileSync(target, text);
    console.log(`stamped ${rel(target)} ← ${stamp}`);
  }
} else if (command === "check") {
  const release = args.includes("--release");
  const errors = [];
  const warnings = [];

  for (const source of english) {
    const name = rel(source);
    const target = join(UK, name);
    const id = field(source, "pageId");
    if (!id) errors.push(`${name}: missing pageId`);
    if (!existsSync(target)) {
      errors.push(`${name}: no Ukrainian page at uk/${name}`);
      continue;
    }
    if (field(target, "pageId") !== id) errors.push(`uk/${name}: pageId differs from English (${id})`);
    const draft = field(target, "translationStatus") === "draft";
    if (draft) (release ? errors : warnings).push(`uk/${name}: marked draft`);
    const recorded = field(target, "translatedFrom");
    if (recorded !== fingerprint(source)) {
      (draft && !release ? warnings : errors).push(
        `uk/${name}: ${recorded ? "English source changed since this translation" : "no translatedFrom"} — update it, then run \`npm run i18n:stamp\``,
      );
    }
  }
  for (const target of pages(UK, false)) {
    if (!existsSync(join(DOCS, relative(UK, target)))) errors.push(`${rel(target)}: no English counterpart`);
  }

  const ids = new Map();
  for (const source of english) {
    const id = field(source, "pageId");
    if (ids.has(id)) errors.push(`${rel(source)}: pageId ${id} also used by ${ids.get(id)}`);
    ids.set(id, rel(source));
  }

  warnings.forEach((w) => console.warn(`warning: ${w}`));
  errors.forEach((e) => console.error(`error: ${e}`));
  console.log(`${english.length} English pages checked; ${errors.length} errors, ${warnings.length} warnings`);
  process.exit(errors.length ? 1 : 0);
} else {
  console.error("usage: i18n.mjs check [--release] | stamp [path...]");
  process.exit(2);
}
