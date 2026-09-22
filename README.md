# Automated Node.js/TypeScript Executable Builder 🚀

A set of cross-platform automation scripts designed to build, compile, and package Node.js and TypeScript projects into standalone executable files using `pkg`.

## 🌟 Features

- 📂 **Interactive Directory Selection:** Asks for the target project path at runtime.
- ⚙️ **Automatic Project Setup:** Initializes `package.json` if missing.
- 🟦 **TypeScript Support:** Automatically detects TypeScript projects and handles compilation (`tsc`).
- 📦 **Dependency Management:** Automatically installs required local dev dependencies (`pkg`, `typescript`).
- 🎯 **Smart Entry Point Detection:** Checks `package.json`'s `main` entry, `dist/index.js`, `dist/app.js`, or prompts if unidentifiable.
- 🔨 **Multi-Platform Support:** Dedicated scripts tailored for Windows, macOS, and Linux.

---

## 💻 Choosing the Right Script for Your OS

| Operating System | Script File      | Target Binary Output |
| :--------------- | :--------------- | :------------------- |
| **Windows**      | `build-exe.ps1`  | `bin/app.exe`        |
| **macOS**        | `build-mac.sh`   | `bin/app-macos`      |
| **Linux**        | `build-linux.sh` | `bin/app-linux`      |

---

## 📋 Prerequisites

Before running any script, make sure you have:

- [Node.js](https://nodejs.org/) (v16 or higher recommended) installed.
- **Windows:** PowerShell (installed by default).
- **macOS / Linux:** Bash terminal environment.

---

## 🚀 How to Use

### 🪟 On Windows

1. Open PowerShell and run:
   ```powershell
   .\build-exe.ps1
   ```
2. Enter the absolute path to your project when prompted:
   ```text
   Digite o caminho absoluto da pasta do projeto: C:\Users\YourName\Projects\my-node-app
   ```
3. Your executable will be available at `<Your-Project-Path>\bin\app.exe`.

---

### 🍎 On macOS

1. Make the script executable (only needed once):
   ```bash
   chmod +x build-mac.sh
   ```
2. Run the script:
   ```bash
   ./build-mac.sh
   ```
3. Enter the absolute path when prompted:
   ```text
   Digite o caminho absoluto da pasta do projeto: /Users/yourname/projects/my-node-app
   ```
4. Your executable will be available at `<Your-Project-Path>/bin/app-macos`.

---

### 🐧 On Linux

1. Make the script executable (only needed once):
   ```bash
   chmod +x build-linux.sh
   ```
2. Run the script:
   ```bash
   ./build-linux.sh
   ```
3. Enter the absolute path when prompted:
   ```text
   Digite o caminho absoluto da pasta do projeto: /home/yourname/projects/my-node-app
   ```
4. Your executable will be available at `<Your-Project-Path>/bin/app-linux`.

---

## 🛠️ How It Works

1. **Path Validation:** Verifies that the provided directory exists and resolves relative paths or trailing slashes.
2. **Dependency Check:** Checks for `package.json` and installs `pkg` (and `typescript` if `.ts` files or `tsconfig.json` exist).
3. **Build Step:**
   - Runs `npm run build` if a build script exists in `package.json`.
   - Otherwise, executes `npx tsc` if TypeScript is detected.
4. **Packaging:** Runs `npx pkg` targeting the current platform (`node18-win-x64`, `node18-macos-x64`/`arm64`, or `node18-linux-x64`) to compile the app into a standalone binary.

---

## 📝 License

This project is licensed under the [MIT License](LICENSE).
