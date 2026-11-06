import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import { expressiveCodeTheme } from "./src/theme/expressive-code.ts";
import { googleTagManagerScript } from "./src/theme/gtm.ts";

// Analytics is optional: only injected when PUBLIC_GTM_ID is set at build time.
const head = googleTagManagerScript
  ? [{ tag: "script", content: googleTagManagerScript }]
  : [];

export default defineConfig({
  site: process.env.DOCS_SITE ?? "https://ivantokar.com",
  base: process.env.DOCS_BASE ?? "/oss/hokusai",
  integrations: [
    starlight({
      title: "Hokusai",
      description: "High-performance Swift image processing powered by libvips.",
      head,
      expressiveCode: expressiveCodeTheme,
      customCss: ["./src/theme/starlight.css"],
      components: {
        Header: "./src/theme/DocsHeader.astro",
        SkipLink: "./src/theme/DocsSkipLink.astro",
        ThemeProvider: "./src/theme/ThemeProvider.astro",
        ThemeSelect: "./src/theme/ThemeToggle.astro",
      },
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/ivantokar/hokusai",
        },
      ],
      sidebar: [
        { slug: "index" },
        {
          label: "Introduction",
          items: [
            "guide/getting-started",
            "guide/installation",
            "guide/migration",
          ],
        },
        {
          label: "Core Library",
          items: [
            "guide/pipelines",
            "guide/transformations",
            "guide/composition-and-pdf",
          ],
        },
        {
          label: "Vapor Integration",
          items: ["vapor/overview", "vapor/uploads-and-responses"],
        },
        {
          label: "API",
          items: [
            "reference/api",
            "reference/cli",
            "reference/formats-and-compatibility",
          ],
        },
        {
          label: "Resources",
          items: ["examples", "changelog"],
        },
      ],
    }),
  ],
});
