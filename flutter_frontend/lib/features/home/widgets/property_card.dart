import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/property_model.dart';
import '../../../core/config/theme_config.dart';
import '../../../core/providers/like_provider.dart';

class PropertyCard extends ConsumerWidget {
  final PropertyModel property;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likeState = ref.watch(likeProvider);
    final isLiked = likeState.likedProperties[property.id] ?? false;
    
    print('PropertyCard for property ${property.id}: isLiked = $isLiked, likeState = ${likeState.likedProperties}');
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ThemeConfig.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Property Image - Modern minimal style
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: property.images.isNotEmpty
                            ? property.images.first.imageUrl
                            : 'https://via.placeholder.com/300x200',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: ThemeConfig.lightBackground,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(ThemeConfig.primaryColor),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: ThemeConfig.lightBackground,
                          child: const Icon(
                            Icons.home_outlined,
                            size: 48,
                            color: ThemeConfig.textLight,
                          ),
                        ),
                      ),
                    ),
                    
                    // Heart Button - Modern minimal style
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          if (property.id != null) {
                            ref.read(likeProvider.notifier).toggleLike(property.id!);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isLiked ? ThemeConfig.modernRed : ThemeConfig.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    
                    // Verified Badge - Modern minimal style
                    if (property.isVerified)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified,
                                size: 14,
                                color: ThemeConfig.modernGreen,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Verified',
                                style: TextStyle(
                                  color: ThemeConfig.textPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Property Details - Modern minimal style
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       // Title - Modern typography with flexible layout
                       Flexible(
                         child: Text(
                           property.title,
                           style: Theme.of(context).textTheme.titleSmall?.copyWith(
                             color: ThemeConfig.textPrimary,
                             height: 1.2,
                           ),
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                      //const SizedBox(height: 6), // Reduced spacing
                      
                      // Location - Clean secondary text
                      Text(
                        property.city,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ThemeConfig.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8), // Reduced spacing
                      
                      // Price and Rating Row - Flexible layout
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           // Price - Prominent display with flexible width
                           Flexible(
                             flex: 2,
                             child: Text(
                               property.formattedPrice,
                               style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                 color: Colors.grey,
                                 
                               ),
                               overflow: TextOverflow.ellipsis,
                             ),
                           ),
                          
                          // Rating - Clean display with flexible width
                          if (property.averageRating != null) ...[
                            Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14, // Reduced icon size
                                    color: ThemeConfig.modernOrange,
                                  ),
                                  const SizedBox(width: 3), // Reduced spacing
                                   Flexible(
                                     child: Text(
                                       property.averageRating!.toStringAsFixed(1),
                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                         color: ThemeConfig.textPrimary,
                                         fontWeight: FontWeight.w600,
                                       ),
                                       overflow: TextOverflow.ellipsis,
                                     ),
                                   ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                       // Rental type indicator - Flexible layout
                       if (property.listingType == ListingType.RENT) ...[
                         const SizedBox(height: 4),
                         Text(
                           'per night',
                           style: Theme.of(context).textTheme.labelSmall?.copyWith(
                             color: ThemeConfig.textLight,
                           ),
                           overflow: TextOverflow.ellipsis,
                         ),
                       ],
                      
                      // Spacer to push content to top
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}