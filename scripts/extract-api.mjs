#!/usr/bin/env node
// Lists the public declarations of released Swift sources, so coverage is measured against
// the released API and not against README checklists.
//
//   node scripts/extract-api.mjs <output.json> <repo>@<tag>=<source-dir>:<Module>[,<Module>...] ...
//
// Example:
//   node scripts/extract-api.mjs inventory/public-api.json \
//     hokusai@v2.2.2=/path/to/hokusai/Sources:Hokusai,HokusaiNIO,HokusaiPDF
//
// It is a line-oriented scanner, not a compiler: it tracks brace depth, skips comments and
// strings, and records `public`/`open` declarations plus the cases of public enums.
// Members inherit visibility from nothing: only a declaration spelled `public` counts.
import { readdirSync, readFileSync, writeFileSync, statSync } from "node:fs";
import { join } from "node:path";

const [, , output, ...specs] = process.argv;
if (!output || specs.length === 0) {
  console.error("usage: extract-api.mjs <output.json> <repo>@<tag>=<dir>:<Module,...> ...");
  process.exit(2);
}

function swiftFiles(dir) {
  return readdirSync(dir).flatMap((name) => {
    const path = join(dir, name);
    if (statSync(path).isDirectory()) return name.endsWith(".docc") ? [] : swiftFiles(path);
    return name.endsWith(".swift") ? [path] : [];
  });
}

// Blank out comments and string contents but keep line structure.
function clean(source) {
  let out = "";
  for (let i = 0; i < source.length; ) {
    const two = source.slice(i, i + 2);
    if (two === "//") {
      while (i < source.length && source[i] !== "\n") i++;
    } else if (two === "/*") {
      let depth = 1;
      i += 2;
      while (i < source.length && depth > 0) {
        if (source.startsWith("/*", i)) { depth++; i += 2; }
        else if (source.startsWith("*/", i)) { depth--; i += 2; }
        else { if (source[i] === "\n") out += "\n"; i++; }
      }
    } else if (source.startsWith('"""', i)) {
      i += 3;
      while (i < source.length && !source.startsWith('"""', i)) { if (source[i] === "\n") out += "\n"; i++; }
      i += 3;
      out += '""';
    } else if (source[i] === '"') {
      i++;
      while (i < source.length && source[i] !== '"' && source[i] !== "\n") { if (source[i] === "\\") i++; i++; }
      i++;
      out += '""';
    } else out += source[i++];
  }
  return out;
}

const TYPE = /^(?:(?:public|open|final|indirect|internal|private|fileprivate|package)\s+)*(struct|enum|class|actor|protocol|extension|typealias)\s+([A-Za-z_][\w.]*)/;
const MODIFIERS = /^((?:@\w+(?:\([^)]*\))?\s+)*)((?:(?:public|open|internal|private|fileprivate|package|static|class|final|mutating|nonisolated|override|convenience|required|indirect|lazy|weak|unowned)\s+)*)(init\??|func|var|let|subscript|case|typealias|associatedtype)\b\s*(.*)$/;

function labels(signature) {
  let angle = 0, start = -1;
  for (let i = 0; i < signature.length; i++) {
    if (signature[i] === "<") angle++;
    else if (signature[i] === ">" && signature[i - 1] !== "-") angle--;
    else if (signature[i] === "(" && angle === 0) { start = i; break; }
  }
  if (start < 0) return "";
  let depth = 0, current = "";
  const parts = [];
  for (let i = start; i < signature.length; i++) {
    const c = signature[i];
    if (c === "(" || c === "[" || c === "<") depth++;
    if (c === ")" || c === "]" || (c === ">" && signature[i - 1] !== "-")) { depth--; if (depth === 0) break; }
    if (depth === 1 && c === "," ) { parts.push(current); current = ""; continue; }
    if (i > start) current += c;
  }
  if (current.trim()) parts.push(current);
  return parts.map((p) => p.trim().split(/\s*:/)[0].trim().split(/\s+/)[0] || "_").join(":") + (parts.length ? ":" : "");
}

function scan(file, repo, module) {
  const lines = clean(readFileSync(file, "utf8")).split("\n");
  const symbols = [];
  const stack = []; // {name, kind, isPublic, depth, enumNode}
  let depth = 0;
  let pending = ""; // multi-line declaration being accumulated
  let pendingStart = 0;

  const flush = (text, lineNo) => {
    const decl = text.replace(/\s+/g, " ").trim();
    const owner = stack[stack.length - 1];
    const typeMatch = TYPE.exec(decl.replace(/^(@\w+(\([^)]*\))?\s+)*/, ""));
    const hasPublic = /(^|\s)(public|open)\s/.test(decl.split(/\b(func|init|var|let|struct|enum|class|actor|protocol|extension|case|subscript|typealias)\b/)[0] + " ");
    if (typeMatch) {
      const [, kind, rawName] = typeMatch;
      const name = rawName;
      const isPublic = kind === "extension" ? hasPublic : hasPublic;
      const qualified = owner && owner.isPublic && kind !== "extension" ? `${owner.name}.${name}` : name;
      stack.push({ name: kind === "extension" ? name : qualified, kind, isPublic: isPublic || (kind === "extension" && hasPublic), depth: depth + 1, node: null });
      if (isPublic && kind !== "extension") {
        const entry = { module, repo, kind, name: qualified, file, line: lineNo, signature: decl.replace(/\s*\{.*$/, "") };
        if (kind === "enum") entry.cases = [];
        symbols.push(entry);
        stack[stack.length - 1].node = entry;
      }
      return true;
    }
    const m = MODIFIERS.exec(decl);
    if (!m) return false;
    const [, , mods, keyword, rest] = m;
    if (!owner || depth !== owner.depth) return false; // not directly inside the type (e.g. a local)
    const explicitPublic = /\b(public|open)\b/.test(mods);
    if (keyword === "case") {
      if (owner.node && owner.kind === "enum" && !/\b(private|fileprivate|internal)\b/.test(mods)) {
        for (const item of rest.split(/,(?![^(]*\))/)) {
          const name = item.trim().replace(/\s*=.*$/, "");
          if (name) owner.node.cases.push(name.replace(/\s*\{.*$/, ""));
        }
      }
      return false;
    }
    // Members of a `public extension` (and of a public protocol) are public without repeating the keyword.
    const inherits = owner.kind === "extension" || owner.kind === "protocol";
    const ownerPublic = owner.isPublic || (owner.kind === "extension" && explicitPublic);
    if (!(explicitPublic || inherits) || !ownerPublic) return false;
    if (/\b(private|fileprivate|internal|package)\b/.test(mods)) return false;
    const base = keyword.startsWith("init") ? "init" : (/^[A-Za-z_]\w*/.exec(rest) ?? [""])[0];
    const signature = decl.replace(/\s*\{.*$/, "").replace(/\s*=\s.*$/, "");
    const isCallable = keyword === "func" || keyword.startsWith("init") || keyword === "subscript";
    symbols.push({
      module, repo,
      kind: keyword.startsWith("init") ? "init" : keyword,
      static: /\bstatic\b/.test(mods) || undefined,
      name: `${owner.name}.${base}${isCallable ? `(${labels(rest)})` : ""}`,
      file, line: lineNo, signature,
    });
    return true;
  };

  lines.forEach((raw, index) => {
    const line = raw.trim();
    const open = (raw.match(/\{/g) ?? []).length;
    const close = (raw.match(/\}/g) ?? []).length;

    if (pending || (line && !line.startsWith("}") && /^(@\w+(\([^)]*\))?\s+)*(public|open|internal|private|fileprivate|package|static|final|struct|enum|class|actor|protocol|extension|func|init|var|let|case|subscript|typealias|indirect|mutating|nonisolated|convenience)\b/.test(line))) {
      const atTopOfScope = !pending;
      if (atTopOfScope) pendingStart = index + 1;
      pending += " " + line;
      const parenBalance = (pending.match(/\(/g) ?? []).length - (pending.match(/\)/g) ?? []).length;
      const complete = parenBalance <= 0 && (/[{]\s*$/.test(line) || !/[,(]\s*$/.test(line));
      if (complete) {
        const text = pending;
        pending = "";
        // Declarations of computed properties / bodies on the same line count their braces below.
        const wasType = flush(text, pendingStart);
        const typePushed = wasType && TYPE.test(text.trim().replace(/^(@\w+(\([^)]*\))?\s+)*/, ""));
        depth += open - close;
        if (typePushed && open === 0) stack[stack.length - 1].depth = depth + 1; // brace on a later line
        while (stack.length && depth < stack[stack.length - 1].depth - 0 && depth <= stack[stack.length - 1].depth - 1) stack.pop();
        return;
      }
      return;
    }
    depth += open - close;
    while (stack.length && depth < stack[stack.length - 1].depth) stack.pop();
  });
  return symbols;
}

const result = { generatedBy: "scripts/extract-api.mjs", sources: [], symbols: [] };
for (const spec of specs) {
  const match = /^([^@]+)@([^=]+)=(.+):([\w,]+)$/.exec(spec);
  if (!match) { console.error(`bad spec: ${spec}`); process.exit(2); }
  const [, repo, tag, dir, modules] = match;
  result.sources.push({ repo, tag, modules: modules.split(",") });
  for (const module of modules.split(",")) {
    const root = join(dir, module);
    for (const file of swiftFiles(root)) {
      for (const symbol of scan(file, repo, module)) {
        symbol.file = `${repo}/Sources/${module}/${file.slice(root.length + 1)}`;
        result.symbols.push(symbol);
      }
    }
  }
}

const seen = new Map();
for (const s of result.symbols) {
  const key = `${s.module}:${s.name}`;
  const n = (seen.get(key) ?? 0) + 1;
  seen.set(key, n);
  s.id = n === 1 ? key : `${key}#${n}`;
}
result.symbols.sort((a, b) => a.id.localeCompare(b.id));
writeFileSync(output, JSON.stringify(result, null, 2) + "\n");
console.log(`${result.symbols.length} public symbols from ${specs.length} source set(s) → ${output}`);
