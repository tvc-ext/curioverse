# CurioVerse Play Store Release

This repository builds two Android release artifacts:

- `curioverse-latest.apk` for direct tester installation.
- `curioverse-play-store.aab` for Google Play Console uploads.

The APK remains available for quick testing. The AAB is the production Play Store artifact and must be signed with the Play upload key through GitHub Secrets.

## Required GitHub Secrets

Configure these secrets in the GitHub repository before running a production release:

| Secret | Purpose |
| --- | --- |
| `CURIOVERSE_UPLOAD_KEYSTORE_BASE64` | Base64-encoded Android upload keystore file. |
| `CURIOVERSE_UPLOAD_KEYSTORE_PASSWORD` | Store password for the upload keystore. |
| `CURIOVERSE_UPLOAD_KEY_ALIAS` | Key alias inside the upload keystore. |
| `CURIOVERSE_UPLOAD_KEY_PASSWORD` | Password for the upload key alias. |

Do not commit the keystore, passwords, generated `android/key.properties`, or decoded `.jks` file to the repository. The workflow decodes the keystore only inside the GitHub Actions runner.

## Create The Upload Keystore

Create the upload keystore on a trusted local machine:

```bash
keytool -genkey -v \
  -keystore curioverse-upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias curioverse_upload
```

Convert it to base64 for the GitHub secret:

```bash
base64 -w 0 curioverse-upload-keystore.jks
```

On macOS, use:

```bash
base64 -i curioverse-upload-keystore.jks
```

Save the output as `CURIOVERSE_UPLOAD_KEYSTORE_BASE64`.

## Versioning

Android uses two release values:

| Value | Meaning | Rule |
| --- | --- | --- |
| Version name | User-facing version, for example `1.0.0`. | Can follow semantic versioning. |
| Version code | Internal integer submitted to Play Store. | Must increase for every Play Store upload. |

The workflow accepts both values through `workflow_dispatch` inputs:

- `release_version`
- `version_code`

For normal push builds, the workflow uses `vars.CURIOVERSE_RELEASE_VERSION` when present, otherwise `1.0.0`, and uses the GitHub run number as the version code.

## Release Procedure

1. Confirm the app passes review checks:
   - `flutter analyze`
   - `flutter test`

2. Confirm the required signing secrets exist in GitHub repository settings.

3. Open **Actions** in GitHub and run **Android Release** manually with:
   - `release_version`: the release version name, for example `1.0.0`
   - `version_code`: an integer greater than the last Play Console upload

4. Wait for the workflow to finish successfully.

5. Download artifacts from the workflow run if needed:
   - `curioverse-tester-apk`
   - `curioverse-play-store-aab`

6. Use the replaceable GitHub Release tagged `latest` for stable downloads:
   - APK: `curioverse-latest.apk`
   - AAB: `curioverse-play-store.aab` when signing secrets are configured

7. Upload `curioverse-play-store.aab` to Google Play Console.

8. Keep the upload keystore backed up securely. Losing it can block future app updates.

## Notes

- The workflow preserves the existing tester APK path and adds the Play Store AAB.
- The workflow does not commit signing credentials.
- The AAB build is skipped when signing secrets are not fully configured.
- Friends Connect and unrelated app features are intentionally outside this milestone.
