import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/property_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/config/theme_config.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/property_stats_card.dart';
import '../widgets/recent_properties_list.dart';
import '../widgets/quick_actions_grid.dart';

class AgentDashboardPage extends ConsumerWidget {
  const AgentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final propertyState = ref.watch(propertyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/property/add');
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
      body: RefreshIndicator(
        onRefresh: () => ref.read(propertyListProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // Welcome Header
            SliverToBoxAdapter(
              child: DashboardHeader(
                title: 'Welcome back, ${authState.user?.firstName}!',
                subtitle: 'Manage your listings and track leads',
                userType: authState.user?.userType ?? UserType.AGENT,
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuickActionsGrid(
                  actions: [
                    QuickAction(
                      icon: Icons.add_home,
                      title: 'Add Listing',
                      subtitle: 'Create new listing',
                      onTap: () => context.go('/property/add'),
                    ),
                    QuickAction(
                      icon: Icons.people,
                      title: 'Leads',
                      subtitle: '8 new leads',
                      onTap: () {
                        // Navigate to leads
                      },
                    ),
                    QuickAction(
                      icon: Icons.analytics,
                      title: 'Performance',
                      subtitle: 'View analytics',
                      onTap: () {
                        // Navigate to analytics
                      },
                    ),
                    QuickAction(
                      icon: Icons.settings,
                      title: 'Settings',
                      subtitle: 'Manage account',
                      onTap: () => context.go('/profile'),
                    ),
                  ],
                ),
              ),
            ),

            // Performance Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PropertyStatsCard(
                        title: 'Active Listings',
                        value: '${propertyState.properties.length}',
                        icon: Icons.home,
                        color: ThemeConfig.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PropertyStatsCard(
                        title: 'Properties Sold',
                        value: '5',
                        icon: Icons.check_circle,
                        color: ThemeConfig.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: PropertyStatsCard(
                        title: 'Properties Rented',
                        value: '7',
                        icon: Icons.key,
                        color: ThemeConfig.accentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PropertyStatsCard(
                        title: 'Commission',
                        value: '₦2.5M',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Leads Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Leads',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all leads
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),

            // Leads List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildLeadCard(
                      'John Doe',
                      'Interested in 3BR Apartment',
                      'Victoria Island',
                      '2 hours ago',
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildLeadCard(
                      'Sarah Wilson',
                      'Looking for 2BR Condo',
                      'Lekki Phase 1',
                      '5 hours ago',
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildLeadCard(
                      'Mike Johnson',
                      'Wants to buy Villa',
                      'Ikoyi',
                      '1 day ago',
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            // My Listings Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Listings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all listings
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),

            // Listings
            if (propertyState.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
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
                          'No listings yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add your first listing to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeConfig.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context.go('/property/add'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Listing'),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLeadCard(
    String name,
    String description,
    String location,
    String time,
    Color color,
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
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
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
                  const SizedBox(height: 2),
                  Text(
                    location,
                    style: const TextStyle(
                      color: ThemeConfig.textLight,
                      fontSize: 12,
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
}
