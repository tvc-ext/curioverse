# CurioVerse contributor guidance

## Mission

Build a safe, delightful, local-first mobile learning universe for children. Prefer short visual interactions, discovery, creativity, and replayable challenges over passive feeds.

## Non-negotiable safety rules

- Never request or expose a child's real name, exact age, school, phone number, email, precise location, or photograph.
- Use generated aliases and broad age bands: 6–8, 9–11, and 12–14.
- Any social feature must be parent-controlled, use invite codes, and default to private.
- Do not add ads, public chat, external links, purchases, streak pressure, or dark patterns.
- Keep initial content and progress data on-device. Do not add a backend without an explicit architecture decision.

## Engineering conventions

- Flutter/Dart; Material 3.
- Organize by feature as the prototype grows.
- Keep domain logic separate from widgets.
- Add tests for quiz scoring, age-band filtering, and safety controls.
- Prefer immutable models and deterministic local fixtures.
- Run `flutter analyze` and `flutter test` before publishing.
