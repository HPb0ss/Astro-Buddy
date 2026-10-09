import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/astro_theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/astro_card.dart';
import '../models/celestial_object.dart';

class CelestialDetailSheet extends ConsumerStatefulWidget {
  final CelestialObject object;

  const CelestialDetailSheet({super.key, required this.object});

  static void show(BuildContext context, CelestialObject object) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CelestialDetailSheet(object: object),
    );
  }

  @override
  ConsumerState<CelestialDetailSheet> createState() => _CelestialDetailSheetState();
}

class _CelestialDetailSheetState extends ConsumerState<CelestialDetailSheet> {
  int _depthTierIndex = 1; // 0: Quick / Novice, 1: Intermediate, 2: Deep Dive

  @override
  Widget build(BuildContext context) {
    final isRed = ref.watch(isRedLightModeProvider);
    final obj = widget.object;

    final sheetBg = isRed
        ? AstroColors.redLightSurfaceElevated
        : AstroColors.cosmosSurface;

    final sheetBorder = isRed
        ? AstroColors.redLightBorder
        : AstroColors.cosmosCardBorder;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: sheetBorder, width: 1.2),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: (isRed ? AstroColors.redLightPrimary : AstroColors.textMuted).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        obj.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${obj.alternateName} • Constellation: ${obj.constellation}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AstroBadge(
                  label: '${obj.observabilityScore}% Score',
                  color: AstroColors.auroralEmerald,
                ),
              ],
            ),
          ),

          const Divider(height: 16),

          // Real-time Telemetry Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                _buildTelemetryTile('Altitude', '${obj.altitude}°', Icons.north_east_rounded, isRed),
                const SizedBox(width: 8),
                _buildTelemetryTile('Azimuth', '${obj.azimuth}°', Icons.compass_calibration_outlined, isRed),
                const SizedBox(width: 8),
                _buildTelemetryTile('Magnitude', '${obj.magnitude}', Icons.light_mode_outlined, isRed),
                const SizedBox(width: 8),
                _buildTelemetryTile('Min Gear', obj.equipmentLabel, Icons.camera_alt_outlined, isRed),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Multi-Tier Content Depth Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurfaceElevated).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: sheetBorder),
              ),
              child: Row(
                children: [
                  _buildTabButton('Quick Look', 0, isRed),
                  _buildTabButton('Observing Guide', 1, isRed),
                  _buildTabButton('Astrophysics', 2, isRed),
                ],
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Description Card
                AstroCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _depthTierIndex == 0
                            ? 'SUMMARY OVERVIEW'
                            : _depthTierIndex == 1
                                ? 'OBSERVER CONTEXT & DETAILS'
                                : 'ASTROPHYSICAL DATA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _getDescriptionForTier(obj),
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Observation Strategy & Equipment Tip
                AstroCard(
                  borderColor: (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan).withValues(alpha: 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 18,
                            color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'HOW TO OBSERVE TONIGHT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: isRed ? AstroColors.redLightText : AstroColors.starlightCyan,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        obj.observationTip,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: isRed ? AstroColors.redLightText : AstroColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Optimal Viewing Window:',
                            style: TextStyle(
                              fontSize: 12,
                              color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                            ),
                          ),
                          Text(
                            obj.bestTimeWindow,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isRed ? AstroColors.redLightText : AstroColors.stellarGold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Distance & Physical properties
                AstroCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distance from Earth:',
                        style: TextStyle(
                          fontSize: 13,
                          color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                        ),
                      ),
                      Text(
                        obj.distance,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryTile(String title, String val, IconData icon, bool isRed) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurfaceElevated).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 14,
              color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
            ),
            const SizedBox(height: 4),
            Text(
              val,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, bool isRed) {
    final isSelected = _depthTierIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _depthTierIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan).withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? (isRed ? AstroColors.redLightText : AstroColors.textPrimary)
                  : (isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted),
            ),
          ),
        ),
      ),
    );
  }

  String _getDescriptionForTier(CelestialObject obj) {
    switch (_depthTierIndex) {
      case 0:
        return obj.descriptionBrief;
      case 1:
        return obj.descriptionIntermediate;
      case 2:
        return obj.descriptionDeep;
      default:
        return obj.descriptionBrief;
    }
  }
}
