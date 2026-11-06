# Ukrainian terminology glossary

Use these terms consistently in `src/content/docs/uk/`. Public API names, identifiers, commands, paths, option names and code stay exactly as in English and are never translated (`resize`, `fit: .cover`, `hokusai info`, `Package.swift`). Add a term here the first time a page needs a new one.

| English | Ukrainian | Note |
| --- | --- | --- |
| pipeline | конвеєр | `Hokusai` value; "конвеєр обробки" only when clarity needs it |
| recipe | рецепт | the not-yet-evaluated pipeline |
| immutable | незмінний | |
| terminal (operation) | завершальна операція | `data()`, `write(to:)` |
| evaluate / evaluation | виконати / виконання | not "обчислити" |
| branch (a pipeline) | розгалужувати | |
| encoder | кодувальник | |
| output / input | вивід / вхід, вхідні дані | |
| upload | завантаження | a file sent to the server |
| thumbnail | мініатюра | |
| watermark | водяний знак | |
| composite / layer | накладання (композит) / шар | `CompositeLayer` stays as code |
| resize, crop | зміна розміру, обрізання | |
| metadata | метадані | |
| cooperative executor | кооперативний виконавець | Swift concurrency |
| runtime | середовище виконання | |
| fit, position, kernel | режим вписування, позиція, ядро | option names stay in code |
| quality, effort, lossless | якість, зусилля, без втрат | |
| changelog | журнал змін | |

Style: address the reader in the plural polite form ("установіть", "додайте"); prefer natural Ukrainian over calques; keep sentences close to the English structure so a change in one is easy to mirror in the other.
