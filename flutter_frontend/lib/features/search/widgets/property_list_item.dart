import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/models/property_model.dart';
import '../../../core/config/theme_config.dart';

class PropertyListItem extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback? onTap;
  final VoidCallback? onLike;

  const PropertyListItem({
    super.key,
    required this.property,
    this.onTap,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Property Image
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                color: ThemeConfig.borderColor,
              ),
              child: property.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: property.images.first.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: ThemeConfig.borderColor,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: ThemeConfig.borderColor,
                        child: const Icon(
                          Icons.home,
                          color: ThemeConfig.textLight,
                        ),
                      ),
                    )
                  : Container(
                      color: ThemeConfig.borderColor,
                      child: const Icon(
                        Icons.home,
                        color: ThemeConfig.textLight,
                      ),
                    ),
            ),
            
            // Property Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Type
                    Row(
                      children: [
                        Text(
                          property.propertyType.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (property.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeConfig.secondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '✓',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Location
                    Text(
                      property.city,
                      style: const TextStyle(
                        color: ThemeConfig.textSecondary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Price
                    Text(
                      property.formattedPrice,
                      style: const TextStyle(
                        color: ThemeConfig.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Property Details
                    Row(
                      children: [
                        if (property.bedrooms != null) ...[
                          const Icon(
                            Icons.bed,
                            size: 14,
                            color: ThemeConfig.textLight,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${property.bedrooms}',
                              style: const TextStyle(
                                color: ThemeConfig.textLight,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (property.bathrooms != null) ...[
                          const Icon(
                            Icons.bathtub,
                            size: 14,
                            color: ThemeConfig.textLight,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${property.bathrooms}',
                              style: const TextStyle(
                                color: ThemeConfig.textLight,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (property.squareFeet != null) ...[
                          const Icon(
                            Icons.square_foot,
                            size: 14,
                            color: ThemeConfig.textLight,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${property.squareFeet} sq ft',
                              style: const TextStyle(
                                color: ThemeConfig.textLight,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Stats and Actions
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: ThemeConfig.textLight,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${property.viewCount}',
                            style: const TextStyle(
                              color: ThemeConfig.textLight,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.favorite,
                          size: 14,
                          color: ThemeConfig.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${property.likeCount}',
                          style: const TextStyle(
                            color: ThemeConfig.textLight,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        if (property.averageRating != null) ...[
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            property.averageRating!.toStringAsFixed(1),
                            style: const TextStyle(
                              color: ThemeConfig.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Like Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: ThemeConfig.textLight,
                ),
                onPressed: onLike,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
