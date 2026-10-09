import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/astro_theme.dart';
import '../../core/theme/theme_provider.dart';

/// Reusable glassmorphic styled card for astronomical data display
class AstroCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;

  const AstroCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRed = ref.watch(isRedLightModeProvider);

    final defaultBg = isRed
        ? AstroColors.redLightSurface
        : AstroColors.cosmosSurface.withValues(alpha: 0.85);

    final defaultBorder = isRed
        ? AstroColors.redLightBorder
        : AstroColors.cosmosCardBorder.withValues(alpha: 0.6);

    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor ?? defaultBorder,
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Small pill badge for telemetry or classification (e.g. "Bortle 4", "Naked Eye", "Mag 1.2")
class AstroBadge extends ConsumerWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const AstroBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRed = ref.watch(isRedLightModeProvider);
    final badgeColor = isRed
        ? AstroColors.redLightPrimary
        : (color ?? AstroColors.starlightCyan);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: isRed ? 0.2 : 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: badgeColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isRed ? AstroColors.redLightText : badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
