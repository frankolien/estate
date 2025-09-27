import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

  UserModel? _currentUser;
  String? _authToken;

  UserModel? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isAuthenticated => _currentUser != null && _authToken != null;

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      print('Login response: $response');
      print('Response type: ${response.runtimeType}');
      
      if (!response.containsKey('token') || !response.containsKey('user')) {
        print('Error: Response missing required fields. Keys: ${response.keys}');
        return AuthResult.failure('Invalid response structure from server');
      }
      
      _authToken = response['token'];
      print('Auth token: $_authToken');
      
      // Add auth token to user data before creating UserModel
      final userData = Map<String, dynamic>.from(response['user']);
      userData['authToken'] = _authToken;
      
      _currentUser = UserModel.fromJson(userData);
      print('Current user: ${_currentUser?.toJson()}');
      
      // Save to storage
      await _storageService.saveAuthToken(_authToken!);
      await _storageService.saveUser(_currentUser!);
      
      // Set auth token for API calls
      _apiService.setAuthToken(_authToken!);
      
      print('Login successful, isAuthenticated: $isAuthenticated');
      return AuthResult.success(_currentUser!);
    } catch (e) {
      print('Login error: $e');
      print('Error type: ${e.runtimeType}');
      
      // Extract user-friendly error message from DioException
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to get error message from backend response
          final errorMessage = responseData['message'] ?? 
                              responseData['error'] ?? 
                              'Login failed. Please check your credentials.';
          return AuthResult.failure(errorMessage);
        } else if (e.response?.statusCode == 400) {
          return AuthResult.failure('Invalid email or password. Please check your credentials.');
        } else if (e.response?.statusCode == 401) {
          return AuthResult.failure('Invalid email or password. Please check your credentials.');
        } else if (e.response?.statusCode == 404) {
          return AuthResult.failure('User not found. Please check your email address.');
        } else if (e.response?.statusCode == 500) {
          return AuthResult.failure('Server error. Please try again later.');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          return AuthResult.failure('Connection timeout. Please check your internet connection.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          return AuthResult.failure('Request timeout. Please try again.');
        } else if (e.type == DioExceptionType.connectionError) {
          return AuthResult.failure('Unable to connect to server. Please check your internet connection.');
        }
      }
      
      if (e is FormatException) {
        return AuthResult.failure('Server returned invalid data format. Please check if the backend is running correctly.');
      }
      
      // Fallback to generic error message
      return AuthResult.failure('Login failed. Please try again.');
    }
  }

  Future<AuthResult> register(UserModel user, String password) async {
    try {
      await _apiService.register(user, password);
      
      // Auto-login after registration
      final loginResult = await login(user.email, password);
      return loginResult;
    } catch (e) {
      print('Register error: $e');
      print('Error type: ${e.runtimeType}');
      
      // Extract user-friendly error message from DioException
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          // Try to get error message from backend response
          final errorMessage = responseData['message'] ?? 
                              responseData['error'] ?? 
                              'Registration failed. Please try again.';
          return AuthResult.failure(errorMessage);
        } else if (e.response?.statusCode == 400) {
          return AuthResult.failure('Invalid registration data. Please check your information.');
        } else if (e.response?.statusCode == 409) {
          return AuthResult.failure('Email already exists. Please use a different email address.');
        } else if (e.response?.statusCode == 500) {
          return AuthResult.failure('Server error. Please try again later.');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          return AuthResult.failure('Connection timeout. Please check your internet connection.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          return AuthResult.failure('Request timeout. Please try again.');
        } else if (e.type == DioExceptionType.connectionError) {
          return AuthResult.failure('Unable to connect to server. Please check your internet connection.');
        }
      }
      
      // Fallback to generic error message
      return AuthResult.failure('Registration failed. Please try again.');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _authToken = null;
    
    // Clear storage
    await _storageService.clearAuthToken();
    await _storageService.clearUser();
    
    // Clear API auth token
    _apiService.clearAuthToken();
  }

  Future<bool> checkAuthStatus() async {
    try {
      print('AuthService: Checking auth status...');
      final token = await _storageService.getAuthToken();
      final user = await _storageService.getUser();
      
      print('AuthService: Token exists: ${token != null}');
      print('AuthService: User exists: ${user != null}');
      
      if (token != null && user != null) {
        _authToken = token;
        // Update user with auth token
        _currentUser = user.copyWith(authToken: token);
        _apiService.setAuthToken(token);
        print('AuthService: Auth status check - User is authenticated');
        return true;
      }
      
      print('AuthService: Auth status check - User is NOT authenticated');
      return false;
    } catch (e) {
      print('AuthService: Error checking auth status: $e');
      return false;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final response = await _apiService.refreshToken();
      _authToken = response['token'];
      await _storageService.saveAuthToken(_authToken!);
      _apiService.setAuthToken(_authToken!);
      return true;
    } catch (e) {
      await logout();
      return false;
    }
  }

  Future<bool> verifyUser(String token) async {
    try {
      return await _apiService.verifyUser(token);
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      return await _apiService.resetPassword(email, newPassword);
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> updateProfile(UserModel user) async {
    try {
      if (_currentUser == null) return null;
      
      final updatedUser = await _apiService.updateUser(_currentUser!.id!, user);
      _currentUser = updatedUser;
      await _storageService.saveUser(updatedUser);
      return updatedUser;
    } catch (e) {
      return null;
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;

  AuthResult._(this.isSuccess, this.user, this.error);

  factory AuthResult.success(UserModel user) {
    return AuthResult._(true, user, null);
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(false, null, error);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthService(apiService, storageService);
});
