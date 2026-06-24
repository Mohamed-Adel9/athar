# Athar

Athar is an Arabic-first, right-to-left Flutter e-commerce app for browsing, customizing, and ordering branded products. It combines a storefront and checkout flow with an interactive product designer for adding text, images, and stickers to products such as T-shirts, hoodies, mugs, tote bags, and phone cases.

## Features

- Arabic RTL interface with light and dark themes
- Splash screen, onboarding, login, registration, and logout
- Product catalog with categories, sorting, grid/list views, and product details
- Product colors, sizes, quantities, ratings, reviews, and discounts
- Wishlist management
- Shopping cart with quantity controls and promo codes
- Multi-step checkout with shipping and payment selection
- User profile and settings
- Admin screen
- Custom product designer with:
  - Product and template selection
  - Text, image, and sticker layers
  - Layer ordering, visibility, locking, movement, resizing, and rotation
  - Text styling
  - Canvas zoom, rotation, grid guides, preview mode, undo, and redo

## Screens

The app currently provides routes for:

| Route | Screen |
| --- | --- |
| `/splash` | Splash |
| `/onboarding` | Onboarding |
| `/login` | Authentication |
| `/home` | Main storefront |
| `/wishlist` | Wishlist |
| `/designer` | Product designer |
| `/cart` | Shopping cart |
| `/checkout` | Checkout |
| `/profile` | User profile |
| `/admin` | Admin |

## Tech Stack

- Flutter and Dart
- `flutter_bloc` for state management
- `go_router` for navigation
- `dio` for HTTP requests
- `get_it` for dependency injection
- `flutter_secure_storage` for authentication token storage
- `hive` and `hive_flutter` for local persistence
- `image_picker` for importing images into the designer
- `google_fonts`, `font_awesome_flutter`, and `flutter_animate` for UI

## Project Structure

```text
lib/
├── core/
│   ├── const_data/       # API URLs and app constants
│   ├── di/               # Dependency injection
│   ├── failure/          # Error and failure models
│   ├── network/          # Dio HTTP client
│   ├── routing/          # GoRouter configuration
│   ├── services/         # Storage, image picker, and UI services
│   └── utils/            # Shared utilities
├── features/
│   ├── admin/
│   ├── auth/
│   ├── cart/
│   ├── designer/
│   ├── home/
│   ├── onboarding/
│   ├── profile/
│   ├── shopping/
│   ├── splash/
│   └── wishlist/
├── shared/
│   ├── theme/            # Colors, typography, spacing, and themes
│   └── widgets/          # Reusable UI components
├── app.dart
└── main.dart
```

Feature modules generally follow a layered structure using `data`, `domain`, and `presentation` directories where appropriate.

## Getting Started

### Prerequisites

- Flutter SDK compatible with Dart `^3.11.5`
- Android Studio, Xcode, or another supported Flutter toolchain
- A running Athar API for authentication features

Check your installation:

```bash
flutter doctor
```

### Installation

1. Clone the repository and enter the project directory.

   ```bash
   git clone <repository-url>
   cd athar
   ```

2. Install dependencies.

   ```bash
   flutter pub get
   ```

3. Configure the API URL in `lib/core/const_data/api_urls.dart`.

   ```dart
   static const baseUrl = 'http://127.0.0.1:8000/api/';
   ```

4. Run the app.

   ```bash
   flutter run
   ```

## API Configuration

Authentication currently expects these endpoints:

```text
POST auth/login
POST auth/register
POST auth/logout
GET  auth/me
GET  user
```

The default API base URL is:

```text
http://127.0.0.1:8000/api/
```

When running on an Android emulator, `127.0.0.1` points to the emulator itself. Use `http://10.0.2.2:8000/api/` to reach a backend running on the development machine. A physical device must use the machine's local network address.

## Development Commands

```bash
# Analyze the project
flutter analyze

# Run tests
flutter test

# Format Dart files
dart format lib test

# Regenerate launcher icons
dart run flutter_launcher_icons
```

## Current Development Status

Athar is under active development. Authentication is connected to an HTTP API, while several commerce features currently use local or mock data. Product loading, promo-code validation, order placement, design persistence, and adding a custom design to the cart still contain placeholder or TODO logic.

Before a production release, connect these flows to the backend, add broader automated test coverage, and configure environment-specific API URLs.

## Supported Platforms

The repository includes Flutter platform projects for:

- Android
- iOS
- Web
- Windows
- macOS
- Linux

Platform behavior may vary until each target has been fully tested and configured.

## License

No license has been added yet. Add a `LICENSE` file before distributing the project publicly.
