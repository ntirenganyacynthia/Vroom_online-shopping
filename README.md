# VROOM

VROOM is a Flutter based luxury vehicle shopping application. The application provides a mobile and cross platform shopping experience where users can authenticate, browse luxury vehicles, manage a shopping cart, and access the main application sections.

The project is organized using Flutter screens, data models, services, view models, assets, and automated tests.

## Features

VROOM currently provides:

- User login
- User signup
- Authentication state management
- Automatic authentication/session restoration
- Luxury vehicle catalogue
- Product cards
- Product images
- Product descriptions and prices
- Shopping cart
- Cart quantity management
- Cart total calculation
- Home, Cart, Orders, and Profile navigation
- Logout
- API integration
- Automated tests
- Cross-platform Flutter project structure

## Technology Stack

| Technology | Purpose |
| --- | --- |
| Flutter | Cross-platform application framework |
| Dart | Application programming language |
| Provider | Application state management |
| HTTP | REST API communication |
| Shared Preferences | Local session/token storage |
| Flutter Test | Automated testing |
| Mocktail | Test mocking |
| Material Design | User interface components |

## Project Structure

The project follows a Flutter application structure with separate directories for models, screens, services, view models, assets, and tests.

```text
vroom/
│
├── .dart_tool/
│
├── .idea/
│
├── android/
│
├── assets/
│   ├── fonts/
│   └── images/
│
├── build/
│
├── ios/
│
├── lib/
│   ├── model/
│   │   ├── auth_exception.dart
│   │   ├── cart_item.dart
│   │   ├── cart.dart
│   │   ├── login_response.dart
│   │   ├── product.dart
│   │   ├── token_response.dart
│   │   └── user.dart
│   │
│   ├── screens/
│   │   ├── cart_card.dart
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── product_card.dart
│   │   ├── redirect.dart
│   │   └── signup_screen.dart
│   │
│   ├── service/
│   │   └── auth_api.dart
│   │
│   ├── view_model/
│   │   └── auth_viewmodel.dart
│   │
│   └── main.dart
│
├── linux/
│   ├── flutter/
│   ├── runner/
│   ├── .gitignore
│   └── CMakeLists.txt
│
├── macos/
│
├── test/
│   ├── screens/
│   │   └── test_login_screen.dart
│   │
│   ├── services/
│   │   └── test_api.dart
│   │
│   ├── view_model/
│   │   └── test_auth_viewmodel.dart
│   │
│   └── widget_test.dart
│
├── web/
│   ├── icons/
│   ├── favicon.png
│   ├── index.html
│   └── manifest.json
│
├── windows/
│
├── .flutter-plugins-dependencies
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

> Generated directories such as `.dart_tool/` and `build/` are normally created by Flutter and should generally not be committed to source control.

## Application Architecture

VRROOM separates the application into several layers:

```text
┌─────────────────────────────┐
│          Screens            │
│ Login / Signup / Home /     │
│ Product / Cart / Redirect   │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│        View Models          │
│      AuthViewModel          │
└──────────────┬──────────────┘
               │
        ┌──────┴──────┐
        ▼             ▼
┌──────────────┐  ┌──────────────┐
│   Services   │  │    Models    │
│   Auth API   │  │ Product/Cart │
└──────┬───────┘  │ User/Tokens  │
       │          └──────────────┘
       ▼
┌─────────────────────────────┐
│       External API          │
└─────────────────────────────┘
```

This organization keeps user-interface code, application state, data structures, and API communication separated.

## Models

The `lib/model/` directory contains the application's data models.

### Authentication Models

```text
auth_exception.dart
login_response.dart
token_response.dart
user.dart
```

These files represent authentication-related responses, users, tokens, and authentication errors.

### Product Model

```text
product.dart
```

The product model represents the vehicle/product information displayed by the application.

### Cart Models

```text
cart.dart
cart_item.dart
```

These models represent the shopping cart and the individual products contained within it.

## Screens

The `lib/screens/` directory contains the application's user interface components.

### Login Screen

```text
login_screen.dart
```

The login screen provides the interface for users to enter their authentication information.

It handles:

- Username input
- Password input
- Validation
- Loading state
- Authentication errors
- Login submission

### Signup Screen

```text
signup_screen.dart
```

The signup screen provides the account registration interface.

It collects the information required by the application's registration flow and submits the registration request through the authentication layer.

### Home Screen

```text
home_screen.dart
```

The home screen provides the main shopping experience and displays the available luxury vehicles.

### Product Card

```text
product_card.dart
```

The product card is a reusable interface component used to display individual vehicles/products.

It can display:

- Product image
- Product name
- Description
- Price
- Add-to-cart functionality

### Cart Card

```text
cart_card.dart
```

The cart card displays an individual product that has been added to the shopping cart.

### Redirect

```text
redirect.dart
```

The redirect component supports navigation and application flow based on the user's current state.

## Authentication

Authentication is managed through the combination of:

```text
lib/service/auth_api.dart
lib/view_model/auth_viewmodel.dart
```

The authentication flow is separated from the UI so that screens do not directly contain the application's API implementation.

The general authentication flow is:

```text
User
 │
 ▼
Login / Signup Screen
 │
 ▼
AuthViewModel
 │
 ▼
AuthApi
 │
 ▼
Authentication API
 │
 ▼
Authentication Response
 │
 ▼
Token Storage
 │
 ▼
Authenticated Application
```

## AuthViewModel

`AuthViewModel` manages authentication state using Flutter's `ChangeNotifier`.

Its responsibilities include:

- Login
- Signup
- Logout
- Automatic login
- Token persistence
- Token refresh
- Current user state
- Loading state
- Error state
- Notifying widgets when authentication state changes

The view model allows the UI to react to authentication state without placing all authentication logic inside individual screens.

## Authentication API Service

The authentication service is located at:

```text
lib/service/auth_api.dart
```

The service is responsible for communicating with the external authentication API.

Keeping this functionality in a dedicated service makes the API layer reusable and keeps network requests separate from the presentation layer.

## Local Authentication Storage

The project uses Shared Preferences for local authentication/session storage.

Authentication tokens are stored locally so that the application can attempt to restore the user's authenticated session when the application starts.

Sensitive credentials should never be hard-coded into the source code or committed to GitHub.

## Shopping Cart

The shopping cart is represented by:

```text
lib/model/cart.dart
lib/model/cart_item.dart
```

The cart supports:

- Adding products
- Removing products
- Increasing quantities
- Decreasing quantities
- Calculating item totals
- Calculating the complete cart total
- Clearing cart data

The cart allows users to select multiple vehicles/products before continuing with the shopping flow.

## Product Catalogue

The application provides a luxury vehicle catalogue.

Product information is represented by the `Product` model:

```text
lib/model/product.dart
```

Products are displayed using:

```text
lib/screens/product_card.dart
```

A product can contain information such as:

- Name
- Description
- Price
- Image

## Navigation

The application provides the following main navigation areas:

```text
Home
Cart
Orders
Profile
```

### Home

Displays the available luxury vehicles.

### Cart

Displays the products selected by the user and provides quantity management.

### Orders

Provides the application's orders section.

### Profile

Provides the user's profile area and authentication-related actions such as logout.

## State Management

The project uses Provider for application state management.

The authentication state is managed through:

```text
AuthViewModel
```

The shopping cart is represented through:

```text
Cart
CartItem
```

Provider allows widgets to access and react to changes in application state without tightly coupling UI components to the underlying implementation.

## Assets

Application assets are stored under:

```text
assets/
├── fonts/
└── images/
```

The project contains an images directory for application imagery and a fonts directory for custom fonts.

The assets are configured through `pubspec.yaml`.

## Testing

The project contains a dedicated test structure:

```text
test/
├── screens/
│   └── test_login_screen.dart
│
├── services/
│   └── test_api.dart
│
├── view_model/
│   └── test_auth_viewmodel.dart
│
└── widget_test.dart
```

### Screen Tests

`test/screens/test_login_screen.dart` contains login-screen testing.

### Service Tests

`test/services/test_api.dart` contains API/service testing.

### View Model Tests

`test/view_model/test_auth_viewmodel.dart` contains authentication view-model tests.

### Widget Tests

`test/widget_test.dart` provides Flutter widget testing.

## Testing Commands

Run all tests:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

## Requirements

To run VRROOM locally, install:

- Flutter SDK
- Dart SDK compatible with the Flutter project
- Android Studio or another supported Android development environment
- A connected device or emulator
- Xcode for iOS development on macOS when targeting iOS

Verify Flutter:

```bash
flutter doctor
```

Check the Flutter version:

```bash
flutter --version
```

## Installation

Clone the repository:

```bash
git clone <repository-url>
```

Enter the project directory:

```bash
cd vroom
```

Install dependencies:

```bash
flutter pub get
```

## Running the Application

Check available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

To run on a specific device:

```bash
flutter run -d <device-id>
```

The application can also be run on supported Flutter web targets.

## Web Application

The repository contains a Flutter web implementation:

```text
web/
├── icons/
├── favicon.png
├── index.html
└── manifest.json
```

Build the web version with:

```bash
flutter build web
```

## Android

The project contains an Android platform implementation under:

```text
android/
```

Build an Android APK:

```bash
flutter build apk
```

Build an Android App Bundle:

```bash
flutter build appbundle
```

## iOS

The project contains an iOS implementation under:

```text
ios/
```

On macOS, an iOS build can be generated with:

```bash
flutter build ios
```

## Linux

The repository contains a Linux Flutter implementation under:

```text
linux/
```

The Linux platform includes:

```text
linux/
├── flutter/
├── runner/
├── .gitignore
└── CMakeLists.txt
```

## macOS

The project contains a macOS Flutter implementation under:

```text
macos/
```

## Windows

The repository also contains a Windows platform implementation under:

```text
windows/
```

## Development Workflow

After making changes, use:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Before committing changes:

```bash
git status
git add .
git commit -m "Describe your changes"
git push
```

## Security

Sensitive information should never be committed to the repository.

Do not commit:

- Passwords
- Authentication tokens
- API keys
- Database credentials
- Private credentials
- Production secrets

Demo credentials should be shared separately with authorized evaluators rather than stored in a public README.

If a password or secret has accidentally been committed to a public repository, it should be changed or revoked.

## Demo Credentials

For security reasons, demo credentials are intentionally not stored in this README.

For authorized evaluation:

```text
Username: <provided separately>
Password: <provided separately>
```

## Current Project Status

VRROOM currently provides:

- Flutter application structure
- Authentication screens
- Signup functionality
- Authentication state management
- Automatic session restoration
- Luxury vehicle catalogue
- Product cards
- Shopping cart
- Cart quantity management
- Cart total calculation
- Main application navigation
- API service layer
- Automated tests
- Android support
- iOS support
- Linux support
- macOS support
- Web support
- Windows project support

## Future Improvements

Potential future improvements include:

- Dedicated production backend
- Persistent product catalogue
- Persistent orders
- Order history
- Payment integration
- Product search and filtering
- Favorites/wishlist
- Inventory management
- User profile management
- Production authentication
- Expanded automated test coverage
- Notifications
- Analytics
- Production deployment

## Important Development Notes

The directories `.dart_tool/` and `build/` are generated by Flutter and normally should not be manually edited.

The application source code is primarily maintained under:

```text
lib/
```

Tests are maintained under:

```text
test/
```

Application resources are maintained under:

```text
assets/
```

Platform-specific configuration is maintained under:

```text
android/
ios/
linux/
macos/
web/
windows/
```

## License

No open-source license is currently specified for the project.

If the project is intended for public distribution, an appropriate license should be added.

## Author

Cynthia Ntirenganya
