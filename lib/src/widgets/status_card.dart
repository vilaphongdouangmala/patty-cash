import 'package:flutter/material.dart';
import 'package:patty_cash/src/theme/app_theme.dart';

/// A reusable card widget that displays a status with an icon, title, and count
class StatusCard extends StatelessWidget {
  /// The icon to display in the card
  final IconData icon;
  
  /// The title text to display
  final String title;
  
  /// The count or value to display
  final String count;
  
  /// Optional callback when the card is tapped
  final VoidCallback? onTap;

  /// Creates a status card widget
  const StatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
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
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.lightTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
