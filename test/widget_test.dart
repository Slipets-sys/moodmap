import 'package:flutter_test/flutter_test.dart';

import 'package:moodmap_clean_new/main.dart';

void main() {
  testWidgets('App loads and shows HomePage', (WidgetTester tester) async {
    await tester.pumpWidget(const MoodMapApp());

    expect(find.byType(HomePage), findsOneWidget);
  });
}
