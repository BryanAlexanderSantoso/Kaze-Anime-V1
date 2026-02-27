import 'package:flutter_test/flutter_test.dart';
import 'package:kaze_anime/main.dart';

void main() {
  testWidgets('App starts test', (WidgetTester tester) async {
    await tester.pumpWidget(const KazeAnimeApp());
    expect(find.text('KAZE V1'), findsWidgets);
  });
}
