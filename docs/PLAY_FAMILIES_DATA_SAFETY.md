# CurioVerse Play Families & Data Safety Baseline

This document records the implementation facts that must be re-checked before every Google Play submission. It is an engineering checklist, not legal advice.

## Current v1 audience

Intended Play target audience: children aged 6–8 and 9–12.

## Current implementation facts

- No advertising SDK is intentionally included.
- No analytics SDK is intentionally included.
- No CurioVerse cloud account or backend is used by the app.
- Child identity is based on generated aliases/nicknames rather than real names.
- Profile choices and progress are stored locally on the device.
- Explorer Clubhouse is device-only and uses fictional crew members; it is not public chat or real user-to-user messaging.
- The Animal Picture Scanner can use the camera or gallery.
- Image recognition is performed with Google ML Kit image labeling on-device from CurioVerse application code.
- CurioVerse application code does not upload the selected photo to its educational content service.
- The detected text label can be sent to Wikipedia to retrieve a public educational summary.
- Other learning experiences can retrieve public educational content such as Wikipedia/NASA resources.

## Expected Android capabilities

The generated Android release currently requires:

- `android.permission.INTERNET` — public educational content requests.
- `android.permission.CAMERA` — optional Animal Picture Scanner camera capture.
- Camera hardware is declared optional.

Dependencies can merge additional manifest entries. The release workflow therefore validates the merged release manifest and records it as an artifact.

## Play Console consistency matrix

| Play declaration | v1 engineering baseline |
| --- | --- |
| Ads | No ads |
| App access | No login/restricted account required |
| Target audience | 6–8 and 9–12 |
| User-to-user content exchange | No |
| Online content | Yes |
| Primary purpose | Education |
| Camera | Optional feature |
| Photo upload by CurioVerse app code | No |
| External educational requests | Yes |
| Local profile/progress storage | Yes |

## Release gate

Before certifying Families compliance or submitting Data Safety:

1. `flutter analyze` passes.
2. `flutter test` passes.
3. Release AAB is built from the intended commit.
4. Merged release manifest audit passes.
5. Review the uploaded `curioverse-merged-release-manifest` artifact for unexpected permissions/components.
6. Re-check `pubspec.yaml` for new SDKs, especially ads, analytics, authentication, location, social, payments or cloud-storage packages.
7. Re-check network destinations in source code.
8. Reconcile the Play Data Safety form with the actual behavior of every dependency/SDK, including Google ML Kit and platform services.
9. Confirm the published privacy policy matches the release.

A green automated manifest check is evidence for review, not a substitute for the developer's Google Play policy/legal certification.
