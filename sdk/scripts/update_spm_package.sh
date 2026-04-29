#!/bin/sh
set -e

VERSION="${1:-}"
CONFIGURATION="${2:-Debug}"
SDK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$SDK_ROOT/.." && pwd)"
PACKAGE_SWIFT="$REPO_ROOT/Package.swift"
DIST_ROOT="$SDK_ROOT/build/ios-spm-release"
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

if git -C "$REPO_ROOT" rev-parse "$VERSION" >/dev/null 2>&1; then
  echo "A tag $VERSION ja existe. Use uma nova versao para nao quebrar consumidores existentes." >&2
  exit 1
fi

"$SDK_ROOT/scripts/build_flutter_ios_frameworks.sh"
"$SDK_ROOT/scripts/package_ios_spm_binaries.sh" "$VERSION" "$CONFIGURATION"

APP_ZIP="NossoFlutterSDK-App-$CONFIGURATION-$VERSION.zip"
FLUTTER_ZIP="NossoFlutterSDK-Flutter-$CONFIGURATION-$VERSION.zip"
APP_ZIP_PATH="$DIST_ROOT/$APP_ZIP"
FLUTTER_ZIP_PATH="$DIST_ROOT/$FLUTTER_ZIP"

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
