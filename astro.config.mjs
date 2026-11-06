import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import { satteri } from "@astrojs/markdown-satteri";
import headingIds from "./plugins/heading-ids.mjs";
import { expressiveCodeTheme } from "./src/theme/expressive-code.ts";
import { googleTagManagerScript } from "./src/theme/gtm.ts";

// Analytics is optional: only injected when PUBLIC_GTM_ID is set at build time.
const head = googleTagManagerScript
  ? [{ tag: "script", content: googleTagManagerScript }]
  : [];

export default defineConfig({
  markdown: { processor: satteri({ hastPlugins: [headingIds] }) },
  site: process.env.DOCS_SITE ?? "https://ivantokar.com",
  base: process.env.DOCS_BASE ?? "/oss/hokusai",
  integrations: [
    starlight({
      title: "Hokusai",
      description: "High-performance Swift image processing powered by libvips.",
      head,
      // English stays at the existing URLs; Ukrainian lives under /uk/.
      defaultLocale: "root",
      locales: {
        root: { label: "English", lang: "en" },
        uk: { label: "Українська", lang: "uk" },
      },
      expressiveCode: expressiveCodeTheme,
      customCss: ["./src/theme/starlight.css"],
      components: {
        Header: "./src/theme/DocsHeader.astro",
        LanguageSelect: "./src/theme/LanguageSelect.astro",
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
          translations: { uk: "Вступ" },
          items: [
            "guide/getting-started",
            "guide/installation",
            "guide/migration",
          ],
        },
        {
          label: "Core Library",
          translations: { uk: "Основна бібліотека" },
          items: [
            "guide/pipelines",
            "guide/transformations",
            "guide/composition-and-pdf",
          ],
        },
        {
          label: "Vapor Integration",
          translations: { uk: "Інтеграція з Vapor" },
          items: ["vapor/overview", "vapor/uploads-and-responses"],
        },
        {
          label: "API",
          translations: { uk: "API" },
          items: [
            "reference/api",
            "reference/cli",
            "reference/formats-and-compatibility",
          ],
        },
        {
          label: "Resources",
          translations: { uk: "Ресурси" },
          items: ["examples", "changelog"],
        },
      ],
    }),
  ],
});
