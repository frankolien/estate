import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/models/property_model.dart';
import '../../../core/config/theme_config.dart';

class RecentPropertiesList extends StatelessWidget {
  final List<PropertyModel> properties;
  final Function(PropertyModel) onPropertyTap;
  final Function(PropertyModel)? onEditProperty;
  final Function(PropertyModel)? onDeleteProperty;

  const RecentPropertiesList({
    super.key,
    required this.properties,
    required this.onPropertyTap,
    this.onEditProperty,
    this.onDeleteProperty,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final property = properties[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < properties.length - 1 ? 12 : 0,
            ),
            child: _buildPropertyCard(property),
          );
        },
        childCount: properties.length,
      ),
    );
  }

  Widget _buildPropertyCard(PropertyModel property) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onPropertyTap(property),
        child: Row(
          children: [
            // Property Image
            Container(
              width: 100,
              height: 80,
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
            const SizedBox(width: 12),
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
                    const SizedBox(height: 4),
                    // Price
                    Text(
                      property.formattedPrice,
                      style: const TextStyle(
                        color: ThemeConfig.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Stats
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: ThemeConfig.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${property.viewCount}',
                          style: const TextStyle(
                            color: ThemeConfig.textLight,
                            fontSize: 12,
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
            // Action Menu
            if (onEditProperty != null || onDeleteProperty != null)
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEditProperty?.call(property);
                      break;
                    case 'delete':
                      onDeleteProperty?.call(property);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (onEditProperty != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  if (onDeleteProperty != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.more_vert,
                    color: ThemeConfig.textLight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
