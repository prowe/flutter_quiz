import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_client/question_panel.dart';

void main() {
  testWidgets('User answers a question correctly', (WidgetTester tester) async {
    await tester.pumpWidget(QuestionPanel());

    expect(find.text('What is the best color'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Green'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    expect(find.text('Orange'), findsOneWidget);

    await tester.tap(find.text('Orange'));
    await tester.pump();
  });
}
