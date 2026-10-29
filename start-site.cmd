@echo off
setlocal
set "PATH=D:\Ruby34-x64\bin;D:\Ruby34-x64\msys64\ucrt64\bin;D:\Ruby34-x64\msys64\usr\bin;D:\PostgreSQL\17\bin;%PATH%"
set "PGUSER=postgres"
set "PGHOST=127.0.0.1"
set "PGPORT=5432"
set "PGCLIENTENCODING=UTF8"

call "D:\PostgreSQL\start-pg.cmd"
cd /d "D:\projects\times-remake"

rem Open the browser in ~8 seconds, once Puma has had time to boot.
start "" /min powershell -NoProfile -WindowStyle Hidden -Command "Start-Sleep -Seconds 8; Start-Process 'http://127.0.0.1:3000'"

echo.
echo   Times Remake is starting at http://127.0.0.1:3000
echo   Keep this window open. Press Ctrl+C to stop the server.
echo.

bundle exec rails server -b 127.0.0.1

echo.
echo   Server stopped.
pause
