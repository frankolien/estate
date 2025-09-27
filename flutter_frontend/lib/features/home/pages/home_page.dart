import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/property_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/like_provider.dart';
import '../../../core/config/theme_config.dart';
import '../widgets/property_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load properties when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(propertyListProvider.notifier).loadProperties();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyState = ref.watch(propertyListProvider);
    final authState = ref.watch(authStateProvider);
    
    // Load like status for properties when they change
    if (propertyState.properties.isNotEmpty && authState.user?.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final propertyIds = propertyState.properties
            .where((p) => p.id != null)
            .map((p) => p.id!)
            .toList();
        ref.read(likeProvider.notifier).checkLikeStatusForProperties(propertyIds);
      });
    }

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeConfig.backgroundColor,
        elevation: 0,
        title: Text(
          'EstatePlatform',
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
              icon: const Icon(Icons.search, size: 20),
              onPressed: () {
                // Navigate to search page
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
                  // Navigate to profile
                } else if (value == 'logout') {
                  _showLogoutDialog(context, ref);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 20, color: ThemeConfig.textPrimary),
                      SizedBox(width: 12),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20, color: ThemeConfig.accentColor),
                      SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ThemeConfig.accentColor,
                          letterSpacing: -0.2,
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
            // Search Bar - Modern minimal style
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ThemeConfig.borderColor,
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search properties...',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ThemeConfig.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: ThemeConfig.textSecondary,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      ref.read(propertyListProvider.notifier).searchProperties(query);
                    }
                  },
                ),
              ),
            ),

            // Category Chips - Airbnb style
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 24),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildCategoryChip('🏠 All', true),
                    const SizedBox(width: 12),
                    _buildCategoryChip('🏖️ Beach', false),
                    const SizedBox(width: 12),
                    _buildCategoryChip('🏔️ Mountain', false),
                    const SizedBox(width: 12),
                    _buildCategoryChip('🏙️ City', false),
                    const SizedBox(width: 12),
                    _buildCategoryChip('🌊 Lake', false),
                    const SizedBox(width: 12),
                    _buildCategoryChip('🏕️ Camping', false),
                  ],
                ),
              ),
            ),

            // Properties Section Header - Modern typography
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Places to stay',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.6,
                          color: ThemeConfig.textPrimary,
                        )
                        
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
                        'Show all',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: ThemeConfig.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Properties Grid - Airbnb style
            if (propertyState.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(ThemeConfig.primaryColor),
                    ),
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
                          color: ThemeConfig.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${propertyState.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: ThemeConfig.textSecondary,
                          ),
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
                      children: const [
                        Icon(
                          Icons.home_outlined,
                          size: 64,
                          color: ThemeConfig.textLight,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No properties available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ThemeConfig.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Be the first to add a property!',
                          style: TextStyle(
                            fontSize: 14,
                            color: ThemeConfig.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(


                padding: const EdgeInsets.symmetric(horizontal: 24.0,),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7, // Adjusted for fixed height cards (300px total height)
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final property = propertyState.properties[index];
                      return PropertyCard(
                        property: property,
                        onTap: () {
                          if (property.id != null) {
                            context.go('/property/${property.id}');
                          }
                        },
                      );
                    },
                    childCount: propertyState.properties.length,
                  ),
                ),
              ),

            // Load More Button
            if (propertyState.hasMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: propertyState.isLoadingMore
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            ref.read(propertyListProvider.notifier).loadMore();
                          },
                          child: const Text('Load More'),
                        ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: authState.isLandlord || authState.isAgent
          ? FloatingActionButton(
              onPressed: () {
                context.go('/property/add');
              },
              backgroundColor: ThemeConfig.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: _buildFloatingNavBar(context),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? ThemeConfig.textPrimary : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? ThemeConfig.textPrimary : ThemeConfig.borderColor,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: ThemeConfig.textPrimary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : ThemeConfig.textPrimary,
          letterSpacing: -0.2,
        ),
        child: Text(label),
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

  Widget _buildFloatingNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              isSelected: true,
              onTap: () {
                // Already on home page
              },
            ),
            _buildNavItem(
              icon: Icons.favorite_border,
              isSelected: false,
              onTap: () {
                // Navigate to favorites
              },
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_outline,
              isSelected: false,
              onTap: () {
                // Navigate to messages
              },
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              isSelected: false,
              onTap: () {
                // Navigate to profile
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? ThemeConfig.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? ThemeConfig.primaryColor : ThemeConfig.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}
