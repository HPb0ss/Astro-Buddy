import 'package:flutter_test/flutter_test.dart';
import 'package:astro_buddy/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('AstroBuddy app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AstroBuddyApp()));
    expect(find.text('Tonight’s Sky'), findsOneWidget);
  });
}
