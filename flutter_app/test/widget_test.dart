import 'package:flutter_test/flutter_test.dart';
import 'package:nova_ai_chat/main.dart';

void main() {
  testWidgets('Voxera app loads splash', (WidgetTester tester) async {
    await tester.pumpWidget(const NovaApp());
    await tester.pump();
    expect(find.text('Voxera'), findsOneWidget);
  });
}
