import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';
import '../config/theme_config.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/property/pages/property_detail_page.dart';
import '../../features/property/pages/add_property_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/dashboard/pages/landlord_dashboard_page.dart';
import '../../features/dashboard/pages/agent_dashboard_page.dart';
import '../../features/dashboard/pages/tenant_dashboard_page.dart';
import '../../features/dashboard/pages/investor_dashboard_page.dart';
import '../../features/search/pages/search_page.dart';
import '../../features/search/pages/filter_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      
      print('Router redirect: path=${state.uri.path}, isAuthenticated=$isAuthenticated, isLoading=$isLoading');
      
      // Don't redirect if still loading
      if (isLoading) {
        print('Router: Still loading, no redirect');
        return null;
      }
      
      // Redirect to login if not authenticated and not on auth pages
      if (!isAuthenticated && !state.uri.path.startsWith('/auth')) {
        print('Router: Not authenticated, redirecting to login');
        return '/auth/login';
      }
      
      // Redirect to home if authenticated and on auth pages
      if (isAuthenticated && state.uri.path.startsWith('/auth')) {
        print('Router: Authenticated on auth page, redirecting to home');
        return '/';
      }
      
      print('Router: No redirect needed');
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Main Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/filter',
        builder: (context, state) => const FilterPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      
      // Property Routes - Order matters! Specific routes before parameterized routes
      GoRoute(
        path: '/property/add',
        builder: (context, state) => const AddPropertyPage(),
      ),
      GoRoute(
        path: '/property/:id',
        builder: (context, state) {
          final idString = state.pathParameters['id'];
          if (idString == null || idString.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
                backgroundColor: ThemeConfig.primaryColor,
                foregroundColor: Colors.white,
              ),
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Property ID Required',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No property ID was provided.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          final propertyId = int.tryParse(idString);
          if (propertyId == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
                backgroundColor: ThemeConfig.primaryColor,
                foregroundColor: Colors.white,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Invalid Property ID',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The property ID "$idString" is not valid.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Go Home'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return PropertyDetailPage(propertyId: propertyId);
        },
      ),
      
      // Dashboard Routes (Role-based)
      GoRoute(
        path: '/dashboard',
        builder: (context, state) {
          return Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authStateProvider);
              
              if (authState.isLandlord) {
                return const LandlordDashboardPage();
              } else if (authState.isAgent) {
                return const AgentDashboardPage();
              } else if (authState.isTenant) {
                return const TenantDashboardPage();
              } else if (authState.isInvestor) {
                return const InvestorDashboardPage();
              } else {
                return const HomePage();
              }
            },
          );
        },
      ),
    ],
  );
});
