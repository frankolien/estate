import 'package:flutter/material.dart';
import '../../../core/config/theme_config.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback? onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeConfig.surfaceColor,
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
        controller: controller,
        onSubmitted: onSearch,
        decoration: InputDecoration(
          hintText: 'Search properties, locations, or agents...',
          hintStyle: const TextStyle(
            color: ThemeConfig.textLight,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: ThemeConfig.textSecondary,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: ThemeConfig.textSecondary,
                  ),
                  onPressed: () {
                    controller.clear();
                    onSearch('');
                  },
                ),
              Container(
                height: 30,
                width: 1,
                color: ThemeConfig.borderColor,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: ThemeConfig.primaryColor,
                ),
                onPressed: onFilterTap,
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
