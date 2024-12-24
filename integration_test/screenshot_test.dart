import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medical_app/main.dart' as app;
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  ScreenshotController screenshotController = ScreenshotController();

  testWidgets('Take screenshots of all screens', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Take login screen screenshot
    await _takeScreenshot(screenshotController, 'login.png');

    // Login and navigate to dashboard
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Take dashboard screenshot
    await _takeScreenshot(screenshotController, 'dashboard.png');

    // Navigate to medications screen
    await tester.tap(find.text('Medications'));
    await tester.pumpAndSettle();
    await _takeScreenshot(screenshotController, 'medications.png');

    // Navigate to schedule screen
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    await _takeScreenshot(screenshotController, 'schedule.png');

    // Navigate to pharmacy screen
    await tester.tap(find.text('Pharmacy'));
    await tester.pumpAndSettle();
    await _takeScreenshot(screenshotController, 'pharmacy.png');

    // Navigate to settings screen
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await _takeScreenshot(screenshotController, 'settings.png');
  });
}

Future<void> _takeScreenshot(ScreenshotController controller, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final String path = '${directory.path}/screenshots';
  await Directory(path).create(recursive: true);
  
  final bytes = await controller.capture();
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes!);
  print('Screenshot saved: $path/$fileName');
}
