#!/bin/bash
# cleanrn.sh - A lightweight script to clean React Native project artifacts.
# Author: movila
# GitHub: https://github.com/movila/cleanrn
# Version: 1.0.0
if [ ! -f "package.json" ] || ! grep -q "react-native" package.json; then
  echo "❌ Not a React Native project (no package.json or react-native dependency found)."
  exit 1
fi

if [[ "$1" == "--dry-run" ]]; then
  cat <<EOF
🧪 Dry run: the following will be removed if confirmed:

  - node_modules/
  - \$TMPDIR/metro-*
  - ios/build/
  - ios/Pods/
  - ios/Podfile.lock
  - ios/.xcworkspace
  - android/.gradle/
  - android/app/build/
  - android/build/
  - android/.idea/
  - android/local.properties
  - *.log
  - coverage/

EOF
exit 0
fi

if [[ "$1" != "--force" ]]; then
  read -p "Are you sure you want to clean this React Native project? (y/N): " confirm
  if [[ "$confirm" != "y" ]]; then
    echo "❌ Clean aborted."
    exit 1
  fi
fi

echo "🔧 Cleaning React Native project..."

# 1. Remove node_modules
echo "🧹 Removing node_modules..."
rm -rf node_modules

# 2. Remove metro, watchman caches (optional)
echo "🧹 Cleaning cache (metro, watchman)..."
rm -rf "$TMPDIR"/metro-*
if command -v watchman >/dev/null 2>&1; then
  watchman watch-del-all 2>/dev/null
fi

# 3. Remove iOS build artifacts
if [ -d "ios" ]; then
  echo "🧹 Cleaning iOS builds, pods..."
  rm -rf ios/build
  rm -rf ios/Pods
  rm -f ios/Podfile.lock
  rm -rf ios/.xcworkspace
fi

# 4. Remove Android build artifacts
if [ -d "android" ]; then
  echo "🧹 Cleaning Android builds and gradle..."
  rm -rf android/.gradle
  rm -rf android/app/build
  rm -rf android/build
  rm -rf android/.idea
  rm -rf android/local.properties
fi

# 5. Optional: Remove logs, coverage
echo "🧹 Removing logs and coverage..."
rm -rf coverage
rm -rf *.log

echo "✅ Project cleaned. You can now zip or commit safely."

# Optional zip (uncomment if needed)
# echo "📦 Zipping project..."
# zip -r cleaned-project.zip . -x "node_modules/*" "ios/Pods/*" "android/app/build/*" "android/.gradle/*" "*.log" "coverage/*"