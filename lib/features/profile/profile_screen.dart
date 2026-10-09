import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/astro_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../shared/widgets/astro_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedGearIndex = 1; // Default: 10x50 Binoculars
  int _selectedBortle = 4; // Default: Suburban Bortle 4

  final List<Map<String, dynamic>> _gearProfiles = [
    {
      'title': 'Unaided Eyes (Naked Eye)',
      'subtitle': 'Aperture: 7mm pupil • Limiting Mag ~5.5-6.0',
      'icon': Icons.visibility_outlined,
      'badge': 'Naked Eye',
    },
    {
      'title': 'Celestron UpClose G2 10×50',
      'subtitle': 'Porro Prism • 50mm Aperture • Limiting Mag ~10.5',
      'icon': Icons.camera_alt_outlined,
      'badge': 'Binoculars',
    },
    {
      'title': 'Sky-Watcher Heritage 150p (6")',
      'subtitle': 'Newtonian Reflector • 150mm Aperture • Limiting Mag ~13.4',
      'icon': Icons.lens_blur_outlined,
      'badge': 'Telescope',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isRed = ref.watch(isRedLightModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observatory & Profile'),
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
          // Active Gear Selector
          AstroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'ACTIVE OBSERVING OPTICS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const AstroBadge(
                      label: 'Auto-Filters Targets',
                      color: AstroColors.starlightCyan,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._gearProfiles.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final gear = entry.value;
                  final isSelected = _selectedGearIndex == idx;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGearIndex = idx),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan).withValues(alpha: 0.18)
                              : (isRed ? AstroColors.redLightSurfaceElevated : AstroColors.cosmosSurfaceElevated).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan)
                                : (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              gear['icon'] as IconData,
                              size: 20,
                              color: isSelected
                                  ? (isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan)
                                  : (isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gear['title'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    gear['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Location & Light Pollution Configuration
          AstroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LIGHT POLLUTION (BORTLE CLASS)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                      ),
                    ),
                    AstroBadge(
                      label: 'Bortle $_selectedBortle',
                      color: AstroColors.nebulaPurple,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedBortle <= 2
                      ? 'Truly Dark Sky: Zodiacal light vivid, Milky Way casts diffuse shadows.'
                      : _selectedBortle <= 4
                          ? 'Suburban Sky: Milky Way visible near zenith; M31 easily visible with direct vision.'
                          : _selectedBortle <= 6
                              ? 'Bright Suburban: Milky Way washed out; only bright stars and planets visible.'
                              : 'Inner City: Heavy light pollution; moon and bright planets only.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isRed ? AstroColors.redLightText : AstroColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: isRed ? AstroColors.redLightPrimary : AstroColors.nebulaPurple,
                    activeTrackColor: isRed ? AstroColors.redLightPrimary : AstroColors.nebulaPurple,
                    inactiveTrackColor: (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _selectedBortle.toDouble(),
                    min: 1,
                    max: 9,
                    divisions: 8,
                    label: 'Bortle $_selectedBortle',
                    onChanged: (val) {
                      setState(() => _selectedBortle = val.toInt());
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bortle 1 (Dark Reserve)',
                      style: TextStyle(
                        fontSize: 10,
                        color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                      ),
                    ),
                    Text(
                      'Bortle 9 (City Center)',
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

          const SizedBox(height: 16),

          // Observation Log Summary
          AstroCard(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildStatColumn('Observations', '14', isRed)),
                _buildStatDivider(isRed),
                Expanded(child: _buildStatColumn('Total XP', '340', isRed)),
                _buildStatDivider(isRed),
                Expanded(child: _buildStatColumn('Badge Rank', 'Novice', isRed)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String title, String val, bool isRed) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(bool isRed) {
    return Container(
      width: 1,
      height: 28,
      color: (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder).withValues(alpha: 0.6),
    );
  }
}
