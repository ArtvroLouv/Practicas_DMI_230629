import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cinemapedia_app/main.dart';

void main() {
  testWidgets('Main app shows the API key field', (WidgetTester tester) async {
    dotenv.loadFromString(envString: 'THE_MOVIEDB_KEY=test-key');
    await tester.pumpWidget(const MainApp());

    expect(find.textContaining('API Key:'), findsOneWidget);
  });
}
