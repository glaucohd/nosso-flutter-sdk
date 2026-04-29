#!/bin/sh
set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_ROOT/flutter_module"
flutter build ios-framework --output="$PROJECT_ROOT/build/ios-frameworks"
