#!/usr/bin/env node
// Compares two example manifests (committed vs freshly generated), ignoring what legitimately varies
// between native stacks (byte sizes, libvips version). A different set of examples, files, formats or
// dimensions means an example no longer produces what the documentation shows.
//   node scripts/check-manifest.mjs <committed.json> <regenerated.json>
import { readFileSync } from "node:fs";

const [a, b] = process.argv.slice(2).map((p) => JSON.parse(readFileSync(p, "utf8")));
const simplify = (m) =>
  Object.fromEntries(
    Object.entries(m.examples).map(([id, files]) => [id, files.map(({ file, format, width, height }) => `${file} ${format} ${width}x${height}`)]),
  );
const left = simplify(a), right = simplify(b);
const errors = [];
for (const id of new Set([...Object.keys(left), ...Object.keys(right)])) {
  if (!left[id]) errors.push(`${id}: new example, commit its output (npm run examples)`);
  else if (!right[id]) errors.push(`${id}: no longer produced`);
  else if (JSON.stringify(left[id]) !== JSON.stringify(right[id])) {
    errors.push(`${id}: output changed\n  committed:   ${left[id].join(", ")}\n  regenerated: ${right[id].join(", ")}`);
  }
}
errors.forEach((e) => console.error(`error: ${e}`));
console.log(`${Object.keys(right).length} examples compared; ${errors.length} differences`);
process.exit(errors.length ? 1 : 0);
