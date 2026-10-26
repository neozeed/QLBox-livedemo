#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v emcc >/dev/null || { echo 'Activate Emscripten first: source /path/to/emsdk/emsdk_env.sh' >&2; exit 1; }
mkdir -p web/dist
emcc -O2 -Isrc -Ivendor/musashi -DQLBOX_SDL -sUSE_SDL=2 \
  src/main.c src/sdl_input.c src/debugger.c src/mouse.c src/qsound.c \
  src/beeper.c src/terminal.c src/hostfs.c src/imagefs.c src/ql.c \
  vendor/musashi/m68kcpu.c vendor/musashi/m68kops.c \
  vendor/musashi/softfloat/softfloat.c -lm \
  -sASYNCIFY=1 -sASYNCIFY_ONLY='["main"]' \
  -sALLOW_MEMORY_GROWTH=1 -sSTACK_SIZE=1048576 \
  -sEXPORTED_RUNTIME_METHODS='["callMain"]' -sEXIT_RUNTIME=1 \
  --preload-file rom/js-rom.bin@/rom/js-rom.bin \
  --preload-file web/assets/ql26inv.mdv@/ql26inv.mdv \
  -o web/dist/qlbox.js
cp web/index.html web/dist/index.html
printf 'Built web/dist. Serve over HTTP, e.g. python3 -m http.server 8080 --directory web/dist\n'
