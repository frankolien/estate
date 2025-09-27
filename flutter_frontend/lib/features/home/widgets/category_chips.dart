import 'package:flutter/material.dart';
import '../../../core/models/property_model.dart';
import '../../../core/config/theme_config.dart';

class CategoryChips extends StatefulWidget {
  final Function(PropertyType) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  PropertyType? selectedCategory;

  final List<PropertyType> categories = [
    PropertyType.APARTMENT,
    PropertyType.HOUSE,
    PropertyType.CONDO,
    PropertyType.VILLA,
    PropertyType.STUDIO,
    PropertyType.OFFICE,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // +1 for "All" option
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" option
            final isSelected = selectedCategory == null;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: const Text('All'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = null;
                  });
                  widget.onCategorySelected(PropertyType.APARTMENT); // Default
                },
                selectedColor: ThemeConfig.primaryColor.withOpacity(0.2),
                checkmarkColor: ThemeConfig.primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? ThemeConfig.primaryColor : ThemeConfig.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(category.emoji),
                  const SizedBox(width: 4),
                  Text(category.displayName),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = selected ? category : null;
                });
                widget.onCategorySelected(category);
              },
              selectedColor: ThemeConfig.primaryColor.withOpacity(0.2),
              checkmarkColor: ThemeConfig.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? ThemeConfig.primaryColor : ThemeConfig.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
