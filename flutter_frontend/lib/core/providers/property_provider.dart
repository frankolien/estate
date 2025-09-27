import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/property_model.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

final propertyListProvider = StateNotifierProvider<PropertyListNotifier, PropertyListState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PropertyListNotifier(apiService, ref);
});

final propertyDetailProvider = StateNotifierProvider.family<PropertyDetailNotifier, PropertyDetailState, int>((ref, propertyId) {
  final apiService = ref.watch(apiServiceProvider);
  return PropertyDetailNotifier(apiService, propertyId);
});

class PropertyListNotifier extends StateNotifier<PropertyListState> {
  final ApiService _apiService;
  final Ref _ref;

  PropertyListNotifier(this._apiService, this._ref) : super(PropertyListState.initial());

  Future<void> loadProperties({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Set auth token before making API calls
      final authState = _ref.read(authStateProvider);
      if (authState.user?.authToken != null) {
        _apiService.setAuthToken(authState.user!.authToken!);
      }
      
      final response = await _apiService.getProperties(
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
      );
      
      final properties = (response['content'] as List)
          .map((json) => PropertyModel.fromJson(json))
          .toList();
      
      state = state.copyWith(
        isLoading: false,
        properties: properties,
        currentPage: page,
        totalPages: response['totalPages'] ?? 0,
        hasMore: page < (response['totalPages'] ?? 1) - 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    
    state = state.copyWith(isLoadingMore: true);
    
    try {
      // Set auth token before making API calls
      final authState = _ref.read(authStateProvider);
      if (authState.user?.authToken != null) {
        _apiService.setAuthToken(authState.user!.authToken!);
      }
      
      final response = await _apiService.getProperties(
        page: state.currentPage + 1,
        size: 10,
      );
      
      final newProperties = (response['content'] as List)
          .map((json) => PropertyModel.fromJson(json))
          .toList();
      
      state = state.copyWith(
        isLoadingMore: false,
        properties: [...state.properties, ...newProperties],
        currentPage: state.currentPage + 1,
        hasMore: state.currentPage + 1 < (response['totalPages'] ?? 1) - 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchProperties(String keyword) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final properties = await _apiService.searchProperties(keyword);
      
      state = state.copyWith(
        isLoading: false,
        properties: properties,
        currentPage: 0,
        hasMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> filterProperties({
    double? minPrice,
    double? maxPrice,
    String? city,
    String? stateParam,
    PropertyType? propertyType,
    ListingType? listingType,
    int? minBedrooms,
    int? maxBedrooms,
    int? minBathrooms,
    int? maxBathrooms,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _apiService.searchPropertiesWithFilters(
        minPrice: minPrice,
        maxPrice: maxPrice,
        city: city,
        state: stateParam,
        propertyType: propertyType,
        listingType: listingType,
        minBedrooms: minBedrooms,
        maxBedrooms: maxBedrooms,
        minBathrooms: minBathrooms,
        maxBathrooms: maxBathrooms,
      );
      
      final properties = (response['content'] as List)
          .map((json) => PropertyModel.fromJson(json))
          .toList();
      
      state = state.copyWith(
        isLoading: false,
        properties: properties,
        currentPage: 0,
        totalPages: response['totalPages'] ?? 0,
        hasMore: 0 < (response['totalPages'] ?? 1) - 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addProperty(PropertyModel property) async {
    try {
      final authState = _ref.read(authStateProvider);
      if (authState.user?.id == null) {
        throw Exception('User not authenticated');
      }
      
      // Set auth token before making API calls
      if (authState.user?.authToken != null) {
        _apiService.setAuthToken(authState.user!.authToken!);
      }
      
      await _apiService.createProperty(property, authState.user!.id!);
      // Refresh the properties list to include the new property
      await refresh();
    } catch (e) {
      throw Exception('Failed to add property: $e');
    }
  }

  Future<void> refresh() async {
    await loadProperties();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class PropertyDetailNotifier extends StateNotifier<PropertyDetailState> {
  final ApiService _apiService;
  final int propertyId;

  PropertyDetailNotifier(this._apiService, this.propertyId) : super(PropertyDetailState.initial()) {
    loadProperty();
  }

  Future<void> loadProperty() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final property = await _apiService.getPropertyById(propertyId);
      
      state = state.copyWith(
        isLoading: false,
        property: property,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> likeProperty(int userId) async {
    try {
      await _apiService.likeProperty(propertyId, userId);
      if (state.property != null) {
        final updatedProperty = state.property!.copyWith(
          likeCount: state.property!.likeCount + 1,
        );
        state = state.copyWith(property: updatedProperty);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> unlikeProperty(int userId) async {
    try {
      await _apiService.unlikeProperty(propertyId, userId);
      if (state.property != null) {
        final updatedProperty = state.property!.copyWith(
          likeCount: state.property!.likeCount - 1,
        );
        state = state.copyWith(property: updatedProperty);
      }
    } catch (e) {
      // Handle error
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class PropertyListState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<PropertyModel> properties;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final String? error;

  PropertyListState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.properties,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    this.error,
  });

  factory PropertyListState.initial() {
    return PropertyListState(
      isLoading: true,
      isLoadingMore: false,
      properties: [],
      currentPage: 0,
      totalPages: 0,
      hasMore: false,
      error: null,
    );
  }

  PropertyListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<PropertyModel>? properties,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    String? error,
  }) {
    return PropertyListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      properties: properties ?? this.properties,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class PropertyDetailState {
  final bool isLoading;
  final PropertyModel? property;
  final String? error;

  PropertyDetailState({
    required this.isLoading,
    this.property,
    this.error,
  });

  factory PropertyDetailState.initial() {
    return PropertyDetailState(
      isLoading: true,
      property: null,
      error: null,
    );
  }

  PropertyDetailState copyWith({
    bool? isLoading,
    PropertyModel? property,
    String? error,
  }) {
    return PropertyDetailState(
      isLoading: isLoading ?? this.isLoading,
      property: property ?? this.property,
      error: error ?? this.error,
    );
  }
}
