#!/bin/sh
set -e

VERSION="${1:-1.0.0}"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST_ROOT="$PROJECT_ROOT/build/android-sdk-release"
PACKAGE_DIR="$DIST_ROOT/NossoFlutterSDK-Android-$VERSION"
ZIP_PATH="$DIST_ROOT/NossoFlutterSDK-Android-$VERSION.zip"

rm -rf "$PACKAGE_DIR" "$ZIP_PATH"
mkdir -p "$PACKAGE_DIR"

cd "$PROJECT_ROOT/flutter_module"
flutter pub get
flutter build aar --output="$PACKAGE_DIR/flutter-aar-repo"

cp -R "$PROJECT_ROOT/android_sdk_distribution" "$PACKAGE_DIR/wrapper"

cd "$DIST_ROOT"
/usr/bin/zip -qry "NossoFlutterSDK-Android-$VERSION.zip" "NossoFlutterSDK-Android-$VERSION"

echo "$ZIP_PATH"
