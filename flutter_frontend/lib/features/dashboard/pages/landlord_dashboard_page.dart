import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/property_provider.dart';
import '../../../core/config/theme_config.dart';
import '../widgets/property_stats_card.dart';
import '../widgets/recent_properties_list.dart';

class LandlordDashboardPage extends ConsumerWidget {
  const LandlordDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final propertyState = ref.watch(propertyListProvider);

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeConfig.backgroundColor,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: ThemeConfig.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: ThemeConfig.backgroundColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: ThemeConfig.borderColor),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () {
                context.go('/property/add');
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: ThemeConfig.backgroundColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: ThemeConfig.borderColor),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.person_outline, size: 20),
              onSelected: (value) {
                if (value == 'profile') {
                  context.go('/profile');
                } else if (value == 'logout') {
                  _showLogoutDialog(context, ref);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 20, color: ThemeConfig.textPrimary),
                      const SizedBox(width: 12),
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout, size: 20, color: ThemeConfig.accentColor),
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: ThemeConfig.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(propertyListProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // Welcome Header - Modern minimal style
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${authState.user?.firstName}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ThemeConfig.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Manage your properties and track performance',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ThemeConfig.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions - Airbnb style
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  _buildQuickActionCard(
                    icon: Icons.add_home,
                    title: 'Add Property',
                    subtitle: 'List a new property',
                    color: ThemeConfig.primaryColor,
                    onTap: () => context.go('/property/add'),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.analytics,
                    title: 'Analytics',
                    subtitle: 'View performance',
                    color: ThemeConfig.secondaryColor,
                    onTap: () {
                      // Navigate to analytics
                    },
                  ),
                  _buildQuickActionCard(
                    icon: Icons.message,
                    title: 'Inquiries',
                    subtitle: '${propertyState.properties.length} new',
                    color: ThemeConfig.accentColor,
                    onTap: () {
                      // Navigate to inquiries
                    },
                  ),
                  _buildQuickActionCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'Manage account',
                    color: ThemeConfig.modernPurple,
                    onTap: () => context.go('/profile'),
                  ),
                ]),
              ),
            ),

            // Property Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      // Stack vertically on small screens
                      return Column(
                        children: [
                          PropertyStatsCard(
                            title: 'Total Properties',
                            value: '${propertyState.properties.length}',
                            icon: Icons.home,
                            color: ThemeConfig.primaryColor,
                          ),
                          const SizedBox(height: 12),
                          PropertyStatsCard(
                            title: 'Total Views',
                            value: '${propertyState.properties.fold(0, (sum, p) => sum + p.viewCount)}',
                            icon: Icons.visibility,
                            color: ThemeConfig.secondaryColor,
                          ),
                        ],
                      );
                    } else {
                      // Side by side on larger screens
                      return Row(
                        children: [
                          Expanded(
                            child: PropertyStatsCard(
                              title: 'Total Properties',
                              value: '${propertyState.properties.length}',
                              icon: Icons.home,
                              color: ThemeConfig.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PropertyStatsCard(
                              title: 'Total Views',
                              value: '${propertyState.properties.fold(0, (sum, p) => sum + p.viewCount)}',
                              icon: Icons.visibility,
                              color: ThemeConfig.secondaryColor,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      // Stack vertically on small screens
                      return Column(
                        children: [
                          PropertyStatsCard(
                            title: 'Total Likes',
                            value: '${propertyState.properties.fold(0, (sum, p) => sum + p.likeCount)}',
                            icon: Icons.favorite,
                            color: ThemeConfig.accentColor,
                          ),
                          const SizedBox(height: 12),
                          PropertyStatsCard(
                            title: 'Avg Rating',
                            value: propertyState.properties.isNotEmpty
                                ? '${(propertyState.properties.fold(0.0, (sum, p) => sum + (p.averageRating ?? 0)) / propertyState.properties.length).toStringAsFixed(1)}'
                                : '0.0',
                            icon: Icons.star,
                            color: Colors.amber,
                          ),
                        ],
                      );
                    } else {
                      // Side by side on larger screens
                      return Row(
                        children: [
                          Expanded(
                            child: PropertyStatsCard(
                              title: 'Total Likes',
                              value: '${propertyState.properties.fold(0, (sum, p) => sum + p.likeCount)}',
                              icon: Icons.favorite,
                              color: ThemeConfig.accentColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PropertyStatsCard(
                              title: 'Avg Rating',
                              value: propertyState.properties.isNotEmpty
                                  ? '${(propertyState.properties.fold(0.0, (sum, p) => sum + (p.averageRating ?? 0)) / propertyState.properties.length).toStringAsFixed(1)}'
                                  : '0.0',
                              icon: Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            // My Properties Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Properties',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ThemeConfig.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all properties
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: ThemeConfig.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Properties List
            if (propertyState.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (propertyState.error != null)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${propertyState.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(propertyListProvider.notifier).refresh();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (propertyState.properties.isEmpty)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.home_outlined,
                          size: 64,
                          color: ThemeConfig.textLight,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No properties yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add your first property to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeConfig.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/property/add'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Property'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: RecentPropertiesList(
                  properties: propertyState.properties.take(5).toList(),
                  onPropertyTap: (property) {
                    if (property.id != null) {
                      context.go('/property/${property.id}');
                    }
                  },
                  onEditProperty: (property) {
                    // Navigate to edit property
                  },
                  onDeleteProperty: (property) {
                    // Show delete confirmation
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/property/add'),
        backgroundColor: ThemeConfig.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeConfig.cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
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
              ),
              //const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ThemeConfig.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              //const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: ThemeConfig.textSecondary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: ThemeConfig.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go('/auth/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConfig.accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

