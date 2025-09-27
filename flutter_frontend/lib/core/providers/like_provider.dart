import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class LikeState {
  final Map<int, bool> likedProperties;
  final Map<int, int> likeCounts;
  final bool isLoading;
  final String? error;

  const LikeState({
    this.likedProperties = const {},
    this.likeCounts = const {},
    this.isLoading = false,
    this.error,
  });

  LikeState copyWith({
    Map<int, bool>? likedProperties,
    Map<int, int>? likeCounts,
    bool? isLoading,
    String? error,
  }) {
    return LikeState(
      likedProperties: likedProperties ?? this.likedProperties,
      likeCounts: likeCounts ?? this.likeCounts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LikeNotifier extends StateNotifier<LikeState> {
  final ApiService _apiService;
  final Ref _ref;

  LikeNotifier(this._apiService, this._ref) : super(const LikeState());

  Future<void> toggleLike(int propertyId) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final authState = _ref.read(authStateProvider);
      if (authState.user?.id == null) {
        throw Exception('User not authenticated');
      }

      final userId = authState.user!.id!;
      final isCurrentlyLiked = state.likedProperties[propertyId] ?? false;

      bool success;
      if (isCurrentlyLiked) {
        success = await _apiService.unlikeProperty(propertyId, userId);
      } else {
        success = await _apiService.likeProperty(propertyId, userId);
      }

      if (success) {
        // Update the liked status
        final newLikedProperties = Map<int, bool>.from(state.likedProperties);
        newLikedProperties[propertyId] = !isCurrentlyLiked;

        // Update like count
        final newLikeCounts = Map<int, int>.from(state.likeCounts);
        final currentCount = state.likeCounts[propertyId] ?? 0;
        newLikeCounts[propertyId] = isCurrentlyLiked ? currentCount - 1 : currentCount + 1;

        state = state.copyWith(
          isLoading: false,
          likedProperties: newLikedProperties,
          likeCounts: newLikeCounts,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to update like status',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> checkLikeStatus(int propertyId) async {
    try {
      final authState = _ref.read(authStateProvider);
      if (authState.user?.id == null) return;

      final userId = authState.user!.id!;
      print('Checking like status for property $propertyId for user $userId');
      
      final isLiked = await _apiService.isPropertyLiked(propertyId, userId);
      final likeCount = await _apiService.getPropertyLikeCount(propertyId);
      
      print('Property $propertyId - isLiked: $isLiked, likeCount: $likeCount');

      final newLikedProperties = Map<int, bool>.from(state.likedProperties);
      newLikedProperties[propertyId] = isLiked;

      final newLikeCounts = Map<int, int>.from(state.likeCounts);
      newLikeCounts[propertyId] = likeCount;

      state = state.copyWith(
        likedProperties: newLikedProperties,
        likeCounts: newLikeCounts,
      );
      
      print('Updated state for property $propertyId: ${state.likedProperties[propertyId]}');
    } catch (e) {
      // Silently fail for individual property checks
      print('Error checking like status for property $propertyId: $e');
    }
  }

  Future<void> checkLikeStatusForProperties(List<int> propertyIds) async {
    for (final propertyId in propertyIds) {
      await checkLikeStatus(propertyId);
    }
  }

  bool isLiked(int propertyId) {
    return state.likedProperties[propertyId] ?? false;
  }

  int getLikeCount(int propertyId) {
    return state.likeCounts[propertyId] ?? 0;
  }
}

final likeProvider = StateNotifierProvider<LikeNotifier, LikeState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LikeNotifier(apiService, ref);
});
