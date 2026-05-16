import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BrandButtonStyle { primary, outline, destructive }

class BrandButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BrandButtonStyle style;
  final IconData? icon;

  const BrandButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : style = BrandButtonStyle.primary;

  const BrandButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : style = BrandButtonStyle.outline;

  const BrandButton.destructive({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : style = BrandButtonStyle.destructive;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    final BorderRadius radius = BorderRadius.circular(16);

    BoxDecoration decoration;
    Color textColor;

    switch (style) {
      case BrandButtonStyle.primary:
        decoration = BoxDecoration(
          gradient: isDisabled
              ? LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.3),
                    const Color(0xFFF48FB1).withOpacity(0.3),
                  ],
                )
              : AppTheme.headerGradient(context),
          borderRadius: radius,
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        );
        textColor = Colors.white;
        break;
      case BrandButtonStyle.outline:
        decoration = BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: Border.all(color: const Color(0xFF6C63FF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        );
        textColor = const Color(0xFF6C63FF);
        break;
      case BrandButtonStyle.destructive:
        decoration = BoxDecoration(
          color: isDisabled ? Colors.red.shade200 : const Color(0xFFE53935),
          borderRadius: radius,
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        );
        textColor = Colors.white;
        break;
    }

    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: isDisabled ? null : onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
