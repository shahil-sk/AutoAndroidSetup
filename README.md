# Android Security Tools Setup Script

This script automates the setup and installation of various Android security tools commonly used for mobile security testing, reverse engineering, and analysis. The script installs tools like Drozer, Frida, Objection, ApkLeaks, reFlutter, JADX, APKTool, Docker with MobSF, and other essential packages.

## Tools Included

This setup installs the following tools:

1. **Drozer Agent**: A powerful framework for security testing Android applications.
2. **Frida-tools**: Dynamic instrumentation toolkit for developers, reverse engineers, and security researchers.
3. **Objection Tool**: A runtime mobile exploration toolkit for Android and iOS.
4. **ApkLeaks**: A tool for detecting sensitive information leaks in Android APKs.
5. **reFlutter**: A tool for reverse-engineering Flutter applications.
6. **OpenJDK 11**: The Java Development Kit, essential for building and working with Android applications.
7. **JADX**: A tool for decompiling Android APK files to readable Java source code.
8. **APKTool**: A tool for reverse engineering Android APK files.
9. **Docker & MobSF Image**: MobSF (Mobile Security Framework) for static and dynamic analysis of Android/iOS apps.

## Requirements

- **Ubuntu/Debian-based Linux distribution** is recommended.
- **Root privileges** are required for installing some packages.
- **Internet connection** is required to download tools and dependencies.

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-username/Android-Security-Tools-Setup.git
cd Android-Security-Tools-Setup
