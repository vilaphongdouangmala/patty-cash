import 'package:flutter/material.dart';
import 'package:patty_cash/src/theme/app_theme.dart';

/// Button types for the ActionButton widget
enum ActionButtonType {
  /// Primary action button with filled background
  primary,
  
  /// Secondary action button with filled background
  secondary,
  
  /// Outlined button with border
  outlined,
  
  /// Destructive action button (red)
  destructive
}

/// A reusable action button widget with consistent styling
class ActionButton extends StatelessWidget {
  /// The text to display on the button
  final String label;
  
  /// The icon to display on the button
  final IconData icon;
  
  /// The callback when the button is pressed
  final VoidCallback onPressed;
  
  /// The type of button to display
  final ActionButtonType type;
  
  /// Whether the button should take the full width available
  final bool fullWidth;

  /// Creates an action button widget
  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.type = ActionButtonType.primary,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    // Create base button style with fullWidth support
    ButtonStyle getButtonStyle({Color? backgroundColor, Color? foregroundColor, BorderSide? side}) {
      return ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        backgroundColor: backgroundColor != null ? MaterialStateProperty.all<Color>(backgroundColor) : null,
        foregroundColor: foregroundColor != null ? MaterialStateProperty.all<Color>(foregroundColor) : null,
        side: side != null ? MaterialStateProperty.all<BorderSide>(side) : null,
        minimumSize: fullWidth ? MaterialStateProperty.all<Size>(const Size.fromHeight(48)) : null,
      );
    }
    
    switch (type) {
      case ActionButtonType.primary:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: getButtonStyle(backgroundColor: AppTheme.primaryColor),
        );
        
      case ActionButtonType.secondary:
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: getButtonStyle(backgroundColor: AppTheme.secondaryColor),
        );
        
      case ActionButtonType.outlined:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: getButtonStyle(),
        );
        
      case ActionButtonType.destructive:
        return OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: getButtonStyle(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        );
    }
  }
}
