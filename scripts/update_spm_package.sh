#!/bin/sh
set -e

VERSION="${1:-}"
CONFIGURATION="${2:-Debug}"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGE_SWIFT="$PROJECT_ROOT/Package.swift"
FRAMEWORKS_ROOT="$PROJECT_ROOT/build/ios-frameworks/$CONFIGURATION"
DIST_ROOT="$PROJECT_ROOT/build/ios-spm-release"
REPOSITORY_URL="https://github.com/glaucohd/nosso-flutter-sdk"

case "$VERSION" in
  "")
    echo "Uso: $0 <versao> [Debug|Release]" >&2
    exit 1
    ;;
esac

case "$CONFIGURATION" in
  Debug|Release) ;;
  *)
    echo "Uso: $0 <versao> [Debug|Release]" >&2
    exit 1
    ;;
esac

if git -C "$PROJECT_ROOT" rev-parse "$VERSION" >/dev/null 2>&1; then
  echo "A tag $VERSION ja existe. Use uma nova versao para nao quebrar consumidores existentes." >&2
  exit 1
fi

cd "$PROJECT_ROOT/flutter_module"
flutter pub get
flutter build ios-framework --output="$PROJECT_ROOT/build/ios-frameworks"

APP_ZIP="NossoFlutterSDK-App-$CONFIGURATION-$VERSION.zip"
FLUTTER_ZIP="NossoFlutterSDK-Flutter-$CONFIGURATION-$VERSION.zip"
APP_ZIP_PATH="$DIST_ROOT/$APP_ZIP"
FLUTTER_ZIP_PATH="$DIST_ROOT/$FLUTTER_ZIP"

mkdir -p "$DIST_ROOT"
rm -f "$APP_ZIP_PATH" "$FLUTTER_ZIP_PATH"

cd "$FRAMEWORKS_ROOT"
/usr/bin/zip -qry "$APP_ZIP_PATH" "App.xcframework"
/usr/bin/zip -qry "$FLUTTER_ZIP_PATH" "Flutter.xcframework"

APP_CHECKSUM="$(swift package compute-checksum "$APP_ZIP_PATH")"
FLUTTER_CHECKSUM="$(swift package compute-checksum "$FLUTTER_ZIP_PATH")"

APP_URL="$REPOSITORY_URL/releases/download/$VERSION/$APP_ZIP"
FLUTTER_URL="$REPOSITORY_URL/releases/download/$VERSION/$FLUTTER_ZIP"

sed -i '' \
  -e "s|url: \"$REPOSITORY_URL/releases/download/[^\"]*/NossoFlutterSDK-Flutter-[^\"]*\"|url: \"$FLUTTER_URL\"|" \
  -e "s|url: \"$REPOSITORY_URL/releases/download/[^\"]*/NossoFlutterSDK-App-[^\"]*\"|url: \"$APP_URL\"|" \
  -e "/name: \"Flutter\"/,/)/ s|checksum: \"[^\"]*\"|checksum: \"$FLUTTER_CHECKSUM\"|" \
  -e "/name: \"App\"/,/)/ s|checksum: \"[^\"]*\"|checksum: \"$APP_CHECKSUM\"|" \
  "$PACKAGE_SWIFT"

echo "Package.swift atualizado:"
echo "  Flutter: $FLUTTER_URL"
echo "  Flutter checksum: $FLUTTER_CHECKSUM"
echo "  App: $APP_URL"
echo "  App checksum: $APP_CHECKSUM"
