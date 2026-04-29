#!/bin/sh
set -e

VERSION="${1:-1.0.0}"
CONFIGURATION="${2:-Debug}"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FRAMEWORKS_ROOT="$PROJECT_ROOT/build/ios-frameworks/$CONFIGURATION"
DIST_ROOT="$PROJECT_ROOT/build/ios-spm-release"

case "$CONFIGURATION" in
  Debug|Release) ;;
  *)
    echo "Uso: $0 <versao> [Debug|Release]" >&2
    exit 1
    ;;
esac

if [ ! -d "$FRAMEWORKS_ROOT/App.xcframework" ] || [ ! -d "$FRAMEWORKS_ROOT/Flutter.xcframework" ]; then
  echo "Frameworks nao encontrados em $FRAMEWORKS_ROOT" >&2
  echo "Rode primeiro: flutter build ios-framework --output=\"$PROJECT_ROOT/build/ios-frameworks\"" >&2
  exit 1
fi

mkdir -p "$DIST_ROOT"

package_framework() {
  local framework_name="$1"
  local zip_name="NossoFlutterSDK-$framework_name-$CONFIGURATION-$VERSION.zip"
  local zip_path="$DIST_ROOT/$zip_name"

  rm -f "$zip_path"

  cd "$FRAMEWORKS_ROOT"
  /usr/bin/zip -qry "$zip_path" "$framework_name.xcframework"

  echo "$zip_path"
  swift package compute-checksum "$zip_path"
}

package_framework App
package_framework Flutter
