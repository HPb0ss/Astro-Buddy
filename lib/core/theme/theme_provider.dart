import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State notifier to toggle between standard Deep Cosmos mode
/// and night-vision preserving Red-Light mode.
class NightModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void setNightVision(bool enabled) => state = enabled;
}

final isRedLightModeProvider = NotifierProvider<NightModeNotifier, bool>(() {
  return NightModeNotifier();
});
