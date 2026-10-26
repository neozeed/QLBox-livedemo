# QLBox R20 WebAssembly showcase

This adds a browser build to the documented QLBox R20 source, including the
R20 MSYS2 console Makefile fix. The uploaded QL26 invitation cartridge is
included unchanged as `assets/ql26inv.mdv`.

## Run the prebuilt page

Serve `web/dist` with any static HTTP server. For a local preview:

    python3 -m http.server 8080 --directory web/dist

Open http://localhost:8080 and click **Start demo with sound**. The click enables
browser audio; the cartridge then boots itself without typing BASIC commands.
Restart reloads a fresh machine; Mute/Enable sound controls Web Audio; Fullscreen
expands the display. Click the display for keyboard input. Keep the tab visible.

All four files in `web/dist` must stay together: index.html, qlbox.js,
qlbox.wasm and qlbox.data. No server-side emulation or external CDN is used.
No cross-origin isolation headers are required. Serve WASM as application/wasm.

The launch options are equivalent to:

    qlbox --mount ql26inv.mdv --timing ql

The wrapper also supplies --no-config and an explicit packaged ROM path.
RAM remains the native default of 128 KB; CPU speed remains 1x. No QSound
firmware option or increased RAM is added. The cartridge is mounted read-only.

## Rebuild

Install and activate Emscripten (tested with 3.1.64), then run:

    source /path/to/emsdk/emsdk_env.sh
    ./web/build.sh

The first build downloads Emscripten's SDL2 port. Later builds reuse its cache.
The existing prebuilt ROM is packaged; rebuilding the ROM is not necessary.

## Port scope

Only `src/main.c` gains conditional Emscripten code. Native builds retain
SDL_Delay. Browser builds call emscripten_sleep once per frame, including when
behind schedule, to yield to the browser. Asyncify is restricted to main, keeping
the CPU interpreter and audio mixer free of Asyncify instrumentation.

Musashi, timing, memory, display conversion, beeper and QSound synthesis are
unchanged. SDL2 supplies browser keyboard, WebGL-backed rendering, and Web Audio
output. The page's sound indicator observes actual output through an AnalyserNode;
"Audio ready" means the context is running but the current sample is silent.
The browser requests the same 48 kHz mono output as the native frontend; SDL
handles output-device sample-rate conversion.

## Evidence and limits

The native baseline boots this cartridge and reaches the animated plasma and
scrolling credits at frame 1500. A 9000-frame run generated 8,640,000 mono samples,
3,805,343 nonzero samples, peak magnitude 15003. Timing, beeper and QSound tests
pass after the conditional frontend change. These are compatibility checks,
not a claim of perfect hardware accuracy. QL timing remains experimental.

The browser build and its UI are tested separately; see VALIDATION.md.
Browser timer throttling/background tabs and slow devices can disrupt playback.
This build uses SDL2's existing ScriptProcessor audio backend rather than a new
AudioWorklet implementation. Audio playback needs a user gesture under normal
browser autoplay policies.

## Credits

QLBox and its custom ROM: see the existing project README, documentation and
source attribution. CPU: Musashi and its bundled license. Browser portability:
Emscripten and SDL2. QL26 invitation: original authors credited in the demo.
The supplied cartridge and ROM retain their original rights and notices; this
port does not grant a new redistribution license for them.
