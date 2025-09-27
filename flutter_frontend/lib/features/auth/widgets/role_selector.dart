import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/config/theme_config.dart';

class RoleSelector extends StatelessWidget {
  final UserType selectedType;
  final Function(UserType) onTypeSelected;

  const RoleSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'I am a:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: UserType.values.map((type) {
            final isSelected = selectedType == type;
            return GestureDetector(
              onTap: () => onTypeSelected(type),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ThemeConfig.primaryColor.withOpacity(0.1)
                      : ThemeConfig.surfaceColor,
                  border: Border.all(
                    color: isSelected
                        ? ThemeConfig.primaryColor
                        : ThemeConfig.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      type.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? ThemeConfig.primaryColor
                            : ThemeConfig.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
