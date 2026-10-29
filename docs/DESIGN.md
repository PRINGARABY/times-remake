# Times Remake — арт-дирекция 03

Правка от 14 октября 2026 по пожеланиям пользователя. Референсы изучены в браузере: [ERD](https://www.enfantsrichesdeprimes.com/collections/new-arrivals-men), [страница товара ERD](https://www.enfantsrichesdeprimes.com/products/flannel-lined-trucker-jacket-blue-black-03-0743), [Jaded London](https://jadedldn.com/), [мужской каталог Jaded London](https://jadedldn.com/en-de/collections/new-in-mens).

## Принятые решения

- Логотип расположен слева на компьютере и по центру на телефоне. Он двухстрочный, с отдельным локальным шрифтом Barlow Condensed 800; интерфейс использует Inter 400–600. Шапка и футер используют один partial `_wordmark.html.erb`.
- Hero — цельный кадр на всю ширину. Текст вынесен из фотографии в компактную подпись под ней. Маски, рамки и затемняющие градиенты отсутствуют.
- Две настоящие фотографии магазина идут рядом на компьютере и последовательно на телефоне; пропорции 4:3 сохраняют фасады и вывески. Ссылки на публикации остаются в подписях.
- Товарные поля имеют единые пропорции 2:3, близкие к студийной подаче Jaded London, светлый нейтральный фон и компактные подписи. Для всех вещей без фото сохранена одна заглушка. При наличии фотографий Active Storage они показываются автоматически.
- Фон — собственная растровая фактура с мягкими следами износа, без процедурного шума и точек. Старый SVG асфальта больше не используется.
- Видимый префикс `Demo — ` скрыт в названиях карточек и товара; записи базы не менялись. Учебный статус указан на страницах и в футере.

## Настройки

`app/assets/tailwind/theme.css` — общие цвета, отступы, фон и пропорции.

| Значение | Назначение |
| --- | --- |
| `--font-wordmark` | Отдельный шрифт логотипа |
| `--font-sans` | Шрифт интерфейса |
| `--surface-texture-opacity` | Видимость растровой фактуры, 0.26 |
| `--color-mineral` | Основной цвет страницы |
| `--hero-height` | Высота главного кадра, 60svh |
| `--product-ratio` | Товарное поле, 2 / 3 |
| `--product-gap` | Промежутки между карточками |
| `--section-space` | Интервалы между разделами |

После правок CSS выполнить `bin/rails tailwindcss:build` или использовать watcher `bin/dev`.

## Материалы и происхождение

- `app/assets/fonts/times-wordmark.woff2`: Barlow Condensed 800, Google Fonts. Лицензия: `barlowcondensed-OFL.txt`.
- `app/assets/fonts/inter.woff2`: Inter, переменные веса 400–600, Google Fonts. Лицензия: `inter-OFL.txt`.
- `app/assets/images/mineral-surface-v3.jpg`: собственная фактура, созданная встроенным инструментом image_gen через навык imagegen. Оригинал PNG сохранён в каталоге generated_images; в проект перенесена JPEG-копия с тем же изображением для оптимизации размера.
- Фотографии ERD/Jaded London, их логотипы и шрифты с их сайтов не добавлялись.

Полный prompt для фактуры:

> Use case: photorealistic-natural. Asset type: a seamless material background for a minimalist high-end vintage fashion website. Generate ONLY one square texture image, photographed straight down, perfectly flat diffuse overcast light. Subject: smooth weathered grey sealed asphalt or dense fine mineral paving, not fresh coarse road gravel. Color: medium-light neutral grey, muted slightly warm mineral grey around RGB 184 185 178. Material should show subtle broad cloudy wear, faded rubbed areas and very faint natural hairline imperfections, elegant low contrast, uniform illumination. This is a website backdrop behind black text so no busy pattern. The texture must read as real aged matte physical material when seen full size, not digital noise. Absolutely no speckled dots, no salt-and-pepper grain, no obvious scattered stones, no plaster lumps, no 3D bumpy stucco, no pronounced pits, no large cracks, no tile joints, no vignette, no lighting gradients, no text, no symbols, no objects, no watermark. Seamless tileable edges with no visible repeated motif. Restrained editorial material photography.

## История и проверка

Предыдущая версия сохранена в `tmp/visual-backups/before-editorial-v3-20261014.zip`. Рядом находится manifest со списком заменённых и новых файлов. Более ранние копии также сохранены.

Проверки: Minitest, Capybara/Chrome, RuboCop, Zeitwerk; миграции и seed выполняются на отдельной временной базе. Скриншоты главной, каталога и товара на 320, 360, 390, 768 и 1440 px находятся в `tmp/screenshots/editorial-v3/`. Проверяется загрузка изображений и обоих локальных шрифтов.

Можно менять отдельные компоненты и общие настройки по описанию обычными словами. Admin, оплата, интеграции и deployment не добавлялись. Уведомление `Unofficial educational concept project` сохранено.
