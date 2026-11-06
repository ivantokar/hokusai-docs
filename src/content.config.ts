import { defineCollection, z } from "astro:content";
import { docsLoader, i18nLoader } from "@astrojs/starlight/loaders";
import { docsSchema, i18nSchema } from "@astrojs/starlight/schema";

export const collections = {
  docs: defineCollection({
    loader: docsLoader(),
    schema: docsSchema({
      extend: z.object({
        // Stable page identity, identical in every language and independent of the title.
        pageId: z.string(),
        // Ukrainian pages only: fingerprint of the English source this translation was
        // written against. `npm run i18n:check` flags pages whose source has changed.
        translatedFrom: z.string().optional(),
        // `draft` marks an incomplete translation; it is rejected by `i18n:check --release`.
        translationStatus: z.enum(["draft"]).optional(),
      }),
    }),
  }),
  i18n: defineCollection({
    loader: i18nLoader(),
    schema: i18nSchema({
      extend: z.object({
        "hokusai.documentation": z.string().optional(),
        "hokusai.mainSite": z.string().optional(),
        "hokusai.language": z.string().optional(),
        "hokusai.switchToLight": z.string().optional(),
        "hokusai.switchToDark": z.string().optional(),
      }),
    }),
  }),
};
