import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/astro_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../shared/widgets/astro_card.dart';
import 'models/celestial_object.dart';
import 'widgets/celestial_detail_sheet.dart';

class TonightScreen extends ConsumerStatefulWidget {
  const TonightScreen({super.key});

  @override
  ConsumerState<TonightScreen> createState() => _TonightScreenState();
}

class _TonightScreenState extends ConsumerState<TonightScreen> {
  int _selectedHourIndex = 3; // Defaults to 10 PM
  String _selectedCategoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final isRed = ref.watch(isRedLightModeProvider);
    final hourly = MockAstroData.tonightHourlyForecast;
    final currentHourData = hourly[_selectedHourIndex];

    // Filter celestial objects based on chosen category
    final filteredObjects = MockAstroData.sampleObjects.where((obj) {
      if (_selectedCategoryFilter == 'Planets') return obj.category == ObjectCategory.planet;
      if (_selectedCategoryFilter == 'Deep Sky') return obj.category == ObjectCategory.deepSky;
      if (_selectedCategoryFilter == 'Moon') return obj.category == ObjectCategory.moon;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tonight’s Sky'),
        actions: [
          IconButton(
            tooltip: 'Toggle Field Red-Light Mode',
            icon: Icon(
              Icons.remove_red_eye_rounded,
              color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
            ),
            onPressed: () => ref.read(isRedLightModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Observability Score Hero Card
          AstroCard(
            borderColor: isRed
                ? AstroColors.redLightPrimary
                : AstroColors.auroralEmerald.withValues(alpha: 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OBSERVABILITY INDEX',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: isRed
                            ? AstroColors.redLightTextMuted
                            : AstroColors.textSecondary,
                      ),
                    ),
                    AstroBadge(
                      label: currentHourData.score >= 80 ? 'EXCELLENT' : 'MODERATE',
                      color: currentHourData.score >= 80
                          ? AstroColors.auroralEmerald
                          : AstroColors.stellarGold,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${currentHourData.score}',
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        color: isRed
                            ? AstroColors.redLightPrimary
                            : AstroColors.textPrimary,
                      ),
                    ),
                    Text(
                      ' /100',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isRed
                            ? AstroColors.redLightTextMuted
                            : AstroColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isRed ? AstroColors.redLightSurfaceElevated : AstroColors.cosmosSurfaceElevated),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'At ${currentHourData.hourLabel}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isRed ? AstroColors.redLightText : AstroColors.starlightCyan,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Multi-factor calculation: Cloud cover ${currentHourData.cloudCover.toInt()}%, Moon separation 74°, Bortle 4 local sky brightness, and negligible atmospheric extinction.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isRed
                        ? AstroColors.redLightText
                        : AstroColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Multi-Factor Observability Indicators
          Row(
            children: [
              Expanded(
                child: AstroCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.cloud_outlined,
                            size: 16,
                            color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Clouds',
                            style: TextStyle(
                              fontSize: 12,
                              color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${currentHourData.cloudCover.toInt()}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AstroCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.brightness_3_outlined,
                            size: 16,
                            color: isRed ? AstroColors.redLightPrimary : AstroColors.stellarGold,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Moon',
                            style: TextStyle(
                              fontSize: 12,
                              color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentHourData.isMoonUp ? '12% Up' : 'Set (Dark)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AstroCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: isRed ? AstroColors.redLightPrimary : AstroColors.nebulaPurple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Sky Dark',
                            style: TextStyle(
                              fontSize: 12,
                              color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Bortle 4',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Hourly Timeline Scrubber Bar
          Text(
            'Timeline & Optimal Viewing Window',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 88,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourly.length,
              itemBuilder: (context, index) {
                final item = hourly[index];
                final isSelected = index == _selectedHourIndex;

                return GestureDetector(
                  onTap: () => setState(() => _selectedHourIndex = index),
                  child: Container(
                    width: 64,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan).withValues(alpha: 0.22)
                          : (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurface).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan)
                            : (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          item.hourLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? (isRed ? AstroColors.redLightText : AstroColors.textPrimary)
                                : (isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted),
                          ),
                        ),
                        Text(
                          '${item.score}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: item.score >= 80
                                ? (isRed ? AstroColors.redLightPrimary : AstroColors.auroralEmerald)
                                : (isRed ? AstroColors.redLightTextMuted : AstroColors.stellarGold),
                          ),
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.cloudCover < 10
                                ? (isRed ? AstroColors.redLightPrimary : AstroColors.auroralEmerald)
                                : (isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          // Recommended Targets section with Category Filter Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Visible For Your Gear',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                ),
              ),
              const AstroBadge(
                label: 'Binoculars 10x50',
                icon: Icons.camera_alt_outlined,
                color: AstroColors.starlightCyan,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Planets', 'Deep Sky', 'Moon'].map((filter) {
                final isSelected = _selectedCategoryFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan).withValues(alpha: 0.25),
                    backgroundColor: isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurfaceElevated,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? (isRed ? AstroColors.redLightText : AstroColors.textPrimary)
                          : (isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategoryFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Celestial Objects List
          ...filteredObjects.map((obj) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AstroCard(
                  onTap: () => CelestialDetailSheet.show(context, obj),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isRed
                                  ? AstroColors.redLightPrimary
                                  : obj.category == ObjectCategory.planet
                                      ? AstroColors.stellarGold
                                      : AstroColors.nebulaPurple)
                              .withValues(alpha: 0.15),
                        ),
                        child: Icon(
                          obj.category == ObjectCategory.planet
                              ? Icons.circle
                              : obj.category == ObjectCategory.moon
                                  ? Icons.brightness_3
                                  : Icons.blur_on_rounded,
                          color: isRed
                              ? AstroColors.redLightPrimary
                              : obj.category == ObjectCategory.planet
                                  ? AstroColors.stellarGold
                                  : AstroColors.nebulaPurple,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              obj.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Alt: ${obj.altitude}° • Mag: ${obj.magnitude} • ${obj.constellation}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AstroBadge(
                            label: '${obj.observabilityScore}% Score',
                            color: AstroColors.auroralEmerald,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            obj.equipmentLabel,
                            style: TextStyle(
                              fontSize: 10,
                              color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
