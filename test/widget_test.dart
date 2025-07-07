import 'package:flutter_test/flutter_test.dart';
import 'package:moodmap_final_gradlefix/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MoodMapApp());

    expect(find.text('Select your mood'), findsWidgets);
  });
}
