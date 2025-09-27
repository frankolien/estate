import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/user_model.dart';
import '../models/property_model.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Auth Endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      print('Raw login response: ${response.data}');
      print('Response type: ${response.data.runtimeType}');
      return response.data;
    } catch (e) {
      print('API login error: $e');
      print('Error type: ${e.runtimeType}');
      if (e is DioException) {
        print('DioException response: ${e.response?.data}');
        print('DioException status: ${e.response?.statusCode}');
      }
      rethrow;
    }
  }

  Future<UserModel> register(UserModel user, String password) async {
    final response = await _dio.post('/auth/register', data: {
      ...user.toJson(),
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final response = await _dio.post('/auth/refresh');
    return response.data;
  }

  // User Endpoints
  Future<List<UserModel>> getUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  Future<UserModel> getUserById(int id) async {
    final response = await _dio.get('/users/$id');
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateUser(int id, UserModel user) async {
    final response = await _dio.put('/users/$id', data: user.toJson());
    return UserModel.fromJson(response.data);
  }

  Future<bool> verifyUser(String token) async {
    final response = await _dio.put('/users/verify/$token');
    return response.data;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final response = await _dio.post('/users/reset-password', queryParameters: {
      'email': email,
      'newPassword': newPassword,
    });
    return response.data;
  }

  // Property Endpoints
  Future<Map<String, dynamic>> getProperties({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    final response = await _dio.get('/properties', queryParameters: {
      'page': page,
      'size': size,
      'sortBy': sortBy,
      'sortDir': sortDir,
    });
    return response.data;
  }

  Future<PropertyModel> getPropertyById(int id) async {
    final response = await _dio.get('/properties/$id');
    return PropertyModel.fromJson(response.data);
  }

  Future<List<PropertyModel>> getPropertiesByUser(int userId) async {
    final response = await _dio.get('/properties/user/$userId');
    return (response.data as List)
        .map((json) => PropertyModel.fromJson(json))
        .toList();
  }

  Future<List<PropertyModel>> searchProperties(String keyword) async {
    final response = await _dio.get('/properties/search', queryParameters: {
      'keyword': keyword,
    });
    return (response.data as List)
        .map((json) => PropertyModel.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> searchPropertiesWithFilters({
    double? minPrice,
    double? maxPrice,
    String? city,
    String? state,
    PropertyType? propertyType,
    ListingType? listingType,
    int? minBedrooms,
    int? maxBedrooms,
    int? minBathrooms,
    int? maxBathrooms,
    int page = 0,
    int size = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };

    if (minPrice != null) queryParams['minPrice'] = minPrice;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (city != null) queryParams['city'] = city;
    if (state != null) queryParams['state'] = state;
    if (propertyType != null) queryParams['propertyType'] = propertyType.name;
    if (listingType != null) queryParams['listingType'] = listingType.name;
    if (minBedrooms != null) queryParams['minBedrooms'] = minBedrooms;
    if (maxBedrooms != null) queryParams['maxBedrooms'] = maxBedrooms;
    if (minBathrooms != null) queryParams['minBathrooms'] = minBathrooms;
    if (maxBathrooms != null) queryParams['maxBathrooms'] = maxBathrooms;

    final response = await _dio.get('/properties/filter', queryParameters: queryParams);
    return response.data;
  }

  Future<PropertyModel> createProperty(PropertyModel property, int userId) async {
    print('API: Creating property for user $userId');
    print('API: Property data: ${property.toJson()}');
    
    final response = await _dio.post('/properties', 
        data: property.toJson(),
        queryParameters: {'userId': userId});
    
    print('API: Response received: ${response.data}');
    return PropertyModel.fromJson(response.data);
  }

  Future<PropertyModel> updateProperty(int id, PropertyModel property) async {
    final response = await _dio.put('/properties/$id', data: property.toJson());
    return PropertyModel.fromJson(response.data);
  }

  Future<void> deleteProperty(int id) async {
    await _dio.delete('/properties/$id');
  }

  Future<bool> likeProperty(int propertyId, int userId) async {
    final response = await _dio.post('/properties/$propertyId/likes', 
        queryParameters: {'userId': userId});
    return response.data;
  }

  Future<bool> unlikeProperty(int propertyId, int userId) async {
    final response = await _dio.delete('/properties/$propertyId/likes', 
        queryParameters: {'userId': userId});
    return response.data;
  }

  Future<bool> isPropertyLiked(int propertyId, int userId) async {
    final response = await _dio.get('/properties/$propertyId/likes/check', 
        queryParameters: {'userId': userId});
    return response.data;
  }

  Future<int> getPropertyLikeCount(int propertyId) async {
    final response = await _dio.get('/properties/$propertyId/likes/count');
    return response.data;
  }

  // Review Endpoints
  Future<PropertyReviewModel> createReview(
      int propertyId, int userId, PropertyReviewModel review) async {
    final response = await _dio.post('/properties/$propertyId/reviews',
        data: review.toJson(),
        queryParameters: {'userId': userId});
    return PropertyReviewModel.fromJson(response.data);
  }

  Future<List<PropertyReviewModel>> getReviewsByProperty(int propertyId) async {
    final response = await _dio.get('/properties/$propertyId/reviews');
    return (response.data as List)
        .map((json) => PropertyReviewModel.fromJson(json))
        .toList();
  }

  Future<PropertyReviewModel> updateReview(
      int propertyId, int reviewId, int userId, PropertyReviewModel review) async {
    final response = await _dio.put('/properties/$propertyId/reviews/$reviewId',
        data: review.toJson(),
        queryParameters: {'userId': userId});
    return PropertyReviewModel.fromJson(response.data);
  }

  Future<void> deleteReview(int propertyId, int reviewId, int userId) async {
    await _dio.delete('/properties/$propertyId/reviews/$reviewId',
        queryParameters: {'userId': userId});
  }

  Future<double> getAverageRating(int propertyId) async {
    final response = await _dio.get('/properties/$propertyId/reviews/average-rating');
    return response.data?.toDouble() ?? 0.0;
  }

  Future<int> getReviewCount(int propertyId) async {
    final response = await _dio.get('/properties/$propertyId/reviews/count');
    return response.data;
  }

  // Image Upload Methods
  Future<List<String>> uploadImages(List<File> imageFiles) async {
    try {
      List<MultipartFile> multipartFiles = [];
      
      for (File file in imageFiles) {
        multipartFiles.add(await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ));
      }
      
      FormData formData = FormData.fromMap({
        'files': multipartFiles,
      });
      
      final response = await _dio.post('/images/upload', data: formData);
      return List<String>.from(response.data);
    } catch (e) {
      print('Error uploading images: $e');
      rethrow;
    }
  }

  Future<String> uploadSingleImage(File imageFile) async {
    try {
      MultipartFile multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );
      
      FormData formData = FormData.fromMap({
        'file': multipartFile,
      });
      
      final response = await _dio.post('/images/upload-single', data: formData);
      return response.data;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
