import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/property_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/config/theme_config.dart';
import '../../../core/utils/navigation_utils.dart';
import '../widgets/search_filters.dart';
import '../widgets/property_list_item.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Load initial properties
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(propertyListProvider.notifier).loadProperties();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(propertyListProvider.notifier).searchProperties(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyState = ref.watch(propertyListProvider);

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeConfig.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ThemeConfig.textPrimary,
          ),
          onPressed: () => NavigationUtils.safePop(context),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeConfig.textPrimary,
            letterSpacing: -0.3,
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
              icon: Icon(
                _showFilters ? Icons.tune : Icons.tune_outlined,
                size: 20,
                color: _showFilters ? ThemeConfig.primaryColor : ThemeConfig.textPrimary,
              ),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
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
      body: Column(
        children: [
          // Search Bar - Airbnb style
          Container(
            margin: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeConfig.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Where to?',
                hintStyle: const TextStyle(
                  color: ThemeConfig.textSecondary,
                  fontSize: 16,
                  letterSpacing: -0.2,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: ThemeConfig.textPrimary,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: ThemeConfig.textSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Filters
          if (_showFilters)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ThemeConfig.backgroundColor,
                border: Border(
                  bottom: BorderSide(color: ThemeConfig.borderColor),
                ),
              ),
              child: SearchFilters(
                onFiltersApplied: (filters) {
                  ref.read(propertyListProvider.notifier).filterProperties(
                    minPrice: filters['minPrice'],
                    maxPrice: filters['maxPrice'],
                    city: filters['city'],
                    stateParam: filters['state'],
                    propertyType: filters['propertyType'],
                    listingType: filters['listingType'],
                    minBedrooms: filters['minBedrooms'],
                    maxBedrooms: filters['maxBedrooms'],
                    minBathrooms: filters['minBathrooms'],
                    maxBathrooms: filters['maxBathrooms'],
                  );
                },
              ),
            ),

          // Results
          Expanded(
            child: propertyState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : propertyState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text('Error: ${propertyState.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(propertyListProvider.notifier).refresh();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : propertyState.properties.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: ThemeConfig.textLight,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No properties found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Try adjusting your search criteria',
                                  style: TextStyle(
                                    color: ThemeConfig.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(propertyListProvider.notifier).loadProperties();
                                  },
                                  child: const Text('Clear Search'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => ref.read(propertyListProvider.notifier).refresh(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: propertyState.properties.length + 
                                  (propertyState.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == propertyState.properties.length) {
                                  // Load more button
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: propertyState.isLoadingMore
                                        ? const Center(child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            onPressed: () {
                                              ref.read(propertyListProvider.notifier).loadMore();
                                            },
                                            child: const Text('Load More'),
                                          ),
                                  );
                                }

                                final property = propertyState.properties[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: PropertyListItem(
                                    property: property,
                                    onTap: () {
                                      if (property.id != null) {
                                        context.go('/property/${property.id}');
                                      }
                                    },
                                    onLike: () {
                                      // Handle like action
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
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
