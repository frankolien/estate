import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/config/theme_config.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_actions_grid.dart';

class InvestorDashboardPage extends ConsumerWidget {
  const InvestorDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Portfolio'),
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
              subtitle: 'Track your investments and discover opportunities',
              userType: authState.user?.userType ?? UserType.INVESTOR,
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
                    title: 'Find Investments',
                    subtitle: 'Discover opportunities',
                    onTap: () => context.go('/search'),
                  ),
                  QuickAction(
                    icon: Icons.analytics,
                    title: 'Portfolio',
                    subtitle: 'View performance',
                    onTap: () {
                      // Navigate to portfolio
                    },
                  ),
                  QuickAction(
                    icon: Icons.trending_up,
                    title: 'Market Analysis',
                    subtitle: 'Latest trends',
                    onTap: () {
                      // Navigate to market analysis
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

          // Portfolio Overview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Portfolio Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPortfolioMetric(
                              'Total Value',
                              '₦15,250,000',
                              Icons.account_balance_wallet,
                              ThemeConfig.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPortfolioMetric(
                              'Total ROI',
                              '+12.5%',
                              Icons.trending_up,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPortfolioMetric(
                              'Properties',
                              '3',
                              Icons.home,
                              ThemeConfig.secondaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPortfolioMetric(
                              'Monthly Income',
                              '₦180,000',
                              Icons.attach_money,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Investment Properties Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Investments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all investments
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          // Investment Properties List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildInvestmentCard(
                    '3BR Apartment - Victoria Island',
                    '₦15,000,000',
                    '+15.2% ROI',
                    '₦120,000/month',
                    'https://via.placeholder.com/300x200',
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildInvestmentCard(
                    '2BR Condo - Lekki Phase 1',
                    '₦8,500,000',
                    '+8.7% ROI',
                    '₦85,000/month',
                    'https://via.placeholder.com/300x200',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInvestmentCard(
                    'Studio - Ikoyi',
                    '₦5,200,000',
                    '+6.3% ROI',
                    '₦45,000/month',
                    'https://via.placeholder.com/300x200',
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),

          // Watchlist Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Watchlist',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to watchlist
                    },
                    child: const Text('Manage'),
                  ),
                ],
              ),
            ),
          ),

          // Watchlist Properties
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildWatchlistCard(
                    'Luxury Villa - Banana Island',
                    '₦45,000,000',
                    'High potential',
                    'https://via.placeholder.com/300x200',
                  ),
                  const SizedBox(height: 12),
                  _buildWatchlistCard(
                    'Commercial Space - Marina',
                    '₦25,000,000',
                    'Stable income',
                    'https://via.placeholder.com/300x200',
                  ),
                ],
              ),
            ),
          ),

          // Market Insights Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Market Insights',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to market insights
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          // Market Insights Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildInsightCard(
                    'Lagos Property Prices Up 8%',
                    'Victoria Island leads with 12% growth',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    'New Development in Lekki',
                    '500 new units coming to market',
                    Icons.new_releases,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    'Rental Yield Analysis',
                    'Best returns in Ikoyi and Victoria Island',
                    Icons.analytics,
                    Colors.orange,
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

  Widget _buildPortfolioMetric(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: ThemeConfig.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentCard(
    String title,
    String value,
    String roi,
    String monthlyIncome,
    String imageUrl,
    Color roiColor,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to investment detail
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
            // Investment Details
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
                      value,
                      style: const TextStyle(
                        color: ThemeConfig.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          roi,
                          style: TextStyle(
                            color: roiColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          monthlyIncome,
                          style: const TextStyle(
                            color: ThemeConfig.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Action Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: ThemeConfig.textLight,
                ),
                onPressed: () {
                  // Show action menu
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlistCard(
    String title,
    String price,
    String description,
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
              width: 80,
              height: 60,
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
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      price,
                      style: const TextStyle(
                        color: ThemeConfig.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        color: ThemeConfig.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Remove Button
            IconButton(
              icon: const Icon(
                Icons.close,
                color: ThemeConfig.textLight,
                size: 20,
              ),
              onPressed: () {
                // Remove from watchlist
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(
    String title,
    String description,
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
            Icon(
              Icons.arrow_forward_ios,
              color: ThemeConfig.textLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
