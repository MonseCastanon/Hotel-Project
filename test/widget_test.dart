import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_app/main.dart';

void main() {
  testWidgets('HotelApp smoke test — arranca sin errores',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HotelApp()),
    );
    // Si no lanza excepción, la app inicia correctamente
    expect(find.byType(HotelApp), findsOneWidget);
  });
}
