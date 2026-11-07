#!/bin/bash
# Wymaga: Mac + Xcode + XcodeGen (brew install xcodegen)
set -e
cd "$(dirname "$0")"
xcodegen generate
xcodebuild -project DeutschLernen.xcodeproj -scheme DeutschLernen \
  -configuration Release -sdk iphoneos -derivedDataPath build \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" build
rm -rf Payload DeutschLernen.ipa
mkdir Payload
cp -R build/Build/Products/Release-iphoneos/DeutschLernen.app Payload/
zip -qr DeutschLernen.ipa Payload
rm -rf Payload
echo "Gotowe: $(pwd)/DeutschLernen.ipa (niepodpisany - podpisz np. SideStore/AltStore)"
