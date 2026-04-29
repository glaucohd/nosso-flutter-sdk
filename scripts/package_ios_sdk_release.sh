#!/bin/sh
set -e

VERSION="${1:-1.0.0}"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST_ROOT="$PROJECT_ROOT/build/ios-sdk-release"
PACKAGE_DIR="$DIST_ROOT/NossoFlutterSDK-$VERSION"
ZIP_PATH="$DIST_ROOT/NossoFlutterSDK-$VERSION.zip"

rm -rf "$PACKAGE_DIR" "$ZIP_PATH"
mkdir -p "$PACKAGE_DIR/Frameworks"

cd "$PROJECT_ROOT/flutter_module"
flutter pub get
flutter build ios-framework --output="$PROJECT_ROOT/poc/Flutter"

cp -R "$PROJECT_ROOT/poc/Flutter/Release/App.xcframework" "$PACKAGE_DIR/Frameworks/App.xcframework"
cp -R "$PROJECT_ROOT/poc/Flutter/Release/Flutter.xcframework" "$PACKAGE_DIR/Frameworks/Flutter.xcframework"
cp -R "$PROJECT_ROOT/ios_sdk_distribution/Sources" "$PACKAGE_DIR/Sources"
cp "$PROJECT_ROOT/ios_sdk_distribution/Package.swift" "$PACKAGE_DIR/Package.swift"
cp "$PROJECT_ROOT/ios_sdk_distribution/NossoFlutterSDK.podspec" "$PACKAGE_DIR/NossoFlutterSDK.podspec"
cp "$PROJECT_ROOT/ios_sdk_distribution/README.md" "$PACKAGE_DIR/README.md"

cd "$DIST_ROOT"
/usr/bin/zip -qry "NossoFlutterSDK-$VERSION.zip" "NossoFlutterSDK-$VERSION"

echo "$ZIP_PATH"
