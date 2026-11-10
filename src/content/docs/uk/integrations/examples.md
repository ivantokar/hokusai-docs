---
pageId: integrations.examples
translatedFrom: "98eb3792ed25"
title: Приклади
description: Запустіть демо на Vapor або Hummingbird, спробуйте пісочницю для macOS, протестуйте їх і перенесіть код у власний застосунок.
---

[hokusai-examples](https://github.com/ivantokar/hokusai-examples) — репозиторій виконуваних демо. Ви відкриваєте зображення, збираєте впорядкований конвеєр, бачите результат і копіюєте Swift-код, що його відтворює. Це найшвидший спосіб побачити, що робить Hokusai і як поводяться адаптери для Vapor і Hummingbird. Документація від нього не залежить: кожен фрагмент на цьому сайті виконує власний репозиторій сайту.

## Що всередині {#contents}

| Тека | Що це |
| --- | --- |
| `vapor-server/` | Вебпісочниця, яку віддає бекенд на Vapor ([Hokusai Vapor](/oss/hokusai/uk/vapor/overview)) |
| `hummingbird-server/` | Та сама пісочниця з бекендом на Hummingbird ([Hokusai Hummingbird](/oss/hokusai/uk/integrations/hummingbird)) |
| `macos/` | Нативна пісочниця на SwiftUI: офлайн, без сервера |
| `recipes/` | Спільний код: каталог операцій, модель рецепта, генератор Swift, обмежене сховище завантажень |
| `web/`, `fixtures/` | Єдиний вебінтерфейс, який віддають обидва бекенди, і згенеровані зразки зображень |

Обидва бекенди віддають **ту саму** вебсторінку й відповідають на **той самий** HTTP API. Запускайте той, що відповідає вашому фреймворку; верхня панель показує, який саме відповів.

## Запуск у Docker {#docker}

Образ збирає libvips 8.16 з вихідного коду (Ubuntu 24.04 постачається з 8.15), тож перша збірка триває кілька хвилин. Більше нічого встановлювати не треба.

```sh
git clone https://github.com/ivantokar/hokusai-examples
cd hokusai-examples
docker compose up vapor          # http://localhost:8081
docker compose up hummingbird    # http://localhost:8082
```

Обидва можна запустити разом: вони публікують різні порти. Питайте у запущеного сервера, що він вміє, замість припущень: `curl localhost:8081/api/capabilities` показує версії libvips і Cairo та формати, які це середовище читає й записує.

## Нативний запуск {#native}

Потрібні **Swift 6.2 або новіший** і **libvips 8.16 або новіша**. На macOS:

```sh
brew install vips cairo pango pkg-config
cd vapor-server && swift run App          # http://127.0.0.1:8081
# або
cd hummingbird-server && swift run App    # http://127.0.0.1:8082
```

Запускайте з теки сервера: вебфайли й зразки зображень шукаються відносно неї. У Linux встановіть libvips 8.16 або скористайтеся [сторінкою про Docker](/oss/hokusai/uk/integrations/docker); там простіше йти через Docker.

| Змінна | Типове значення | Значення |
| --- | --- | --- |
| `PORT` | 8081 (Vapor), 8082 (Hummingbird) | Порт, який слухати |
| `HOST` | `127.0.0.1` | Адреса прив'язки; у контейнері — `0.0.0.0` |
| `WEB_ROOT` | `../web` | Звідки читати вебсторінку |
| `FIXTURES_ROOT` | `../fixtures` | Звідки читати зразки зображень |
| `HOKUSAI_MAX_CONCURRENT` | 2 | Скільки обчислень виконується одночасно |
| `HOKUSAI_MAX_QUEUED` | 2 | Скільки обчислень може чекати; решту відхиляють із 503 |

Обидві межі Hokusai навмисно малі, щоб Runtime Lab міг показати, як черга заповнюється й починає відмовляти. Hokusai фіксує їх під час обробки першого зображення, тож для зміни перезапустіть сервер ([конфігурація середовища](/oss/hokusai/uk/runtime-performance/runtime)).

## Пісочниця для macOS {#macos}

```sh
cd macos && swift run MacPlayground   # або відкрийте macos/Package.swift у Xcode
```

Вона запускає Hokusai локально через публічний API, без сервера й мережі. Модель рецепта й генератор коду в неї ті самі, що й у вебсторінки, тож рецепт означає в обох одне й те саме. Це пакет Swift, а не підписаний `.app`: він лінкується з libvips із Homebrew.

## Перші п'ять хвилин {#tour}

1. Відкрийте сторінку й оберіть зразок (або перетягніть власне зображення). На сервері все лишається в пам'яті десять хвилин.
2. Оберіть **пресет**, наприклад *Thumbnail* чи *Social card*. Кожен крок — звичайний виклик Hokusai; змінюйте порядок, вимикайте чи редагуйте їх, і результат оновлюється.
3. Відкрийте панель коду. Вкладка **Swift** друкує те, що сторінка щойно виконала: як чистий Hokusai (*Core*) або всередині маршруту *Vapor* чи *Hummingbird*; **HTTP** показує еквівалентний `curl`. Замість вашого файлу підставлено `input.jpg`.
4. **Inspect** зчитує факти з експортованих байтів: які метадані вціліли, розкладка сирих пікселів, сторінки PDF чи кадри GIF.
5. **Runtime Lab** показує потокову відповідь, чергу та збої; **Export / PDF** порівнює всі кодувальники й будує векторний PDF із виділюваним текстом.

Варто спробувати ще дві речі. **Немає фото?** На порожній сторінці оберіть *Start from text*: рецепт тоді сам створює пікселі через `Hokusai.text`, а згенерований Swift (для Vapor і Hummingbird це `GET`-маршрут) не потребує завантаження. **Ядра й матриці** редагуються як сітки чисел: додайте крок *Convolution kernel*, *Colour matrix* чи *Affine transform* і почніть із пресета, наприклад *Emboss*, *Sepia* чи *Shear*.

Попередній перегляд зменшує лише *результат* для показу. Рецепт завжди виконується над повним оригіналом, тож кадрування й текст потрапляють точно туди, куди їх поставить експорт.

## Найменша інтеграція {#minimal}

У кожного сервера є один маршрут, який можна прочитати без решти демо: завантаження, зміна розміру, відповідь.

```sh
curl --data-binary @photo.jpg 'http://localhost:8081/api/minimal/resize?width=800' -o small.webp
```

Vapor ([`vapor-server/Sources/App/main.swift`](https://github.com/ivantokar/hokusai-examples/blob/main/vapor-server/Sources/App/main.swift)):

```swift
routes.grouped(HokusaiErrorMiddleware()).post("api", "minimal", "resize") { req async throws -> Response in
    let width = min(max(req.query[Int.self, at: "width"] ?? 800, 16), 4096)
    let image = try await req.hokusaiImage(maximumSize: 5 * 1024 * 1024)   // 413 понад 5 МіБ
        .autoOrient()
        .resize(width: width, fit: .inside)
    return try await image.webp(quality: 82).response()                    // потоком, Content-Type: image/webp
}
```

Hummingbird ([`hummingbird-server/Sources/App/main.swift`](https://github.com/ivantokar/hokusai-examples/blob/main/hummingbird-server/Sources/App/main.swift)):

```swift
router.group("api/minimal").add(middleware: HokusaiErrorMiddleware()).post("resize") { request, _ -> Response in
    let width = min(max(request.uri.queryParameters["width"].flatMap { Int($0) } ?? 800, 16), 4096)
    let image = try await request.hokusaiImage(maximumSize: 5 * 1024 * 1024)   // 413 понад 5 МіБ
    let resized = try image
        .autoOrient()
        .resize(width: width, fit: .inside)
    return try await resized.webp(quality: 82).response()
}
```

Справжні маршрути приймають ще й `?format=`, щоб Runtime Lab міг порівнювати кодувальники. Усе інше в цих файлах — демо навколо.

## Тестування {#test}

Кожна перевірка нижче запускається в CI репозиторію.

| Команда | Що перевіряє | Потрібно |
| --- | --- | --- |
| `swift test --package-path recipes` | Каталог, компілятор рецептів, генератор Swift, сховище завантажень | Swift, libvips |
| `swift test --package-path macos` | Модель пісочниці для macOS: скасування й повтор, відкидання застарілих результатів, перегляд проти експорту | macOS |
| `scripts/check-snippets.sh` | Swift-код зі сторінки компілюється й виконується для кожного пресета та шаблону PDF | Swift, libvips |
| `scripts/coverage.py --check` | Матриця покриття відповідає каталогу операцій | Python 3 |
| `scripts/smoke.sh <url> <vapor\|hummingbird>` | Один запущений бекенд через HTTP API: рендер, помилки, метадані, відмова черги, PDF, сирі пікселі, шари | Запущений сервер |
| `scripts/parity.sh <url> <url>` | Два запущені бекенди дають на ті самі запити однакові байти, заголовки й помилки | Обидва сервери запущено |

Дві HTTP-перевірки запускайте проти серверів, які ви запустили самі:

```sh
(cd vapor-server && PORT=8081 swift run App &)
(cd hummingbird-server && PORT=8082 swift run App &)
scripts/smoke.sh http://127.0.0.1:8081 vapor
scripts/smoke.sh http://127.0.0.1:8082 hummingbird
scripts/parity.sh http://127.0.0.1:8081 http://127.0.0.1:8082
```

[`coverage/COVERAGE.md`](https://github.com/ivantokar/hokusai-examples/blob/main/coverage/COVERAGE.md) перелічує кожну публічну можливість, де її показує демо та які показано лише частково або ще ні.

## Спробувати незвільнену зміну бібліотеки {#local}

Демо залежать від випущених версій. Щоб спробувати власні зміни в бібліотеці, витягніть її поруч із прикладами й скористайтеся режимом редагування SwiftPM у сервері, який запускаєте:

```sh
cd vapor-server
swift package edit hokusai --path ../../hokusai    # або hokusai-vapor
swift run App
swift package unedit hokusai                       # назад до випущеної версії
```

Ніколи не комітьте змінену копію.

## Перенести у власний застосунок {#adopt}

- Починайте з найменшого маршруту вище та сторінки про [сервіс на Vapor](/oss/hokusai/uk/integrations/vapor-service) чи [Hummingbird](/oss/hokusai/uk/integrations/hummingbird), а не з демо. Сховище завантажень, межі черги й модель рецепта в демо існують заради пісочниці.
- Модель рецепта в `recipes/` необов'язкова. Вона дає інтерфейсу описати конвеєр як JSON і згенерувати з нього Swift; самому Hokusai нічого з цього не потрібно.
- Задайте `RuntimeConfiguration` під власні обмеження й вирішіть щодо `blockUntrustedOperations` для недовірених завантажень ([середовище](/oss/hokusai/uk/runtime-performance/runtime)).

## Коли щось іде не так {#troubleshooting}

| Що ви бачите | Причина й виправлення |
| --- | --- |
| Збірка падає на libvips або версію відхилено | Hokusai 2 потребує libvips 8.16 або новішої. Скористайтеся Docker або `brew install vips` на macOS |
| `Address already in use` | Порт зайнятий іншим процесом. Задайте `PORT` або зупиніть старий сервер |
| Сторінка відкривається, але зображень немає | Сервер запущено не з тієї теки. Запускайте в `vapor-server` чи `hummingbird-server` або задайте `WEB_ROOT` і `FIXTURES_ROOT` |
| 413 | Зображення більше за ліміт завантаження. Найменший маршрут приймає 5 МіБ |
| 422 | Це не зображення, або крок не можна застосувати (наприклад, кадрування поза межами зображення) |
| 503 із повідомленням про чергу | Запитів більше, ніж дозволяють межі виконання й черги. Саме це показує Runtime Lab; збільште `HOKUSAI_MAX_QUEUED` і перезапустіть |
| Перегляд PDF чи TIFF каже, що недоступний (501) | Це середовище не вміє прочитати формат назад. В образах Docker потрібне є; нативна libvips без poppler не може показати PDF |
| `autoOrient` нібито нічого не робить | libvips зібрано без libexif, тож тег орієнтації ігнорується. Перевірте `/api/capabilities` |
| Тексту немає або шрифт інший | Тексту потрібні шрифти й libvips із Pango. Образ Docker містить DejaVu; нативний запуск бере системні шрифти |

## Пов'язане {#related}

- [Hokusai Vapor](/oss/hokusai/uk/vapor/overview), [Hokusai Hummingbird](/oss/hokusai/uk/integrations/hummingbird), [macOS](/oss/hokusai/uk/integrations/macos)
- [Docker](/oss/hokusai/uk/integrations/docker), [Встановлення](/oss/hokusai/uk/guide/installation)
