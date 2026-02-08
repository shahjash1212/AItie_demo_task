# AItie Demo Task

A Flutter assignment demonstrating a scalable, well-architected e-commerce application for the senior developer position.

---

## Prerequisites

- **Flutter**: 3.38.9
- **Dart**: 3.10.8

## How to Run the Project

```bash
flutter run
```

That's it! The app will compile and launch on your connected device or emulator.

---

## How to Install

### Build APK for Android

Run the following command to build a release APK:

```bash
flutter build apk --release
```

The APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

Install it on your Android device by transferring the APK or using adb.

### Enable Deep Linking (Android)

This app supports deep linking on Android. To enable it:

1. Open **App Info** on your Android device
2. Navigate to **"Open by default"** section
3. Select the added link to enable deep linking

### Troubleshooting Installation Issues

If you encounter installation problems:

1. Go to **Google Play Store** settings
2. Disable **Play Protect** option
3. Try installing the APK again

---

## App Architecture Overview

The project follows **Clean Architecture** with clear separation of concerns:

```
lib/
├── presentation/   → UI Layer (Screens, Widgets, BLoCs)
├── domain/        → Business Logic (Use Cases, Entities, Repositories)
└── data/          → Data Layer (Models, Data Sources, Repository Implementations)
```

**Flow**: UI → BLoC → Use Cases → Repositories → Data Sources (API/Local Database)

This architecture ensures:
- Testability and maintainability
- Easy feature scaling
- Clear dependency flow
- Decoupled layers

---

## State Management: BLoC Pattern

**Why BLoC?**
- **Scalability**: Handles complex state transitions smoothly
- **Testability**: Pure functions, easy to unit test
- **Separation of Concerns**: UI is independent of business logic
- **Industry Standard**: Widely adopted in professional Flutter teams

**Implementation**: Uses `flutter_bloc` package for event-driven state management.

---

## Key Technologies

| Technology | Purpose |
|-----------|---------|
| **flutter_bloc** | State management |
| **go_router** | Route navigation |
| **dio** | HTTP API requests |
| **sqflite** | Local database storage |
| **cached_network_image** | Efficient image caching |
| **connectivity_plus** | Network connectivity detection |
| **shared_preferences** | Lightweight key-value storage |

---

## Decisions & Trade-offs

| Decision | Justification |
|----------|---------------|
| **Clean Architecture** | Provides structure for scalable projects; some overhead for small apps |
| **BLoC over GetX/Provider** | More boilerplate but better for team collaboration and long-term maintenance |
| **go_router for Navigation** | Type-safe, declarative routing; replaces older Navigator 1.0 pattern |
| **sqflite + Dio** | Reliable offline support + modern API communication |
| **Cached Network Images** | Performance optimization; reduces redundant network calls |

---

## Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| **Offline State Management** | Implemented connectivity listener with cached data fallback |
| **API Error Handling** | Centralized error handling in BLoCs with user-friendly error messages |
| **State Persistence** | Used shared_preferences for user preferences and sqflite for complex data |
| **Network Timeouts** | Configured Dio with retry logic and appropriate timeout values |
| **Image Loading Performance** | Used cached_network_image to optimize image rendering |

---

## Project Structure

```
lib/
├── main.dart                 → App entry point
├── presentation/
│   ├── home/                → Home feature
│   ├── cart/                → Cart feature
│   ├── favorite/            → Favorites feature
│   └── routing/             → Route configuration
├── domain/
│   ├── entities/            → Core business objects
│   ├── repositories/        → Abstract repository interfaces
│   └── use_cases/           → Business logic
├── data/
│   ├── models/              → API data models
│   ├── data_sources/        → Remote & local data sources
│   └── repositories/        → Repository implementations
├── constants/               → App-wide constants & utilities
└── utils/                   → Helper functions & widgets
```

---

## Notes

- State is managed efficiently with BLoC, minimizing unnecessary rebuilds
- The app supports offline functionality with local caching
- Network connectivity is monitored and communicated to users
- All API calls are handled with proper error management
