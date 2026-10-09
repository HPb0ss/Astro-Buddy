import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/astro_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/sky_view/sky_view_screen.dart';
import 'features/tonight/tonight_screen.dart';
import 'features/learn/learn_screen.dart';
import 'features/ai_companion/ai_companion_screen.dart';
import 'features/profile/profile_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AstroBuddyApp(),
    ),
  );
}

class AstroBuddyApp extends ConsumerWidget {
  const AstroBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRedLight = ref.watch(isRedLightModeProvider);

    return MaterialApp(
      title: 'Astro Buddy',
      debugShowCheckedModeBanner: false,
      theme: isRedLight
          ? AstroTheme.redLightObservationTheme
          : AstroTheme.deepCosmosTheme,
      home: const MainShellNavigation(),
    );
  }
}

class MainShellNavigation extends StatefulWidget {
  const MainShellNavigation({super.key});

  @override
  State<MainShellNavigation> createState() => _MainShellNavigationState();
}

class _MainShellNavigationState extends State<MainShellNavigation> {
  int _currentIndex = 1; // Default to 'Tonight' (Observability Hub)

  final List<Widget> _screens = const [
    SkyViewScreen(),
    TonightScreen(),
    LearnScreen(),
    AiCompanionScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.stars_outlined),
            activeIcon: Icon(Icons.stars_rounded),
            label: 'Sky Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight_outlined),
            activeIcon: Icon(Icons.nightlight_round),
            label: 'Tonight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school_rounded),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: 'AI Companion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_outlined),
            activeIcon: Icon(Icons.tune),
            label: 'Gear',
          ),
        ],
      ),
    );
  }
}
