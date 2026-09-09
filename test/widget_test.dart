import 'package:dealer_app/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Dealer app opens login screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Dealer Login'), findsOneWidget);
    expect(find.text('Bawaskar Dealer'), findsOneWidget);
  });
}
