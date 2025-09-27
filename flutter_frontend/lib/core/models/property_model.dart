import 'user_model.dart';

class PropertyModel {
  final int? id;
  final String title;
  final String description;
  final double price;
  final PropertyType propertyType;
  final ListingType listingType;
  final PropertyStatus propertyStatus;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final double? latitude;
  final double? longitude;
  final int? bedrooms;
  final int? bathrooms;
  final int? squareFeet;
  final int? lotSize;
  final int? yearBuilt;
  final int? parkingSpaces;
  final bool isFurnished;
  final bool isPetFriendly;
  final bool hasPool;
  final bool hasGarden;
  final bool hasGym;
  final bool hasSecurity;
  final bool isVerified;
  final bool isFeatured;
  final int viewCount;
  final int likeCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user;
  final List<PropertyImageModel> images;
  final List<PropertyReviewModel> reviews;
  final double? averageRating;
  final int reviewCount;

  PropertyModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.propertyType,
    required this.listingType,
    this.propertyStatus = PropertyStatus.AVAILABLE,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.bedrooms,
    this.bathrooms,
    this.squareFeet,
    this.lotSize,
    this.yearBuilt,
    this.parkingSpaces,
    this.isFurnished = false,
    this.isPetFriendly = false,
    this.hasPool = false,
    this.hasGarden = false,
    this.hasGym = false,
    this.hasSecurity = false,
    this.isVerified = false,
    this.isFeatured = false,
    this.viewCount = 0,
    this.likeCount = 0,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.images = const [],
    this.reviews = const [],
    this.averageRating,
    this.reviewCount = 0,
  });

  String get fullAddress => '$address, $city, $state $postalCode';
  String get formattedPrice => '₦${price.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  )}';

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      propertyType: PropertyType.values.firstWhere(
        (e) => e.name == json['propertyType'],
        orElse: () => PropertyType.APARTMENT,
      ),
      listingType: ListingType.values.firstWhere(
        (e) => e.name == json['listingType'],
        orElse: () => ListingType.RENT,
      ),
      propertyStatus: PropertyStatus.values.firstWhere(
        (e) => e.name == json['propertyStatus'],
        orElse: () => PropertyStatus.AVAILABLE,
      ),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      bedrooms: json['bedrooms'] != null ? int.tryParse(json['bedrooms'].toString()) : null,
      bathrooms: json['bathrooms'] != null ? int.tryParse(json['bathrooms'].toString()) : null,
      squareFeet: json['squareFeet'] != null ? int.tryParse(json['squareFeet'].toString()) : null,
      lotSize: json['lotSize'] != null ? int.tryParse(json['lotSize'].toString()) : null,
      yearBuilt: json['yearBuilt'] != null ? int.tryParse(json['yearBuilt'].toString()) : null,
      parkingSpaces: json['parkingSpaces'] != null ? int.tryParse(json['parkingSpaces'].toString()) : null,
      isFurnished: json['isFurnished'] ?? false,
      isPetFriendly: json['isPetFriendly'] ?? false,
      hasPool: json['hasPool'] ?? false,
      hasGarden: json['hasGarden'] ?? false,
      hasGym: json['hasGym'] ?? false,
      hasSecurity: json['hasSecurity'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      viewCount: json['viewCount'] != null ? int.tryParse(json['viewCount'].toString()) ?? 0 : 0,
      likeCount: json['likeCount'] != null ? int.tryParse(json['likeCount'].toString()) ?? 0 : 0,
      createdAt: json['createdAt'] != null 
          ? PropertyModel._parseDateTime(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? PropertyModel._parseDateTime(json['updatedAt']) 
          : null,
      user: json['user'] != null 
          ? UserModel.fromJson(json['user']) 
          : null,
      images: json['images'] != null 
          ? (json['images'] as List)
              .map((img) => PropertyImageModel.fromJson(img))
              .toList()
          : [],
      reviews: json['reviews'] != null 
          ? (json['reviews'] as List)
              .map((review) => PropertyReviewModel.fromJson(review))
              .toList()
          : [],
      averageRating: json['averageRating']?.toDouble(),
      reviewCount: json['reviewCount'] != null ? int.tryParse(json['reviewCount'].toString()) ?? 0 : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'propertyType': propertyType.name,
      'listingType': listingType.name,
      'propertyStatus': propertyStatus.name,
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'squareFeet': squareFeet,
      'lotSize': lotSize,
      'yearBuilt': yearBuilt,
      'parkingSpaces': parkingSpaces,
      'isFurnished': isFurnished,
      'isPetFriendly': isPetFriendly,
      'hasPool': hasPool,
      'hasGarden': hasGarden,
      'hasGym': hasGym,
      'hasSecurity': hasSecurity,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
      'images': images.map((img) => img.toJson()).toList(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }

  PropertyModel copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    PropertyType? propertyType,
    ListingType? listingType,
    PropertyStatus? propertyStatus,
    String? address,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    int? bedrooms,
    int? bathrooms,
    int? squareFeet,
    int? lotSize,
    int? yearBuilt,
    int? parkingSpaces,
    bool? isFurnished,
    bool? isPetFriendly,
    bool? hasPool,
    bool? hasGarden,
    bool? hasGym,
    bool? hasSecurity,
    bool? isVerified,
    bool? isFeatured,
    int? viewCount,
    int? likeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
    List<PropertyImageModel>? images,
    List<PropertyReviewModel>? reviews,
    double? averageRating,
    int? reviewCount,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      propertyType: propertyType ?? this.propertyType,
      listingType: listingType ?? this.listingType,
      propertyStatus: propertyStatus ?? this.propertyStatus,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      squareFeet: squareFeet ?? this.squareFeet,
      lotSize: lotSize ?? this.lotSize,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      parkingSpaces: parkingSpaces ?? this.parkingSpaces,
      isFurnished: isFurnished ?? this.isFurnished,
      isPetFriendly: isPetFriendly ?? this.isPetFriendly,
      hasPool: hasPool ?? this.hasPool,
      hasGarden: hasGarden ?? this.hasGarden,
      hasGym: hasGym ?? this.hasGym,
      hasSecurity: hasSecurity ?? this.hasSecurity,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      images: images ?? this.images,
      reviews: reviews ?? this.reviews,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  // Helper method for safe DateTime parsing
  static DateTime? _parseDateTime(dynamic dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString.toString());
    } catch (e) {
      print('Error parsing date: $dateString, error: $e');
      return null;
    }
  }

  // Debug method to log property creation
  void debugLog() {
    print('Property created with ID: $id, Title: $title, Price: $price');
  }
}

class PropertyImageModel {
  final int? id;
  final String imageUrl;
  final String? imageCaption;
  final bool isPrimary;
  final int sortOrder;
  final DateTime? createdAt;

  PropertyImageModel({
    this.id,
    required this.imageUrl,
    this.imageCaption,
    this.isPrimary = false,
    this.sortOrder = 0,
    this.createdAt,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      imageUrl: json['imageUrl'] ?? '',
      imageCaption: json['imageCaption'],
      isPrimary: json['isPrimary'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? PropertyModel._parseDateTime(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'imageCaption': imageCaption,
      'isPrimary': isPrimary,
      'sortOrder': sortOrder,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class PropertyReviewModel {
  final int? id;
  final String comment;
  final int rating;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user;

  PropertyReviewModel({
    this.id,
    required this.comment,
    required this.rating,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory PropertyReviewModel.fromJson(Map<String, dynamic> json) {
    return PropertyReviewModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      comment: json['comment'],
      rating: json['rating'],
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] != null 
          ? PropertyModel._parseDateTime(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? PropertyModel._parseDateTime(json['updatedAt']) 
          : null,
      user: json['user'] != null 
          ? UserModel.fromJson(json['user']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'rating': rating,
      'isVerified': isVerified,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}

enum PropertyType {
  APARTMENT,
  HOUSE,
  CONDO,
  TOWNHOUSE,
  VILLA,
  STUDIO,
  PENTHOUSE,
  DUPLEX,
  OFFICE,
  RETAIL,
  WAREHOUSE,
  INDUSTRIAL,
  LAND,
  COMMERCIAL,
  MIXED_USE,
}

enum ListingType {
  BUY,
  SELL,
  RENT,
  LEASE,
}

enum PropertyStatus {
  AVAILABLE,
  PENDING,
  SOLD,
  RENTED,
  OFF_MARKET,
  DRAFT,
}

extension PropertyTypeExtension on PropertyType {
  String get displayName {
    switch (this) {
      case PropertyType.APARTMENT:
        return 'Apartment';
      case PropertyType.HOUSE:
        return 'House';
      case PropertyType.CONDO:
        return 'Condo';
      case PropertyType.TOWNHOUSE:
        return 'Townhouse';
      case PropertyType.VILLA:
        return 'Villa';
      case PropertyType.STUDIO:
        return 'Studio';
      case PropertyType.PENTHOUSE:
        return 'Penthouse';
      case PropertyType.DUPLEX:
        return 'Duplex';
      case PropertyType.OFFICE:
        return 'Office';
      case PropertyType.RETAIL:
        return 'Retail';
      case PropertyType.WAREHOUSE:
        return 'Warehouse';
      case PropertyType.INDUSTRIAL:
        return 'Industrial';
      case PropertyType.LAND:
        return 'Land';
      case PropertyType.COMMERCIAL:
        return 'Commercial';
      case PropertyType.MIXED_USE:
        return 'Mixed Use';
    }
  }

  String get emoji {
    switch (this) {
      case PropertyType.APARTMENT:
        return '🏢';
      case PropertyType.HOUSE:
        return '🏠';
      case PropertyType.CONDO:
        return '🏘️';
      case PropertyType.TOWNHOUSE:
        return '🏘️';
      case PropertyType.VILLA:
        return '🏡';
      case PropertyType.STUDIO:
        return '🏠';
      case PropertyType.PENTHOUSE:
        return '🏙️';
      case PropertyType.DUPLEX:
        return '🏘️';
      case PropertyType.OFFICE:
        return '🏢';
      case PropertyType.RETAIL:
        return '🏪';
      case PropertyType.WAREHOUSE:
        return '🏭';
      case PropertyType.INDUSTRIAL:
        return '🏭';
      case PropertyType.LAND:
        return '🌾';
      case PropertyType.COMMERCIAL:
        return '🏢';
      case PropertyType.MIXED_USE:
        return '🏢';
    }
  }
}

extension ListingTypeExtension on ListingType {
  String get displayName {
    switch (this) {
      case ListingType.BUY:
        return 'Buy';
      case ListingType.SELL:
        return 'Sell';
      case ListingType.RENT:
        return 'Rent';
      case ListingType.LEASE:
        return 'Lease';
    }
  }
}
