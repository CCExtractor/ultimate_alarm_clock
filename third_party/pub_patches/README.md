Project-local patched pub packages used to keep the Android build reproducible.

These directories were copied from the working patched pub cache used to validate
the Android migration on March 12, 2026. `pubspec.yaml` uses path-based
`dependency_overrides` so CI and other contributors resolve the same plugin
sources without relying on local `.pub-cache` edits.
