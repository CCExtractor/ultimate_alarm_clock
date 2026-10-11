# Contributing to Ultimate Alarm Clock

Thank you for considering contributing to the Ultimate Alarm Clock project! Your contributions are valuable and help make the application even better.



## Prerequisites
Before getting started, ensure you have the following prerequisites installed on your system:

- [Flutter](https://flutter.dev/docs/get-started/install): This project is pinned to **Flutter 3.22.2** (Dart 3.4.3) in `pubspec.yaml`, `.fvmrc`, and CI. Install that version rather than the latest release, or use [FVM](https://fvm.app/) (the repo ships a `.fvmrc`, so `fvm install && fvm use` selects the correct version automatically).

- [Git](https://git-scm.com/downloads): Version control tool to clone the project's repository.

- A code editor such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with Flutter and Dart plugins.

## How to Contribute

1. **Fork the Repository**: Start by forking the project's repository to your GitHub account.

2. **Clone the Repository**: Clone the forked repository to your local development environment using the following command:

    ```bash
    git clone https://github.com/your-username/ultimate_alarm_clock.git
    ```

3. **Install Dependencies**: Fetch the project's packages (make sure the Flutter 3.22.2 toolchain is active first):

    ```bash
    cd ultimate_alarm_clock
    flutter pub get
    ```

4. **Create a Branch**: Create a new branch for your contributions, giving it a descriptive name.

    ```bash
    git checkout -b your-feature-name
    ```

5. **Make Changes**: Make your desired changes, improvements, or bug fixes in your local environment.

6. **Test**: Ensure that your changes do not introduce new issues and do not break existing features. Test your code thoroughly, and run the analyzer and test suite before committing:

    ```bash
    flutter analyze
    flutter test
    ```

    Note that CI (`.github/workflows/flutter.yml`) only builds a debug APK on pushes to `main`/`next`, so it does not gate pull requests. Please run the commands above locally.

7. **Documentation**: If your changes impact the user interface, configuration, or functionality, update the documentation to reflect the changes.

8. **Commit**:

- **Activate pre-commit hooks (one-time process):** We strongly recommend activating the pre-commit hooks to ensure code consistency. Follow the instructions in the [Activating Pre-Commit Hooks](#activating-pre-commit-hooks) section. This is a one-time setup process, so you only need to do it once on your local machine.

- Commit your changes with a clear and concise message:

    ```bash
    git commit -m "Add feature/fix: Describe your changes here"
    ```

9. **Push Changes**: Push your changes to your GitHub fork.

    ```bash
    git push origin your-feature-name
    ```

10. **Pull Request**: Create a Pull Request (PR) from your fork to the original repository. Ensure your PR has a clear title and description outlining the changes.

11. **Code Review**: Your PR will undergo code review. Make any necessary adjustments based on feedback.

12. **Merge**: Once your PR is approved, it will be merged into the main project repository.

## Activating Pre-Commit Hooks

To ensure code consistency and improved code readability, we have implemented pre-commit hooks that automatically format your Dart code before each commit. To activate these hooks:

### Linux / macOS (or Git Bash)

1. **Make the hook script executable:**

    ```bash
    chmod +x .github/hooks/pre_commit.sh
    ```

2. **Create a symbolic link to the hook:**

    ```bash
    ln -s ../../.github/hooks/pre_commit.sh .git/hooks/pre-commit
    ```

### Windows (PowerShell)

Run these commands from the repository root:

```powershell
New-Item -ItemType SymbolicLink -Path .git/hooks/pre-commit -Target (Resolve-Path .github/hooks/pre_commit.sh)
```

Creating a symbolic link on Windows may require enabling Developer Mode or running the shell as Administrator. If you get a permissions error, use Git Bash with the Linux/macOS instructions above, or the wrapper-hook alternative below.

### Alternative: wrapper hook (all platforms)

If creating the symlink is not practical on your system, use a small wrapper hook instead. Create `.git/hooks/pre-commit` with the following contents:

```bash
#!/usr/bin/env bash
exec "$(git rev-parse --show-toplevel)/.github/hooks/pre_commit.sh"
```

Then make it executable:

- **Linux / macOS:** `chmod +x .git/hooks/pre-commit`
- **Windows:** no extra step is needed — Git for Windows runs hooks with its bundled Bash, so the `#!/usr/bin/env bash` shebang is enough.

## Reporting Issues

If you find a bug or have a suggestion for improvement, please create an [issue](https://github.com/CCExtractor/ultimate_alarm_clock/issues/new) on the project's GitHub repository. Be sure to include a clear and detailed description of the problem or enhancement.

We appreciate your contributions to the Ultimate Alarm Clock project, and your help is invaluable in making it even better.

If you have any questions regarding something in the project, do not hesitate to ask :)

## Guidelines

- Be respectful and considerate when contributing and interacting with the community.
- Follow the project's coding style, conventions, and best practices.
- Keep your PR focused on a single issue or feature. If you wish to contribute multiple changes, create separate branches and PRs for each.
- Provide a detailed and clear description of your PR, including the purpose of the changes and any related issues.
- Ensure that your code is well-documented and that any new features or changes are reflected in the project's documentation.
- Make sure your contributions do not introduce security vulnerabilities or cause regressions.
