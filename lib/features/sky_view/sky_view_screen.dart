import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/astro_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../shared/widgets/astro_card.dart';
import '../tonight/models/celestial_object.dart';
import '../tonight/widgets/celestial_detail_sheet.dart';

class SkyViewScreen extends ConsumerStatefulWidget {
  const SkyViewScreen({super.key});

  @override
  ConsumerState<SkyViewScreen> createState() => _SkyViewScreenState();
}

class _SkyViewScreenState extends ConsumerState<SkyViewScreen> {
  // Pan and zoom state for sky navigation
  Offset _panOffset = Offset.zero;
  double _scale = 1.0;
  double _baseScale = 1.0;
  int _timeOffsetMinutes = 0; // Time travel offset in minutes
  bool _isGyroCompassActive = false; // Sensor gyro / compass tracking mode

  // Object list with positions on celestial sphere
  final List<_SkyMarker> _markers = [
    _SkyMarker(
      object: MockAstroData.sampleObjects[0], // Saturn
      position: const Offset(280, 260),
    ),
    _SkyMarker(
      object: MockAstroData.sampleObjects[1], // Pleiades
      position: const Offset(120, 180),
    ),
    _SkyMarker(
      object: MockAstroData.sampleObjects[2], // Jupiter
      position: const Offset(220, 380),
    ),
    _SkyMarker(
      object: MockAstroData.sampleObjects[3], // Andromeda
      position: const Offset(80, 320),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isRed = ref.watch(isRedLightModeProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Interactive Sky Canvas
          GestureDetector(
            onScaleStart: (details) {
              _baseScale = _scale;
            },
            onScaleUpdate: (details) {
              setState(() {
                _scale = (_baseScale * details.scale).clamp(0.6, 2.5);
                _panOffset += details.focalPointDelta;
              });
            },
            child: Container(
              color: isRed ? AstroColors.redLightBg : const Color(0xFF04060B),
              child: CustomPaint(
                painter: _SkyCanvasPainter(
                  isRed: isRed,
                  panOffset: _panOffset,
                  scale: _scale,
                  timeOffsetMinutes: _timeOffsetMinutes,
                  markers: _markers,
                ),
                size: Size.infinite,
              ),
            ),
          ),

          // Clickable Object Hit-Boxes overlay on top of canvas
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: _markers.map((marker) {
                      final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                      final transformed = center + (_panOffset + marker.position - center) * _scale;

                      // Only render if within screen bounds
                      if (transformed.dx < -50 ||
                          transformed.dx > constraints.maxWidth + 50 ||
                          transformed.dy < -50 ||
                          transformed.dy > constraints.maxHeight + 50) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        left: transformed.dx - 45,
                        top: transformed.dy - 20,
                        child: GestureDetector(
                          onTap: () => CelestialDetailSheet.show(context, marker.object),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurface).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isRed ? AstroColors.redLightBorder : AstroColors.starlightCyan.withValues(alpha: 0.6),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  marker.object.category == ObjectCategory.planet
                                      ? Icons.circle
                                      : Icons.blur_on,
                                  size: 10,
                                  color: isRed ? AstroColors.redLightPrimary : AstroColors.stellarGold,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  marker.object.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),

          // Top Heads-Up Display (HUD)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: AstroBadge(
                      label: _isGyroCompassActive
                          ? 'Gyro Active • Point to Sky'
                          : 'Az: 145° SE • Alt: 48° (${(_scale * 100).toInt()}%)',
                      icon: _isGyroCompassActive ? Icons.explore : Icons.explore_outlined,
                      color: _isGyroCompassActive ? AstroColors.auroralEmerald : AstroColors.starlightCyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Gyro Compass Mode Button (Point to Sky)
                  Container(
                    decoration: BoxDecoration(
                      color: (_isGyroCompassActive
                              ? (isRed ? AstroColors.redLightPrimary : AstroColors.auroralEmerald)
                              : (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurface))
                          .withValues(alpha: _isGyroCompassActive ? 0.25 : 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isGyroCompassActive
                            ? (isRed ? AstroColors.redLightPrimary : AstroColors.auroralEmerald)
                            : (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isGyroCompassActive ? Icons.explore : Icons.explore_outlined,
                        color: _isGyroCompassActive
                            ? (isRed ? AstroColors.redLightPrimary : AstroColors.auroralEmerald)
                            : (isRed ? AstroColors.redLightTextMuted : AstroColors.textPrimary),
                      ),
                      tooltip: _isGyroCompassActive ? 'Disable Gyro Tracking' : 'Enable Gyro/Compass (Point at Sky)',
                      onPressed: () {
                        setState(() {
                          _isGyroCompassActive = !_isGyroCompassActive;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            backgroundColor: isRed ? AstroColors.redLightSurfaceElevated : AstroColors.cosmosSurfaceElevated,
                            content: Text(
                              _isGyroCompassActive
                                  ? 'Compass & Gyro Tracking Mode Active — Point your phone toward the sky!'
                                  : 'Manual Touch Pan/Zoom Mode Active.',
                              style: TextStyle(
                                color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurface).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye_rounded,
                        color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                      ),
                      tooltip: 'Night Vision Mode',
                      onPressed: () => ref.read(isRedLightModeProvider.notifier).toggle(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: (isRed ? AstroColors.redLightSurface : AstroColors.cosmosSurface).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.center_focus_strong_rounded,
                        color: isRed ? AstroColors.redLightPrimary : AstroColors.textPrimary,
                      ),
                      tooltip: 'Reset Horizon View',
                      onPressed: () {
                        setState(() {
                          _panOffset = Offset.zero;
                          _scale = 1.0;
                          _timeOffsetMinutes = 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Time-Travel Control Bar HUD
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: AstroCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history_toggle_off_rounded,
                        size: 20,
                        color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time-Travel Ephemeris',
                              style: TextStyle(
                                fontSize: 11,
                                color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                              ),
                            ),
                            Text(
                              _timeOffsetMinutes == 0
                                  ? 'Live Real-Time'
                                  : '${_timeOffsetMinutes > 0 ? "+" : ""}${_timeOffsetMinutes ~/ 60}h ${_timeOffsetMinutes.remainder(60).abs()}m from Now',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_timeOffsetMinutes != 0)
                        TextButton(
                          onPressed: () => setState(() => _timeOffsetMinutes = 0),
                          child: Text(
                            'RESET',
                            style: TextStyle(
                              fontSize: 12,
                              color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Slider for fast forward / backward time travel
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbColor: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                      activeTrackColor: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                      inactiveTrackColor: (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      value: _timeOffsetMinutes.toDouble(),
                      min: -360, // 6 hours back
                      max: 360, // 6 hours forward
                      divisions: 24,
                      onChanged: (val) {
                        setState(() => _timeOffsetMinutes = val.toInt());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkyMarker {
  final CelestialObject object;
  final Offset position;
  _SkyMarker({required this.object, required this.position});
}

class _SkyCanvasPainter extends CustomPainter {
  final bool isRed;
  final Offset panOffset;
  final double scale;
  final int timeOffsetMinutes;
  final List<_SkyMarker> markers;

  _SkyCanvasPainter({
    required this.isRed,
    required this.panOffset,
    required this.scale,
    required this.timeOffsetMinutes,
    required this.markers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Translate to center, apply scale & pan, translate back
    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-center.dx + panOffset.dx, -center.dy + panOffset.dy);

    final starPaint = Paint()
      ..color = (isRed ? AstroColors.redLightPrimary : Colors.white).withValues(alpha: 0.85);

    final linePaint = Paint()
      ..color = (isRed ? AstroColors.redLightBorder : AstroColors.starlightCyan).withValues(alpha: 0.25)
      ..strokeWidth = 1.0;

    // Simulated constellation connecting lines (e.g. Taurus & Cygnus)
    final p1 = Offset(size.width * 0.28, size.height * 0.22);
    final p2 = Offset(size.width * 0.45, size.height * 0.30);
    final p3 = Offset(size.width * 0.65, size.height * 0.26);
    final p4 = Offset(size.width * 0.40, size.height * 0.42);

    canvas.drawLine(p1, p2, linePaint);
    canvas.drawLine(p2, p3, linePaint);
    canvas.drawLine(p2, p4, linePaint);

    // Primary constellation star anchors
    canvas.drawCircle(p1, 3.2, starPaint);
    canvas.drawCircle(p2, 4.2, starPaint);
    canvas.drawCircle(p3, 2.8, starPaint);
    canvas.drawCircle(p4, 3.8, starPaint);

    // Background starfield
    final backgroundStars = [
      Offset(size.width * 0.12, size.height * 0.12),
      Offset(size.width * 0.82, size.height * 0.18),
      Offset(size.width * 0.18, size.height * 0.52),
      Offset(size.width * 0.72, size.height * 0.58),
      Offset(size.width * 0.58, size.height * 0.14),
      Offset(size.width * 0.32, size.height * 0.68),
      Offset(size.width * 0.88, size.height * 0.38),
      Offset(size.width * 0.48, size.height * 0.82),
      Offset(size.width * 0.08, size.height * 0.78),
    ];

    for (final s in backgroundStars) {
      canvas.drawCircle(
        s,
        1.6,
        Paint()..color = (isRed ? AstroColors.redLightPrimary : Colors.white).withValues(alpha: 0.6),
      );
    }

    // Draw cardinal horizon indicator (SE Horizon)
    final horizonPaint = Paint()
      ..color = (isRed ? AstroColors.redLightBorder : AstroColors.cosmosCardBorder).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawLine(
      Offset(-size.width, size.height * 0.85),
      Offset(size.width * 2, size.height * 0.85),
      horizonPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SkyCanvasPainter oldDelegate) {
    return oldDelegate.isRed != isRed ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.scale != scale ||
        oldDelegate.timeOffsetMinutes != timeOffsetMinutes;
  }
}
