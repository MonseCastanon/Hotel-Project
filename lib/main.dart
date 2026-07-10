import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/config/config.dart';

void main() {
  runApp(
    // ProviderScope es requerido para que Riverpod funcione en toda la app
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
      // Temas claro y oscuro con la paleta definida
      theme: AppTheme(isDarkMode: false).getTheme(),
      darkTheme: AppTheme(isDarkMode: true).getTheme(),
      themeMode: ThemeMode.light,
      // GoRouter
      routerConfig: router,
    );
  }
}
