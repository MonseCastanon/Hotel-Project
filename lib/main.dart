import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga el archivo .env antes de iniciar la app
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: HotelApp(),
    ),
  );
}

class HotelApp extends ConsumerWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
  title: 'Hotel App',
      debugShowCheckedModeBanner: false,
      theme: const AppTheme().getTheme(),
      darkTheme: const AppTheme(isDarkMode: true).getTheme(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
