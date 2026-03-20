import 'package:chatting/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders ChatX onboarding flow', (WidgetTester tester) async {
    await tester.pumpWidget(const ChattingApp());
    expect(find.text('ChatX'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
