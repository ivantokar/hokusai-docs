// Lets translated headings keep the English anchor: `## Встановлення {#install}`.
// The trailing `{#id}` is removed from the text and becomes the heading's id, so an
// anchor means the same thing in every language and the language switch can keep it.
// Sätteri hast plugin; Astro's own heading-id step keeps an id that is already set.
// Smart punctuation turns `--` inside the braces into an en dash; undo that for ids.
const CUSTOM_ID = /\s*\{#([A-Za-z0-9_\u2013\u2014-]+)\}\s*$/;
const plainId = (id) => id.replace(/\u2014/g, "---").replace(/\u2013/g, "--");

export default {
  name: "custom-heading-ids",
  element: {
    filter: ["h1", "h2", "h3", "h4", "h5", "h6"],
    visit(node, ctx) {
      const last = node.children?.[node.children.length - 1];
      if (last?.type !== "text") return;
      const match = CUSTOM_ID.exec(last.value);
      if (!match) return;
      ctx.setProperty(node, "id", plainId(match[1]));
      ctx.setField(last, "value", last.value.replace(CUSTOM_ID, ""));
    },
  },
};
