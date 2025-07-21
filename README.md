# cleanrn 🧹

A lightweight CLI tool to clean React Native project artifacts quickly and safely.

## Why cleanrn?

React Native projects accumulate build artifacts, cache files, and dependencies that can:
- Take up gigabytes of disk space
- Cause mysterious build issues
- Make projects difficult to zip or share
- Slow down your development workflow

`cleanrn` removes all these artifacts in one command, giving you a fresh, clean project ready for distribution or troubleshooting.

## Installation

### Global Installation (Recommended)
```bash
npm install -g cleanrn
```

### One-time Usage (No Installation)
```bash
npx cleanrn
```

## Usage

Navigate to your React Native project directory and run:

```bash
cleanrn
```

### Available Options

| Option | Description |
|--------|-------------|
| `--dry-run` | Preview what will be cleaned without actually removing anything |
| `--force` | Skip confirmation prompt and clean immediately |
| `--verbose` | Show detailed output of what's being removed |
| `--help, -h` | Show help information |
| `--version, -v` | Show version number |

### Examples

```bash
# Interactive clean (default)
cleanrn

# Preview what will be cleaned
cleanrn --dry-run

# Clean without confirmation
cleanrn --force

# Clean with detailed output
cleanrn --verbose

# Combine options
cleanrn --force --verbose
```

## What Gets Cleaned

### 📁 Dependencies & Cache
- `node_modules/` - All installed packages
- `$TMPDIR/metro-*` - Metro bundler cache
- Watchman watches (if Watchman is installed)

### 📱 iOS Artifacts
- `ios/build/` - Xcode build outputs
- `ios/Pods/` - CocoaPods dependencies
- `ios/Podfile.lock` - CocoaPods lock file
- `ios/DerivedData/` - Xcode derived data
- `ios/.xcode.env.local` - Local Xcode environment

### 🤖 Android Artifacts
- `android/.gradle/` - Gradle cache and build files
- `android/app/build/` - App build outputs
- `android/build/` - Project build outputs
- `android/.idea/` - Android Studio/IntelliJ files
- `android/local.properties` - Local Android SDK paths
- `android/app/src/main/assets/index.android.bundle` - Bundled assets

### 🧹 General Cleanup
- `*.log` - All log files
- `npm-debug.log*` - NPM debug logs
- `yarn-debug.log*` - Yarn debug logs
- `yarn-error.log*` - Yarn error logs
- `coverage/` - Test coverage reports
- `.nyc_output/` - NYC coverage tool output
- `.expo/` - Expo cache (for Expo projects)

## Safety Features

- ✅ **Project Detection**: Only runs in actual React Native projects
- ✅ **Confirmation Prompt**: Asks before cleaning (unless `--force` is used)
- ✅ **Dry Run Mode**: Preview changes before executing
- ✅ **Smart Detection**: Handles missing files gracefully
- ✅ **Clear Feedback**: Shows exactly what was cleaned

## Sample Output

```bash
$ cleanrn

This will clean your React Native project by removing:
• Dependencies (node_modules)
• Build artifacts (iOS/Android builds)
• Cache files (Metro, Watchman)
• Log files and coverage reports

Are you sure you want to continue? (y/N): y
🔧 Starting React Native project cleanup...
🧹 Cleaning dependencies...
🧹 Cleaning cache...
🧹 Cleaning iOS artifacts...
🧹 Cleaning Android artifacts...
🧹 Cleaning logs and miscellaneous files...

✅ Cleaned 5 items. Project is ready for distribution or fresh install.

📋 Items that were cleaned:
  • node_modules
  • ios/Pods
  • ios/build
  • android/.gradle
  • coverage

🔧 Next steps:
  • Run 'npm install' or 'yarn install' to restore dependencies
  • For iOS: 'cd ios && pod install' (if using CocoaPods)
  • Consider running 'npx react-native start --reset-cache' for a fresh start
```

## When to Use cleanrn

### 🐛 Troubleshooting
- Mysterious build errors
- Metro bundler issues
- Cache-related problems
- "It works on my machine" scenarios

### 📦 Project Distribution
- Before zipping projects
- Before committing to version control
- Before sharing with team members
- Before archiving projects

### 🧹 Maintenance
- Regular cleanup to free disk space
- Before major dependency updates
- After switching between branches with different dependencies

## Requirements

- **Bash shell** (available on macOS, Linux, WSL, Git Bash)
- **React Native project** (detects via `package.json`)

## Compatibility

- ✅ macOS
- ✅ Linux
- ✅ Windows (via WSL, Git Bash, or similar)
- ✅ Works with npm and Yarn
- ✅ Compatible with Expo projects
- ✅ Supports TypeScript React Native projects

## Contributing

Issues and pull requests are welcome on [GitHub](https://github.com/movila/cleanrn).

## License

MIT © [movila](https://github.com/movila)

---

**💡 Pro Tip**: Add `cleanrn` to your development workflow - run it whenever you encounter mysterious build issues or before sharing your project!