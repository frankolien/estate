# EstatePlatform - Flutter Frontend

A comprehensive real estate platform built with Flutter, featuring role-based dashboards for landlords, agents, tenants, and investors.

## 🏗️ Architecture

This Flutter app follows a clean architecture pattern with:

- **State Management**: Riverpod for reactive state management
- **Navigation**: GoRouter for declarative routing
- **HTTP Client**: Dio for API communication
- **Local Storage**: SharedPreferences and Flutter Secure Storage
- **UI Framework**: Material Design 3 with custom theming

## 🎯 Features

### Core Features
- **Role-based Authentication**: Different experiences for landlords, agents, tenants, and investors
- **Property Management**: Create, view, edit, and manage property listings
- **Advanced Search**: Filter properties by location, price, type, and amenities
- **Property Details**: Rich property pages with images, descriptions, and contact options
- **User Profiles**: Comprehensive user management and settings

### Role-Specific Features

#### 🏠 Landlord Dashboard
- Property management interface
- Performance analytics
- Inquiry tracking
- Property statistics

#### 🏢 Agent Dashboard
- Lead management
- Listing performance
- Commission tracking
- Client communication

#### 🏘️ Tenant Dashboard
- Property search and filtering
- Saved searches and alerts
- Inquiry tracking
- Property recommendations

#### 💰 Investor Dashboard
- Investment portfolio tracking
- Market insights
- Property watchlist
- ROI analytics

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   Update `lib/core/config/app_config.dart` with your backend API URL:
   ```dart
   static const String baseUrl = 'http://your-backend-url/api';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Authentication
- Login screen with email/password authentication
- Registration with role selection
- User verification and password reset

### Home & Search
- Property browsing with featured listings
- Advanced search with filters
- Category-based property discovery

### Role-Based Dashboards
- **Landlord**: Property management and analytics
- **Agent**: Lead management and performance tracking
- **Tenant**: Property search and saved listings
- **Investor**: Portfolio management and market insights

### Property Management
- Detailed property pages with image galleries
- Property creation and editing forms
- Contact and inquiry management

## 🛠️ Development

### Project Structure
```
lib/
├── core/
│   ├── config/          # App configuration and theming
│   ├── models/          # Data models
│   ├── providers/       # Riverpod state providers
│   ├── routing/         # Navigation configuration
│   └── services/        # API and storage services
├── features/
│   ├── auth/           # Authentication screens
│   ├── dashboard/      # Role-based dashboards
│   ├── home/           # Home and property browsing
│   ├── property/       # Property management
│   ├── profile/        # User profile management
│   └── search/         # Search and filtering
└── main.dart           # App entry point
```

### State Management
The app uses Riverpod for state management with the following providers:

- `authStateProvider`: User authentication state
- `propertyListProvider`: Property listing state
- `propertyDetailProvider`: Individual property details

### API Integration
The app communicates with the Spring Boot backend through:

- `ApiService`: HTTP client for API calls
- `AuthService`: Authentication management
- `StorageService`: Local data persistence

## 🎨 Theming

The app uses Material Design 3 with a custom color scheme:

- **Primary**: Blue (#2563EB)
- **Secondary**: Green (#059669)
- **Accent**: Red (#DC2626)
- **Background**: Light gray (#F9FAFB)

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `dio`: HTTP client
- `shared_preferences`: Local storage
- `flutter_secure_storage`: Secure storage

### UI Dependencies
- `cached_network_image`: Image caching
- `material_design_icons_flutter`: Icons
- `flutter_svg`: SVG support
- `shimmer`: Loading animations

### Utility Dependencies
- `intl`: Internationalization
- `url_launcher`: External links
- `image_picker`: Camera/gallery access
- `geolocator`: Location services

## 🔧 Configuration

### Environment Setup
1. **Development**: Uses local backend (localhost:8080)
2. **Production**: Update `baseUrl` in `app_config.dart`

### Build Configuration
- **Android**: Configured for API level 21+
- **iOS**: Configured for iOS 11.0+

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Backend Integration

This Flutter frontend is designed to work with the Spring Boot backend. Ensure the backend is running and accessible before testing the app.

The backend should provide the following endpoints:
- Authentication (`/api/auth/*`)
- Properties (`/api/properties/*`)
- Users (`/api/users/*`)
- Reviews (`/api/properties/*/reviews/*`)

See the backend API documentation for detailed endpoint specifications.
