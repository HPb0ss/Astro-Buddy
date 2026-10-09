import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/astro_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../shared/widgets/astro_card.dart';
import '../tonight/models/celestial_object.dart';
import '../tonight/widgets/celestial_detail_sheet.dart';

class QuestItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final int xp;
  final bool isCompleted;
  final CelestialObject? linkedObject;

  const QuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.xp,
    required this.isCompleted,
    this.linkedObject,
  });
}

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  late List<QuestItem> _quests;

  @override
  void initState() {
    super.initState();
    _quests = [
      QuestItem(
        id: 'q1',
        title: 'Spot the Crescent Moon',
        description: 'Observe earthshine and lunar craters along the terminator line.',
        category: 'Naked Eye / Binoculars',
        xp: 30,
        isCompleted: true,
        linkedObject: MockAstroData.sampleObjects[4],
      ),
      QuestItem(
        id: 'q2',
        title: 'Identify Saturn in the Southeast',
        description: 'Locate Saturn at 48° altitude and distinguish its oval shape.',
        category: 'Binoculars Challenge',
        xp: 50,
        isCompleted: false,
        linkedObject: MockAstroData.sampleObjects[0],
      ),
      QuestItem(
        id: 'q3',
        title: 'Find the Pleiades Open Cluster',
        description: 'Use averted vision to count at least 8 distinct stars in M45.',
        category: 'Deep Sky Gateway',
        xp: 60,
        isCompleted: false,
        linkedObject: MockAstroData.sampleObjects[1],
      ),
      QuestItem(
        id: 'q4',
        title: 'Trace Jupiter’s Four Galilean Moons',
        description: 'Observe Io, Europa, Ganymede, and Callisto in orbit.',
        category: 'Planetary Dynamics',
        xp: 75,
        isCompleted: false,
        linkedObject: MockAstroData.sampleObjects[2],
      ),
    ];
  }

  void _toggleQuestCompletion(int index) {
    setState(() {
      final q = _quests[index];
      _quests[index] = QuestItem(
        id: q.id,
        title: q.title,
        description: q.description,
        category: q.category,
        xp: q.xp,
        isCompleted: !q.isCompleted,
        linkedObject: q.linkedObject,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRed = ref.watch(isRedLightModeProvider);

    final completedCount = _quests.where((q) => q.isCompleted).length;
    final totalXp = _quests.where((q) => q.isCompleted).fold(0, (sum, q) => sum + q.xp);
    final progressFraction = completedCount / _quests.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observing Quests & Skills'),
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
          // Path Progress Hero Card
          AstroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ACTIVE PATH: NOVICE STARGAZER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                      ),
                    ),
                    AstroBadge(
                      label: '$totalXp XP',
                      color: AstroColors.stellarGold,
                      icon: Icons.star_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'The Stargazer’s First Steps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Progressive milestones conditioned on what is actually observable from your location tonight.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isRed ? AstroColors.redLightText : AstroColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedCount of ${_quests.length} Completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                      ),
                    ),
                    Text(
                      '${(progressFraction * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    minHeight: 8,
                    backgroundColor: isRed ? AstroColors.redLightSurfaceElevated : AstroColors.cosmosSurfaceElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isRed ? AstroColors.redLightPrimary : AstroColors.starlightCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Tonight’s Observable Challenges',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap checkmark to log, or tap card to view object guide.',
            style: TextStyle(
              fontSize: 12,
              color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Quest Cards List
          ..._quests.asMap().entries.map((entry) {
            final index = entry.key;
            final quest = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AstroCard(
                borderColor: quest.isCompleted
                    ? (isRed ? AstroColors.redLightBorder : AstroColors.auroralEmerald.withValues(alpha: 0.4))
                    : null,
                onTap: quest.linkedObject != null
                    ? () => CelestialDetailSheet.show(context, quest.linkedObject!)
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleQuestCompletion(index),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, right: 12),
                        child: Icon(
                          quest.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 26,
                          color: quest.isCompleted
                              ? (isRed ? AstroColors.redLightPrimary : AstroColors.auroralEmerald)
                              : (isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  quest.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                                    color: isRed ? AstroColors.redLightText : AstroColors.textPrimary,
                                  ),
                                ),
                              ),
                              AstroBadge(
                                label: '+${quest.xp} XP',
                                color: AstroColors.stellarGold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            quest.description,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              color: isRed ? AstroColors.redLightTextMuted : AstroColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                quest.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isRed ? AstroColors.redLightTextMuted : AstroColors.starlightCyan,
                                ),
                              ),
                              if (quest.linkedObject != null) ...[
                                Text(
                                  ' • Tap for Guide',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isRed ? AstroColors.redLightTextMuted : AstroColors.textMuted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
