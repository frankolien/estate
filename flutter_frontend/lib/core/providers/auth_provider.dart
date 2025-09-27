import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    print('AuthProvider: Checking auth status...');
    
    final isAuthenticated = await _authService.checkAuthStatus();
    print('AuthProvider: Auth service returned isAuthenticated: $isAuthenticated');
    print('AuthProvider: Current user from service: ${_authService.currentUser?.toJson()}');
    
    if (isAuthenticated) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: _authService.currentUser,
      );
      print('AuthProvider: Auth status check - User is authenticated');
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
      );
      print('AuthProvider: Auth status check - User is NOT authenticated');
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    print('AuthProvider: Starting login process');
    
    final result = await _authService.login(email, password);
    print('AuthProvider: Login result - isSuccess: ${result.isSuccess}, user: ${result.user?.toJson()}');
    
    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.user,
        error: null,
      );
      print('AuthProvider: Login successful, new state - isAuthenticated: ${state.isAuthenticated}, user: ${state.user?.toJson()}');
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        error: result.error,
      );
      print('AuthProvider: Login failed, error: ${result.error}');
    }
  }

  Future<void> register(UserModel user, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _authService.register(user, password);
    
    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.user,
        error: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        error: result.error,
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.initial();
  }

  Future<void> updateProfile(UserModel user) async {
    state = state.copyWith(isLoading: true);
    
    final updatedUser = await _authService.updateProfile(user);
    
    if (updatedUser != null) {
      state = state.copyWith(
        isLoading: false,
        user: updatedUser,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile',
      );
    }
  }

  Future<void> verifyUser(String token) async {
    state = state.copyWith(isLoading: true);
    
    final success = await _authService.verifyUser(token);
    
    if (success && state.user != null) {
      final verifiedUser = state.user!.copyWith(isVerified: true);
      state = state.copyWith(
        isLoading: false,
        user: verifiedUser,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Verification failed',
      );
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final success = await _authService.resetPassword(email, newPassword);
    
    if (success) {
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Password reset failed',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.user,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: true,
      isAuthenticated: false,
      user: null,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  bool get isLandlord => user?.userType == UserType.LANDLORD;
  bool get isAgent => user?.userType == UserType.AGENT;
  bool get isTenant => user?.userType == UserType.TENANT;
  bool get isInvestor => user?.userType == UserType.INVESTOR;
  bool get isAdmin => user?.userType == UserType.ADMIN;
}
