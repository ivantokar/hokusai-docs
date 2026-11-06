#!/usr/bin/env node
// Collects the code shown on the site from the executable examples:
// every `// snippet: <id>` … `// endsnippet` block in examples/Sources becomes snippets.json.
//   node scripts/extract-snippets.mjs          write src/generated/snippets.json
//   node scripts/extract-snippets.mjs --check  fail if the file is stale
import { readdirSync, readFileSync, writeFileSync, existsSync } from "node:fs";
import { join } from "node:path";

// Executable examples, plus the integration packages that are compiled (not run) in CI.
const ROOTS = ["examples/Sources/DocsExamples/Examples", "examples/integrations/vapor-app/Sources/App", "examples/integrations/hummingbird-app/Sources/App"];
const OUTPUT = "src/generated/snippets.json";
const snippets = {};
const errors = [];

const files = ROOTS.flatMap((root) => (existsSync(root) ? readdirSync(root).filter((f) => f.endsWith(".swift")).sort().map((f) => join(root, f)) : []));
for (const file of files) {
  const lines = readFileSync(file, "utf8").split("\n");
  let id = null, buffer = [];
  for (const line of lines) {
    const start = line.match(/^\s*\/\/ snippet: (\S+)\s*$/);
    if (start) { id = start[1]; buffer = []; continue; }
    if (/^\s*\/\/ endsnippet\s*$/.test(line)) {
      if (!id) { errors.push(`${file}: endsnippet without start`); continue; }
      if (snippets[id]) errors.push(`${file}: duplicate snippet ${id}`);
      const indent = Math.min(...buffer.filter((l) => l.trim()).map((l) => l.match(/^ */)[0].length));
      snippets[id] = buffer.map((l) => l.slice(indent)).join("\n").replace(/\s+$/, "") + "\n";
      id = null;
      continue;
    }
    if (id) buffer.push(line);
  }
  if (id) errors.push(`${file}: snippet ${id} is not closed`);
}

const text = JSON.stringify(Object.fromEntries(Object.entries(snippets).sort()), null, 2) + "\n";
if (process.argv.includes("--check")) {
  if (!existsSync(OUTPUT) || readFileSync(OUTPUT, "utf8") !== text) errors.push(`${OUTPUT} is stale — run npm run examples:snippets`);
} else {
  writeFileSync(OUTPUT, text);
  console.log(`${Object.keys(snippets).length} snippets → ${OUTPUT}`);
}
errors.forEach((e) => console.error(`error: ${e}`));
process.exit(errors.length ? 1 : 0);
