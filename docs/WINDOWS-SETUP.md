# Times Remake — запуск на Windows

Рабочая копия проекта: `D:\projects\times-remake`.
Оригинал на рабочем столе (`C:\Users\Vadim Stolbovoy\Desktop\проект пин\Times Remake\Times Remake`) оставлен как резервная копия. Запускать сайт из него не стоит: в пути есть кириллица, из-за которой ломается сборка нативных gem-расширений.

## Что установлено

| Компонент | Версия | Путь |
| --- | --- | --- |
| Ruby + MSYS2/DevKit | 3.4.11 | `D:\Ruby34-x64` |
| Bundler | 4.0.15 | gem |
| PostgreSQL | 17.11 | `D:\PostgreSQL\17` |
| Кластер PostgreSQL | 17 | `D:\PostgreSQL\17\data` |
| Проект | Rails 8.1.3.1 | `D:\projects\times-remake` |

`Gemfile.lock` дополнен платформой `x64-mingw-ucrt`. Windows-гемы лежат в `D:\projects\times-remake\vendor\bundle`.

## Запуск

1. Двойной клик по ярлыку **Times Remake** на рабочем столе или по `D:\projects\times-remake\start-site.cmd`.
   Скрипт запускает PostgreSQL, затем Rails и открывает <http://127.0.0.1:3000>.
2. В открывшемся окне «Times Remake server» останавливай сервер через `Ctrl+C`.
3. База после работы останавливается через `D:\PostgreSQL\stop-pg.cmd` (необязательно, если она нужна постоянно).

Запуск вручную:

```powershell
$env:Path = "D:\Ruby34-x64\bin;D:\Ruby34-x64\msys64\ucrt64\bin;D:\Ruby34-x64\msys64\usr\bin;D:\PostgreSQL\17\bin;" + $env:Path
$env:PGUSER = "postgres"
$env:PGHOST = "127.0.0.1"
$env:PGPORT = "5432"
cd "D:\projects\times-remake"
bundle exec rails server -b 127.0.0.1
```

## База данных

- host: `127.0.0.1`, port: `5432`, user: `postgres`, базы: `times_remake_development` и `times_remake_test`.
- Локальная аутентификация настроена через `trust`: пароль не нужен.
- PostgreSQL слушает только loopback (`127.0.0.1`), снаружи недоступен.
- Если нужен пароль, измени `D:\PostgreSQL\17\data\pg_hba.conf` и выполни `ALTER USER postgres PASSWORD '...'`, затем перезапусти кластер.

Проверка:

```powershell
& "D:\PostgreSQL\17\bin\psql.exe" -U postgres -h 127.0.0.1 -d times_remake_development -c "select count(*) from products;"
```

## Тесты

```powershell
$env:Path = "D:\Ruby34-x64\bin;D:\Ruby34-x64\msys64\ucrt64\bin;D:\Ruby34-x64\msys64\usr\bin;D:\PostgreSQL\17\bin;" + $env:Path
$env:PGUSER = "postgres"
$env:PGHOST = "127.0.0.1"
$env:PGPORT = "5432"
cd "D:\projects\times-remake"
bundle exec rails test
bundle exec rails test:system
```

Проверено на этой машине: 31 модельный/HTTP-тест и 9 системных тестов, 0 ошибок.

## Если что-то не работает

- `ruby` не найден — открой новый терминал или добавь `D:\Ruby34-x64\bin` в PATH.
- `psql` не найден — добавь `D:\PostgreSQL\17\bin` в PATH.
- Порт 3000 занят — закрой старый процесс Ruby или запусти `bundle exec rails server -b 127.0.0.1 -p 3001`.
- PostgreSQL не стартует — смотри `D:\PostgreSQL\17\pg.log`.
- Ошибка сборки gem — нужен MSYS2 из `D:\Ruby34-x64\msys64` (пакеты `ucrt64` и `usr\bin` в PATH).

## Важно

- `tmp\postgres` и `vendor\bundle-macos-3.4.0` в резервной копии — артефакты macOS. На Windows они не используются.
- Не коммить `vendor/bundle`, `tmp`, `log` — они уже в `.gitignore`.
- Перед публикацией в новый репозиторий проверь `config/master.key`: он нужен для расшифровки credentials, но публиковать его нельзя.
