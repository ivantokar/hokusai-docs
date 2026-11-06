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
          items: ["core-concepts", "core-concepts/evaluation", "guide/pipelines", { label: "Order of operations", translations: { uk: "Порядок операцій" }, collapsed: true, items: ["interactions", "interactions/resize-blur-sharpen", "interactions/orientation-and-resize", "interactions/flatten-before-jpeg", "interactions/trim-and-extend", "interactions/composite-order", "interactions/encoder-position"] }],
        },
        {
          label: "Sources & Input",
          translations: { uk: "Джерела та вхідні дані" },
          collapsed: true,
          items: ["sources-input", "sources-input/input-options", "sources-input/raw-pixels", "sources-input/uploads"],
        },
        {
          label: "Geometry",
          translations: { uk: "Геометрія" },
          collapsed: true,
          items: ["geometry", "geometry/resize", "geometry/crop-and-canvas", "geometry/rotate-flip-affine", "guide/transformations"],
        },
        {
          label: "Effects & Color",
          translations: { uk: "Ефекти та колір" },
          collapsed: true,
          items: ["effects-color", "effects-color/blur-sharpen", "effects-color/tone-and-color", "effects-color/filters"],
        },
        {
          label: "Channels & Transparency",
          translations: { uk: "Канали та прозорість" },
          collapsed: true,
          items: ["channels-transparency", "channels-transparency/alpha-and-channels"],
        },
        {
          label: "Text & Composition",
          translations: { uk: "Текст і композиція" },
          collapsed: true,
          items: ["text-composition", "text-composition/text", "text-composition/composite", "guide/composition-and-pdf"],
        },
        {
          label: "Encoding & Output",
          translations: { uk: "Кодування та вивід" },
          collapsed: true,
          items: ["encoding-output", "encoding-output/formats", "encoding-output/terminals", "encoding-output/metadata", "reference/formats-and-compatibility"],
        },
        {
          label: "Inspection",
          translations: { uk: "Перевірка зображень" },
          collapsed: true,
          items: ["inspection", "inspection/metadata"],
        },
        {
          label: "PDF",
          translations: { uk: "PDF" },
          collapsed: true,
          items: ["pdf", "pdf/raster", "pdf/vector"],
        },
        {
          label: "Recipes",
          translations: { uk: "Рецепти" },
          collapsed: true,
          items: ["recipes", "recipes/social-card", "recipes/thumbnails", "recipes/watermark", "recipes/avatar", "recipes/contact-sheet", "recipes/pdf-report", "recipes/upload-normalisation", "examples"],
        },
        {
          label: "Integrations",
          translations: { uk: "Інтеграції" },
          collapsed: true,
          items: ["integrations", "vapor/overview", "vapor/uploads-and-responses", "integrations/vapor-service", "integrations/hummingbird", "integrations/macos", "integrations/docker"],
        },
        {
          label: "Runtime & Performance",
          translations: { uk: "Середовище та продуктивність" },
          collapsed: true,
          items: ["runtime-performance", "runtime-performance/runtime", "runtime-performance/performance"],
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
          items: ["troubleshooting-migration", "troubleshooting-migration/troubleshooting", "guide/migration", "changelog"],
        },
      ],
    }),
  ],
});
