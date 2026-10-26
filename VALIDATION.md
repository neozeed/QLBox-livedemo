# Validation — 26 October 2026

- Emscripten 3.1.64 compiled the SDL2 browser build successfully (about 1.8 MB).
- Chrome loaded the WASM/data and booted the mounted cartridge.
- Visually observed the initial graphic, scrolling credits and rotating point effect.
- Web Audio analyser detected non-silent output with the context running. This is signal verification, not a subjective listening assessment.
- Mute suspended audio; Enable sound resumed it and restored the signal.
- Fullscreen entry and the in-screen Exit fullscreen control worked.
- Restart returned to a fresh loading/start screen.
- Native timing, beeper and QSound regressions passed.
- Native 1500- and 9000-frame demo runs completed. The longer run produced 8,640,000 samples, 3,805,343 nonzero samples, peak magnitude 15003.

Not measured: sample-exact browser/native equivalence, low-end mobile performance, Safari/Firefox behavior or complete hardware fidelity.

