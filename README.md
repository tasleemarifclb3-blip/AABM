# Al Amin

Al Amin is a Flutter-based accounting and ledger application.

## Project

This repository contains the Flutter source code for the Al Amin application.

Main areas of the application include:

- User authentication and user management
- Super-user / administrator management
- Qarza and other transaction types
- Transaction approval workflow
- Local data storage
- Firebase synchronization
- Offline operation and synchronization
- Reports and data management
- Backup and restore
- Flutter Web support

## Running locally

Make sure Flutter is installed and available in your terminal.

```bash
flutter pub get
flutter analyze
flutter run
```

To run the web version:

```bash
flutter run -d chrome
```

## Building the web version

```bash
flutter build web --release
```

## Git workflow

Before making a major change:

```bash
git status
git add .
git commit -m "Checkpoint: working version"
git push
```

Keep `main` as a stable version whenever possible.

## GitHub Actions

The repository contains a GitHub Actions workflow under:

`.github/workflows/flutter_web.yml`

The workflow checks the Flutter project and builds the web application. It is intended to support deployment to GitHub Pages.

## Important

Do not commit real production credentials, private keys, service-account JSON files, or other secrets to a public repository.

This repository should normally be kept **Private** for the Al Amin project.
