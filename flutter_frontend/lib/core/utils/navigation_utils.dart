import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationUtils {
  /// Safely pops the current route or navigates to home if there's nothing to pop
  static void safePop(BuildContext context, {String? fallbackRoute}) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallbackRoute ?? '/');
    }
  }
  
  /// Safely pops the current route or navigates to a specific route
  static void safePopTo(BuildContext context, String route) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(route);
    }
  }
}
