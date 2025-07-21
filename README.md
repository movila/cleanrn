# 🧼 cleanrn

A fast and safe CLI tool to clean up your React Native project — removes build artifacts, node modules, caches, and Hermes binaries — all with one command.

## 🚀 Features

- Deletes `node_modules`, build folders, iOS Pods, and Gradle caches
- Cleans Watchman and Metro bundler caches
- Optional `--dry-run` mode to preview deletions
- Optional `--force` mode to skip confirmation
- Great for freeing up disk space or preparing a repo for zip/commit

---

## 📦 Installation & Usage

### 🔹 One-time use with `npx` (recommended)
```bash
npx cleanrn
