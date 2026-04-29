#!/bin/sh
set -e

VERSION="${1:-1.0.0}"
CONFIGURATION="${2:-Release}"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FRAMEWORKS_ROOT="$PROJECT_ROOT/poc/Flutter"
DIST_ROOT="$PROJECT_ROOT/build/ios-sdk-release"

case "$CONFIGURATION" in
  Debug|Release|all) ;;
  *)
    echo "Uso: $0 <versao> [Debug|Release|all]" >&2
    exit 1
    ;;
esac

package_configuration() {
  local configuration="$1"
  local package_name="NossoFlutterSDK-$configuration-$VERSION"
  local package_dir="$DIST_ROOT/$package_name"
  local zip_path="$DIST_ROOT/$package_name.zip"

  rm -rf "$package_dir" "$zip_path"
  mkdir -p "$package_dir/Frameworks"

  cp -R "$FRAMEWORKS_ROOT/$configuration/App.xcframework" "$package_dir/Frameworks/App.xcframework"
  cp -R "$FRAMEWORKS_ROOT/$configuration/Flutter.xcframework" "$package_dir/Frameworks/Flutter.xcframework"
  cp -R "$PROJECT_ROOT/ios_sdk_distribution/Sources" "$package_dir/Sources"
  cp "$PROJECT_ROOT/ios_sdk_distribution/Package.swift" "$package_dir/Package.swift"
  cp "$PROJECT_ROOT/ios_sdk_distribution/NossoFlutterSDK.podspec" "$package_dir/NossoFlutterSDK.podspec"
  cp "$PROJECT_ROOT/ios_sdk_distribution/README.md" "$package_dir/README.md"

  cd "$DIST_ROOT"
  /usr/bin/zip -qry "$package_name.zip" "$package_name"

  echo "$zip_path"
}

cd "$PROJECT_ROOT/flutter_module"
flutter pub get
flutter build ios-framework --output="$FRAMEWORKS_ROOT"

mkdir -p "$DIST_ROOT"

if [ "$CONFIGURATION" = "all" ]; then
  package_configuration Debug
  package_configuration Release
else
  package_configuration "$CONFIGURATION"
fi
