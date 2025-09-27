class AppConfig {
  static const String appName = 'EstatePlatform';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:8081/api';
  static const String imageBaseUrl = 'http://localhost:8081/images';
  
  // App Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  
  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 30);
  
  // Map Configuration
  static const double defaultLatitude = 6.5244; // Lagos
  static const double defaultLongitude = 3.3792;
  static const double defaultZoom = 12.0;
  
  // Currency
  static const String currencySymbol = '₦';
  static const String currencyCode = 'NGN';
}
