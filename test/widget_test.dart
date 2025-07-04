import 'package:flutter_test/flutter_test.dart';
import 'package:moodmap_clean_new/main.dart';

void main() {
  testWidgets('App loads and shows MoodSelector', (WidgetTester tester) async {
    await tester.pumpWidget(const MoodMapApp());

    // Перевіряємо, що на екрані є текст "MoodMap"
    expect(find.text('MoodMap'), findsOneWidget);

    // Або можна шукати віджет MoodSelector
    expect(find.byType(MoodSelector), findsOneWidget);
  });
}
