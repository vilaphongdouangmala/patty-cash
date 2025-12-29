import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:patty_cash/src/theme/app_theme.dart';

/// A reusable card widget that displays a status with an icon, title, and count
class SectionBox extends StatelessWidget {
  /// The icon to display in the card
  final IconData icon;

  /// The title text to display
  final String title;

  final List<String> items;

  /// Optional callback when the card is tapped
  final VoidCallback? onTap;

  /// Creates a status card widget
  const SectionBox({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.lightTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'common.no_data'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.lightTextColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 8.0, // gap between lines
                          children: items
                              .map(
                                (item) => Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
