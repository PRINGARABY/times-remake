# TIMES REMAKE — THE LIVING ARCHIVE

Учебная работа по теме «Разработка интернет-магазина розничной торговли, домен e-commerce» для команды из трёх студентов.

**Unofficial educational concept project.** Это неофициальный прототип, вдохновлённый магазином Times Remake в Шанхае. Проект не связан с магазином и не является его официальным сайтом. Все товары, бренды, цены и сведения о наличии вымышлены. Покупки недоступны. Hero использует предоставленное пользователем утверждённое изображение `times-remake-hero.png`. Это концептуальный интерьер. В двух редакционных блоках используются выбранные пользователем фотографии из Instagram магазина: [вход на Fumin Road](https://www.instagram.com/times_remake/p/DbBJ4x6Acdv/) и [фасад на Changle Road](https://www.instagram.com/times_remake/p/Da5eaBHgSbm/). Для всех товаров без фотографий используется одна нейтральная SVG-заглушка в прозрачном поле.

## Реализованный объём

Только Этап 1: главная, каталог, страница товара, фильтры, сортировка, три бизнес-модели и демонстрационные данные. Frontend обновлён: минеральная палитра, sticky header, интерьерный hero, New Arrivals, редакционный блок, Archive Selection и история концепта. Направления: Remake, Archive и Brand Collection.

- `/` — концепция и featured-товары.
- `/shop` — каталог; обычная GET-форма без Turbo Frames.
- `/products/:slug` — характеристики, замеры, состояние и доступность товара.
- Пример: `/shop?direction=archive&available=1&sort=price_asc`.

Фильтры `brand` и `category` принимают slug, `direction` — `remake`, `archive` или `brand_collection`, `available=1` оставляет только товары со статусом `available` и положительным остатком. Сортировки: `newest`, `price_asc`, `price_desc`. Неизвестная сортировка использует порядок по новизне. Проданные вещи видны в общем каталоге, черновики скрыты и возвращают 404 при прямом обращении.

## Стек и требования

- Ruby 3.4.x (проверенная версия — 3.4.10, указана в `.ruby-version`).
- Rails 8.1.3.1, PostgreSQL 17, ERB, Turbo и Stimulus через importmap.
- Tailwind CSS 4 через `tailwindcss-rails`, Propshaft, Active Storage с локальным хранилищем.
- Minitest, Capybara, Selenium/Chrome; RuboCop Rails Omakase.
- Bundler 4.x; `Gemfile.lock` фиксирует проверенные зависимости.
- Для системных тестов нужен Google Chrome. Selenium Manager получает подходящий ChromeDriver при первом запуске, для этого нужен интернет. При отсутствии интернета заранее установите совместимый ChromeDriver в `PATH`.

Node.js, npm, Redis, ImageMagick и отдельный frontend не нужны. Варианты Active Storage не обрабатываются. Для hero подготовлены статические JPEG-копии шириной 640/960/1672 px; исходный PNG сохранён без изменений. `srcset` выбирает подходящую копию, кадрирование выполняет CSS `object-fit: cover`. Фотографии перебивок хранятся локально в `app/assets/images/times-remake-fumin-road.jpg` (1279 × 958) и `times-remake-changle-road.jpg` (967 × 775), рядом — копии шириной 640 px. Это доступные большие версии фотографий из публикаций, без генеративной обработки; ссылки на источники указаны под снимками. `json < 3` закреплён из-за несовместимости позиционных аргументов `JSON.parse` в Rails 8.1 с JSON 3.

## Установка и PostgreSQL

Все команды выполняются из корня проекта. Сначала активируйте Ruby 3.4 своим менеджером версий. Для macOS с Homebrew:

```sh
brew install ruby@3.4 postgresql@17
export PATH="$(brew --prefix ruby@3.4)/bin:$(brew --prefix postgresql@17)/bin:$PATH"
ruby -v
bundle -v
bundle config set --local path vendor/bundle
bundle install
```

Локальный PostgreSQL можно запустить без системного автозапуска. Следующая команда `initdb` нужна **только один раз**, если `tmp/postgres/PG_VERSION` ещё не существует:

```sh
initdb -D tmp/postgres --locale=en_US.UTF-8 -E UTF8 --auth=trust
```

Запуск уже инициализированной базы:

```sh
pg_ctl -D tmp/postgres -l tmp/postgres.log -o '-p 5432 -h 127.0.0.1 -k /tmp' start
```

В текущем workspace кластер уже создан в `tmp/postgres`. Не запускайте второй сервер на том же порту. Данные этого учебного кластера находятся в игнорируемой Git папке `tmp`; не удаляйте её, если хотите их сохранить. `trust` используется только для локального учебного сервера, который слушает loopback.

Если PostgreSQL уже работает, используйте его. Роль должна иметь право создавать базы. `config/database.yml` читает `PGHOST` (по умолчанию `localhost`), `PGPORT` (`5432`), `PGUSER` (текущий пользователь ОС) и `PGPASSWORD`. Например, если ваша локальная роль называется `postgres`, выполните `export PGUSER=postgres`. Не сохраняйте пароль в репозитории. Отдельные базы называются `times_remake_development` и `times_remake_test`.

## Создание базы, миграции, seeds

```sh
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
bin/rails tailwindcss:build
```

Seed идемпотентен: записи находятся по стабильному slug и обновляются внутри транзакции. Повторный запуск сохраняет 4 бренда, 5 категорий и 9 демонстрационных товаров в изначально пустой базе. Дополнительные записи пользователя не удаляются. Изменённые поля исходных демонстрационных записей будут восстановлены из seed.

Для повторной подготовки существующего приложения можно использовать `bin/setup --skip-server`: он проверит зависимости, выполнит `db:prepare`, seed и сборку CSS. Он не удаляет данные.

## Запуск

```sh
bin/dev
```

Откройте <http://127.0.0.1:3000>. `bin/dev` запускает Puma и Tailwind watcher через Foreman. Остановка — Ctrl+C. Альтернатива без watcher:

```sh
bin/rails tailwindcss:build
bin/rails server -b 127.0.0.1
```

Базу после работы можно остановить отдельно:

```sh
pg_ctl -D tmp/postgres stop
```

## Тесты и lint

PostgreSQL должен быть запущен. Тесты используют отдельную тестовую базу и собственные fixtures, запуск seed для них не требуется.

```sh
RAILS_ENV=test bin/rails db:prepare
bin/rails test
bin/rails test:system
bin/rubocop
bin/rails zeitwerk:check
```

`bin/rails test` проверяет модели и HTTP-сценарии. `test:system` проверяет переходы, GET-фильтры, поиск по отображаемым товарам, empty state, sold, мобильное меню и Escape, sticky header, прозрачность карточек и reduced motion. Проверяемые размеры: 1440×900, 768×1024, 390×844; изображения загружаются без горизонтального переполнения. CSS автоматически собирается перед тестами.

После обновления frontend прошли 30 модельных/HTTP-тестов и 7 системных тестов, RuboCop и Zeitwerk. Скриншоты системных тестов: `tmp/screenshots/frontend-*.png`. Полные страницы с девятью рабочими демотоварами отдельно просмотрены в Chrome; снимки этой проверки: `tmp/screenshots/final/`. Safari, Firefox и реальные мобильные устройства отдельно не проверялись.

В ограниченной среде Codex доступ к локальному PostgreSQL, запуск браузера и скачивание зависимостей могут потребовать разрешения sandbox. Ошибка `Operation not permitted` в таком окружении не означает неправильный пароль к базе.

## Основные файлы

```text
app/models/{brand,category,product}.rb       # связи, validations, scopes
app/controllers/pages_controller.rb        # главная
app/controllers/products_controller.rb     # каталог и товар
app/helpers/products_helper.rb             # цена и изображение
app/views/pages/home.html.erb
app/views/products/{index,show}.html.erb
app/views/shared/                         # карточка, header, footer, responsive image
app/views/layouts/application.html.erb
app/assets/tailwind/application.css         # тема и адаптивные стили
app/assets/images/                         # утверждённый hero, его копии, SVG-текстура и надписи
app/javascript/controllers/                # меню и поиск внутри текущей выборки
config/routes.rb
config/database.yml
db/migrate/                                # каталог и Active Storage
db/schema.rb
db/seeds.rb
test/models/, test/integration/, test/system/
```

Slug задаётся явно и валидируется, в seed он получается через `parameterize`. Деньги хранятся целым числом в `price_cents`; форматирование использует BigDecimal, валюта текущего этапа — CNY. `condition_score` необязателен; заполненное значение должно быть от 1 до 10. `measurements` — JSON-объект, например `{ "chest": "58 cm" }`. `ONE OF ONE` означает ровно `quantity == 1`, а не факт доступности. `sold` всегда недоступен, даже если остаток положителен.

Публичной загрузки изображений нет. Связь `has_many_attached :images` уже работает; интерфейс управления изображениями относится к следующему этапу. При отсутствии вложений все карточки используют одну нейтральную SVG-заглушку. Разные иллюстрации одежды удалены.

Корзина, admin, пользователи, заказы, оплата, письма, интеграции и deployment не реализованы. Каталог рассчитан на небольшой учебный набор; пагинации и полнотекстового поиска нет. План продолжения — [docs/ROADMAP.md](docs/ROADMAP.md).

## Поддержка frontend

Текущая арт-дирекция основана на изучении официальных ERD и Jaded London: отдельная типографика логотипа, цельный интерьерный кадр, крупные парные фотографии магазина и единые товарные поля 2:3.

Логотип — локальный Barlow Condensed 800, интерфейс — локальный Inter 400–600. Лицензии шрифтов находятся в `app/assets/fonts/`. Фон использует собственную растровую фактуру `mineral-surface-v3.jpg`; процедурные точки и зерно удалены. Цвета, сила фактуры и размеры задаются в `app/assets/tailwind/theme.css`.

Для всех товаров без фото используется одна нейтральная заглушка. Префикс Demo — скрыт только в отображаемых названиях; данные не изменялись. SEARCH, GET-фильтры, направления и уведомление о корзине сохранены. Учебный статус остаётся видимым.

Материалы, полный prompt новой фактуры, настройки и история возврата — [docs/DESIGN.md](docs/DESIGN.md). Скриншоты: `tmp/screenshots/editorial-v3/`. После правок CSS выполнить `bin/rails tailwindcss:build` либо использовать watcher через `bin/dev`.
