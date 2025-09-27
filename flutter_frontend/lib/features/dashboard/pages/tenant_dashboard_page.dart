import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/config/theme_config.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_actions_grid.dart';

class TenantDashboardPage extends ConsumerWidget {
  const TenantDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.go('/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Welcome Header
          SliverToBoxAdapter(
            child: DashboardHeader(
              title: 'Welcome back, ${authState.user?.firstName}!',
              subtitle: 'Find your perfect home',
              userType: authState.user?.userType ?? UserType.TENANT,
            ),
          ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: QuickActionsGrid(
                actions: [
                  QuickAction(
                    icon: Icons.search,
                    title: 'Search Properties',
                    subtitle: 'Find your next home',
                    onTap: () => context.go('/search'),
                  ),
                  QuickAction(
                    icon: Icons.favorite,
                    title: 'Saved Properties',
                    subtitle: '8 saved',
                    onTap: () {
                      // Navigate to saved properties
                    },
                  ),
                  QuickAction(
                    icon: Icons.notifications,
                    title: 'Alerts',
                    subtitle: '3 new matches',
                    onTap: () {
                      // Navigate to alerts
                    },
                  ),
                  QuickAction(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'Manage preferences',
                    onTap: () => context.go('/profile'),
                    ),
                ],
              ),
            ),
          ),

          // Saved Searches Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saved Searches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all saved searches
                    },
                    child: const Text('Manage'),
                  ),
                ],
              ),
            ),
          ),

          // Saved Searches List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildSavedSearchCard(
                    '2BR Apartment in Lagos',
                    'Under ₦200k/month',
                    '3 new matches',
                    Icons.apartment,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildSavedSearchCard(
                    '3BR House in Victoria Island',
                    'Furnished, Pet-friendly',
                    '1 new match',
                    Icons.home,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildSavedSearchCard(
                    'Studio in Lekki',
                    'Near beach, Modern',
                    '5 new matches',
                    Icons.home_work,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),

          // Recent Inquiries Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Inquiries',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all inquiries
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          // Inquiries List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildInquiryCard(
                    '3BR Apartment - Victoria Island',
                    'Waiting for response',
                    '2 hours ago',
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildInquiryCard(
                    '2BR Condo - Lekki Phase 1',
                    'Scheduled tour tomorrow',
                    '1 day ago',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInquiryCard(
                    'Studio - Ikoyi',
                    'Application submitted',
                    '3 days ago',
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),

          // Recommended Properties Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended for You',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all recommendations
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          // Recommended Properties
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildRecommendedPropertyCard(
                    'Modern 2BR Apartment',
                    'Lekki Phase 1',
                    '₦180,000/month',
                    '4.5 ⭐ (23 reviews)',
                    'https://via.placeholder.com/300x200',
                  ),
                  const SizedBox(height: 12),
                  _buildRecommendedPropertyCard(
                    'Cozy Studio Apartment',
                    'Victoria Island',
                    '₦120,000/month',
                    '4.2 ⭐ (15 reviews)',
                    'https://via.placeholder.com/300x200',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedSearchCard(
    String title,
    String description,
    String matches,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: ThemeConfig.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  matches,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to view',
                  style: const TextStyle(
                    color: ThemeConfig.textLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInquiryCard(
    String property,
    String status,
    String time,
    Color statusColor,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                color: ThemeConfig.textLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedPropertyCard(
    String title,
    String location,
    String price,
    String rating,
    String imageUrl,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to property detail
        },
        child: Row(
          children: [
            // Property Image
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: ThemeConfig.borderColor,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: ThemeConfig.textSecondary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        color: ThemeConfig.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: ThemeConfig.textLight,
                        fontSize: 12,
                      ),
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
                onPressed: () {
                  // Handle like action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
