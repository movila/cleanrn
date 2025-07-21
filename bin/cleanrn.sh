#!/bin/bash
# cleanrn.sh - A lightweight script to clean React Native project artifacts.
# Author: movila
# GitHub: https://github.com/movila/cleanrn
# Version: 1.1.0

set -e  # Exit on any error

# Color codes for enhanced output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emoji-based output functions with optional colors
print_status() {
    echo -e "${BLUE}🔧${NC} $1"
}

print_success() {
    echo "✅ $1"
}

print_error() {
    echo "❌ $1"
}

print_warning() {
    echo "⚠️ $1"
}

# Colored section headers for dry-run
print_section() {
    echo -e "${CYAN}$1${NC}"
}

# Function to show help
show_help() {
    cat <<EOF
cleanrn - Clean React Native project artifacts

USAGE:
    cleanrn [OPTIONS]

OPTIONS:
    --dry-run       Show what would be cleaned without actually doing it
    --force         Skip confirmation prompt
    --help, -h      Show this help message
    --version, -v   Show version information
    --verbose       Show detailed output

EXAMPLES:
    cleanrn                    # Interactive clean
    cleanrn --dry-run         # Preview what will be cleaned
    cleanrn --force           # Clean without confirmation
    cleanrn --verbose         # Clean with detailed output

EOF
}

# Function to show version
show_version() {
    echo "cleanrn version 1.1.0"
}

# Parse command line arguments
DRY_RUN=false
FORCE=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        --version|-v)
            show_version
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

# Check if this is a React Native project
if [ ! -f "package.json" ]; then
    print_error "No package.json found. Are you in a React Native project directory?"
    exit 1
fi

if ! grep -q "react-native\|@react-native" package.json; then
    print_error "This doesn't appear to be a React Native project (no react-native dependency found)."
    exit 1
fi

# Function to remove directory/file with verbose output
remove_item() {
    local item="$1"
    local description="$2"
    
    if [ -e "$item" ]; then
        if [ "$VERBOSE" = true ]; then
            echo "  Removing: $item"
        fi
        rm -rf "$item"
        return 0
    else
        if [ "$VERBOSE" = true ]; then
            echo "  Not found: $item (skipping)"
        fi
        return 1
    fi
}

# Dry run mode
if [ "$DRY_RUN" = true ]; then
    cat <<EOF
🧪 Dry run: The following items will be removed if they exist:

$(print_section "📁 Dependencies & Cache:")
  - node_modules/
  - \$TMPDIR/metro-*
  - yarn.lock (if using npm)
  - package-lock.json (if using yarn)

$(print_section "📱 iOS artifacts:")
  - ios/build/
  - ios/Pods/
  - ios/Podfile.lock
  - ios/DerivedData/
  - ios/.xcode.env.local

$(print_section "🤖 Android artifacts:")
  - android/.gradle/
  - android/app/build/
  - android/build/
  - android/.idea/
  - android/local.properties
  - android/app/src/main/assets/index.android.bundle

$(print_section "🧹 General cleanup:")
  - *.log
  - npm-debug.log*
  - yarn-debug.log*
  - yarn-error.log*
  - coverage/
  - .nyc_output/
  - .expo/
  - .vscode/settings.json (if exists)

EOF
    exit 0
fi

# Confirmation prompt (unless --force is used)
if [ "$FORCE" != true ]; then
    echo "This will clean your React Native project by removing:"
    echo "• Dependencies (node_modules)"
    echo "• Build artifacts (iOS/Android builds)"
    echo "• Cache files (Metro, Watchman)"
    echo "• Log files and coverage reports"
    echo
    read -p "Are you sure you want to continue? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        print_warning "Clean operation cancelled."
        exit 0
    fi
fi

print_status "Starting React Native project cleanup..."

# Track what was actually cleaned
cleaned_items=0

# 1. Remove node_modules and lock files
echo "🧹 Cleaning dependencies..."
if remove_item "node_modules" "Node modules"; then
    ((cleaned_items++))
fi

# Handle conflicting lock files
if [ -f "yarn.lock" ] && [ -f "package-lock.json" ]; then
    print_warning "Both yarn.lock and package-lock.json found. Consider removing one."
fi

# 2. Clean cache
echo "🧹 Cleaning cache..."
if [ -n "$TMPDIR" ]; then
    for metro_cache in "$TMPDIR"/metro-*; do
        if [ -d "$metro_cache" ]; then
            if remove_item "$metro_cache" "Metro cache"; then
                ((cleaned_items++))
            fi
        fi
    done
fi

# Watchman cache
if command -v watchman >/dev/null 2>&1; then
    if [ "$VERBOSE" = true ]; then
        echo "  Clearing watchman watches..."
    fi
    if watchman watch-del-all >/dev/null 2>&1; then
        ((cleaned_items++))
    fi
fi

# 3. iOS cleanup
if [ -d "ios" ]; then
    echo "🧹 Cleaning iOS artifacts..."
    ios_items=(
        "ios/build"
        "ios/Pods" 
        "ios/Podfile.lock"
        "ios/DerivedData"
        "ios/.xcode.env.local"
    )
    
    for item in "${ios_items[@]}"; do
        if remove_item "$item" "iOS artifact"; then
            ((cleaned_items++))
        fi
    done
fi

# 4. Android cleanup
if [ -d "android" ]; then
    echo "🧹 Cleaning Android artifacts..."
    android_items=(
        "android/.gradle"
        "android/app/build"
        "android/build" 
        "android/.idea"
        "android/local.properties"
        "android/app/src/main/assets/index.android.bundle"
    )
    
    for item in "${android_items[@]}"; do
        if remove_item "$item" "Android artifact"; then
            ((cleaned_items++))
        fi
    done
fi

# 5. General cleanup
echo "🧹 Cleaning logs and miscellaneous files..."
general_items=(
    "coverage"
    ".nyc_output"
    ".expo"
    "npm-debug.log"
    "yarn-debug.log" 
    "yarn-error.log"
)

# Clean up any .log files
for log_file in *.log; do
    if [ -f "$log_file" ]; then
        if remove_item "$log_file" "Log file"; then
            ((cleaned_items++))
        fi
    fi
done

for item in "${general_items[@]}"; do
    if remove_item "$item" "General cleanup"; then
        ((cleaned_items++))
    fi
done

# Final summary
echo
if [ $cleaned_items -eq 0 ]; then
    print_warning "No items were found to clean. Project might already be clean!"
else
    print_success "Cleaned $cleaned_items items. Project is ready for distribution or fresh install."
fi

print_status "Next steps:"
echo "  • Run 'npm install' or 'yarn install' to restore dependencies"
echo "  • For iOS: 'cd ios && pod install' (if using CocoaPods)"
echo "  • Consider running 'npx react-native start --reset-cache' for a fresh start"