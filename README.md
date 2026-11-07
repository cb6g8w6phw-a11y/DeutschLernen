# DeutschLernen

Aplikacja SwiftUI (iOS 16+) do niemieckiego w pracy i na co dzień. Bez powitań z podręcznika. Czat i nowe lekcje idą przez darmowy klucz Gemini.

## IPA z GitHub Actions

Po pushu na `main` workflow **Build IPA** (macOS) składa niepodpisany `DeutschLernen.ipa`.

1. Otwórz zakładkę Actions.
2. Wejdź w ostatni run **Build IPA**.
3. Pobierz artefakt `DeutschLernen-ipa`.
4. Zainstaluj przez SideStore albo AltStore (podpisze go twoje Apple ID).

## Lokalnie na Macu

```bash
brew install xcodegen
./build_ipa.sh
```

W aplikacji: Ustawienia → wklej klucz z https://aistudio.google.com/apikey
