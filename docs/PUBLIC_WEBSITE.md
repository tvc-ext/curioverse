# CurioVerse public website

The static public website lives in `site/` and is designed for GitHub Pages.

## Pages URL

After the Pages workflow is enabled and merged, the expected site URL is:

`https://tvc-ext.github.io/curioverse/`

The Google Play privacy-policy URL should be:

`https://tvc-ext.github.io/curioverse/privacy/`

## Static-site constraints

The site intentionally has:

- No JavaScript.
- No forms.
- No analytics.
- No cookies.
- No trackers.
- No backend.

The Pages workflow validates these constraints on pull requests and before deployment.

## Privacy-source notes

Privacy claims were based on the current Flutter implementation:

- `AGENTS.md`: child-safety rules require aliases, broad age bands, local-first storage, and no ads or dark patterns.
- `pubspec.yaml`: current dependencies include shared preferences, HTTP, image picker, and Google ML Kit image labeling; no ad or analytics dependency is present.
- `lib/data/profile_store.dart`: age band and avatar ID are stored locally with shared preferences.
- `lib/data/progress_store.dart`: curiosity energy and completed topic IDs are stored locally with shared preferences.
- `lib/data/open_knowledge_service.dart`: public Wikipedia and NASA educational content is requested and cached locally.
- `lib/data/question_banks.dart`: public GitHub-hosted question packs are requested and cached locally; question history is stored locally.
- `lib/screens/animal_scanner_screen.dart`: camera/gallery image selection uses `image_picker`; labeling uses Google ML Kit on device; detected label text may be sent to Wikipedia for a summary.
- `lib/models/child_profile.dart`: identity is a broad age band and playful avatar alias.
