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
          label: "Getting Started",
          translations: { uk: "Початок роботи" },
          items: ["guide/getting-started", "guide/installation"],
        },
        {
          label: "Core Concepts",
          translations: { uk: "Основні поняття" },
          collapsed: true,
          items: ["core-concepts", "guide/pipelines"],
        },
        {
          label: "Sources & Input",
          translations: { uk: "Джерела та вхідні дані" },
          collapsed: true,
          items: ["sources-input"],
        },
        {
          label: "Geometry",
          translations: { uk: "Геометрія" },
          collapsed: true,
          items: ["geometry", "guide/transformations"],
        },
        {
          label: "Effects & Color",
          translations: { uk: "Ефекти та колір" },
          collapsed: true,
          items: ["effects-color"],
        },
        {
          label: "Channels & Transparency",
          translations: { uk: "Канали та прозорість" },
          collapsed: true,
          items: ["channels-transparency"],
        },
        {
          label: "Text & Composition",
          translations: { uk: "Текст і композиція" },
          collapsed: true,
          items: ["text-composition", "guide/composition-and-pdf"],
        },
        {
          label: "Encoding & Output",
          translations: { uk: "Кодування та вивід" },
          collapsed: true,
          items: ["encoding-output", "reference/formats-and-compatibility"],
        },
        {
          label: "Inspection",
          translations: { uk: "Перевірка зображень" },
          collapsed: true,
          items: ["inspection"],
        },
        {
          label: "PDF",
          translations: { uk: "PDF" },
          collapsed: true,
          items: ["pdf"],
        },
        {
          label: "Recipes",
          translations: { uk: "Рецепти" },
          collapsed: true,
          items: ["examples"],
        },
        {
          label: "Integrations",
          translations: { uk: "Інтеграції" },
          collapsed: true,
          items: ["integrations", "vapor/overview", "vapor/uploads-and-responses"],
        },
        {
          label: "Runtime & Performance",
          translations: { uk: "Середовище та продуктивність" },
          collapsed: true,
          items: ["runtime-performance"],
        },
        {
          label: "CLI",
          translations: { uk: "CLI" },
          collapsed: true,
          items: ["reference/cli"],
        },
        {
          label: "API Reference",
          translations: { uk: "Довідник API" },
          collapsed: true,
          items: ["reference/api", "reference/operations"],
        },
        {
          label: "Troubleshooting & Migration",
          translations: { uk: "Усунення проблем і міграція" },
          collapsed: true,
          items: ["troubleshooting-migration", "guide/migration", "changelog"],
        },
      ],
    }),
  ],
});
