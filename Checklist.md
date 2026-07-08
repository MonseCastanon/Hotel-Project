# Checklist del Proyecto Hotel App

> Documento generado el 2026-07-07  
> Basado en [DOCUMENTACION.md](./DOCUMENTACION.md) y los requerimientos del plan de ejecución.

---

## Leyenda

| Icono | Significado |
|-------|-------------|
| ✅ | Completado |
| ⚠️ | Parcialmente completado |
| ❌ | Falta por hacer |

---

## 1. Crear el proyecto Flutter desde cero

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1.1 | Inicializar la aplicación Flutter | ✅ | Proyecto creado con `flutter create` |
| 1.2 | Configurar la estructura base del proyecto | ⚠️ | Carpetas creadas pero archivos barrel vacíos y `main.dart` sin modificar |

---

## 2. Configurar Git y GitHub

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 2.1 | Inicializar repositorio Git | ✅ | `.git/` presente |
| 2.2 | Crear repositorio remoto en GitHub | ✅ | `origin` → `https://github.com/MonseCastanon/Hotel-Project.git` |
| 2.3 | Configurar ramas de trabajo (main, develop, feature) | ✅ | Ramas `main`, `develop`, `feature/project-foundation` existen local y remoto |
| 2.4 | Realizar primer commit y push | ✅ | 3 commits realizados y push hecho |
| 2.5 | Configurar `.gitignore` correctamente | ✅ | `.gitignore` limpio y organizado |

---

## 3. Definir la arquitectura del proyecto (Clean Architecture)

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 3.1 | Crear la estructura de carpetas | ⚠️ | Carpetas principales existen, pero faltan subcarpetas por módulo |
| 3.2 | Capa `presentation` | ⚠️ | Carpetas `providers/`, `screens/`, `widgets/`, `views/` creadas pero vacías; faltan subcarpetas por módulo (auth, dashboard, rooms, etc.) |
| 3.3 | Capa `domain` | ⚠️ | Carpetas `datasource/`, `entities/`, `repositories/` creadas pero vacías |
| 3.4 | Capa `infrastructure` (data) | ⚠️ | Carpetas `datasource/`, `mappers/`, `models/`, `repositories/` creadas pero vacías; faltan subcarpetas por módulo en `models/` |
| 3.5 | Capa `config` | ⚠️ | Carpetas `constants/`, `helpers/`, `routers/`, `services/`, `theme/` creadas; sólo `theme/app_theme.dart` tiene código |
| 3.6 | Archivos barrel (exports) | ⚠️ | Existen `config.dart`, `domain.dart`, `infraestructure.dart`, `provider.dart`, `screens.dart`, `widgets.dart`, `views.dart` pero todos están vacíos |

### Guía para completar 3.1–3.6: Subcarpetas por módulo

Según la documentación, se necesitan las siguientes subcarpetas que **NO existen** actualmente:

```
lib/
├── infrastructure/
│   └── models/
│       ├── auth/
│       ├── room/
│       ├── reservation/
│       ├── notification/
│       └── wear/
│
└── presentation/
    ├── providers/
    │   ├── auth/
    │   ├── dashboard/
    │   ├── rooms/
    │   ├── reservations/
    │   ├── notifications/
    │   └── wear/
    │
    ├── screens/
    │   ├── auth/
    │   ├── dashboard/
    │   ├── rooms/
    │   ├── reservations/
    │   ├── notifications/
    │   ├── profile/
    │   └── wear/
    │
    └── widgets/
        ├── shared/
        ├── rooms/
        ├── reservations/
        ├── dashboard/
        └── wear/
```

**Comandos para crear las subcarpetas:**

```powershell
# infrastructure/models
mkdir lib\infrastructure\models\auth
mkdir lib\infrastructure\models\room
mkdir lib\infrastructure\models\reservation
mkdir lib\infrastructure\models\notification
mkdir lib\infrastructure\models\wear

# presentation/providers
mkdir lib\presentation\providers\auth
mkdir lib\presentation\providers\dashboard
mkdir lib\presentation\providers\rooms
mkdir lib\presentation\providers\reservations
mkdir lib\presentation\providers\notifications
mkdir lib\presentation\providers\wear

# presentation/screens
mkdir lib\presentation\screens\auth
mkdir lib\presentation\screens\dashboard
mkdir lib\presentation\screens\rooms
mkdir lib\presentation\screens\reservations
mkdir lib\presentation\screens\notifications
mkdir lib\presentation\screens\profile
mkdir lib\presentation\screens\wear

# presentation/widgets
mkdir lib\presentation\widgets\shared
mkdir lib\presentation\widgets\rooms
mkdir lib\presentation\widgets\reservations
mkdir lib\presentation\widgets\dashboard
mkdir lib\presentation\widgets\wear
```

> **Nota:** Git no trackea carpetas vacías. Agrega un archivo `.gitkeep` en cada carpeta vacía si quieres que se mantengan en el repositorio:
> ```powershell
> Get-ChildItem -Directory -Recurse lib | Where-Object { (Get-ChildItem $_.FullName).Count -eq 0 } | ForEach-Object { New-Item -Path "$($_.FullName)\.gitkeep" -ItemType File }
> ```

---

## 4. Configurar dependencias principales

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 4.1 | flutter_riverpod | ✅ | `^3.0.3` |
| 4.2 | go_router | ✅ | `^17.0.1` |
| 4.3 | dio | ✅ | `^5.9.0` |
| 4.4 | flutter_dotenv | ✅ | `^6.0.0` |
| 4.5 | shared_preferences | ✅ | `^2.5.3` |
| 4.6 | hive + hive_flutter | ✅ | `^2.2.3` / `^1.1.0` |
| 4.7 | flutter_screenutil | ✅ | `^5.9.3` |
| 4.8 | flutter_svg | ✅ | `^2.2.1` |
| 4.9 | google_fonts | ✅ | `^6.3.1` |
| 4.10 | intl | ✅ | `^0.20.2` |
| 4.11 | logger | ✅ | `^2.6.1` |
| 4.12 | connectivity_plus | ✅ | `^7.0.0` |
| 4.13 | flutter_lints (dev) | ✅ | `^6.0.0` |
| 4.14 | Instalar dependencias (`flutter pub get`) | ✅ | `pubspec.lock` existe |
| 4.15 | Validar que el proyecto compile correctamente | ❌ | `main.dart` tiene código boilerplate con errores de sintaxis (línea 31: `.fromSeed` sin `ColorScheme`) |

### Guía para completar 4.15: Corregir `main.dart`

El archivo `main.dart` actual es el boilerplate generado por Flutter y tiene un error de sintaxis en la línea 31:

```dart
// ❌ Incorrecto (actual)
colorScheme: .fromSeed(seedColor: Colors.deepPurple),

// ✅ Correcto
colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
```

Además, el `main.dart` debería ser reescrito completamente para usar la arquitectura del proyecto (Riverpod, GoRouter, AppTheme, etc.). Ver la sección 5 y 6 para más detalles.

---

## 5. Configurar Riverpod

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 5.1 | Instalar dependencia | ✅ | `flutter_riverpod: ^3.0.3` en `pubspec.yaml` |
| 5.2 | Configurar `ProviderScope` en `main.dart` | ❌ | `main.dart` no tiene `ProviderScope` |
| 5.3 | Crear providers base | ❌ | Carpeta `providers/` vacía |
| 5.4 | Definir estructura para manejo de estados | ❌ | No hay providers ni state notifiers creados |

### Guía para completar 5.2–5.4

**5.2 — Envolver la app con `ProviderScope`:**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

**5.3 — Crear providers base:**

Crear al menos un provider de autenticación inicial:

```dart
// lib/presentation/providers/auth/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.checking,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.checking);
    // TODO: Implementar lógica de login con repositorio
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  void logout() {
    state = state.copyWith(status: AuthStatus.notAuthenticated);
  }

  void checkAuthStatus() {
    // TODO: Verificar token almacenado
    state = state.copyWith(status: AuthStatus.notAuthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
```

**5.4 — Estructura recomendada para providers:**

Crear un provider por módulo con su correspondiente state:

```
lib/presentation/providers/
├── auth/
│   └── auth_provider.dart
├── dashboard/
│   └── dashboard_provider.dart
├── rooms/
│   └── rooms_provider.dart
├── reservations/
│   └── reservations_provider.dart
├── notifications/
│   └── notifications_provider.dart
└── wear/
    └── wear_provider.dart
```

---

## 6. Configurar GoRouter

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 6.1 | Instalar dependencia | ✅ | `go_router: ^17.0.1` en `pubspec.yaml` |
| 6.2 | Implementar navegación (crear router) | ❌ | Carpeta `config/routers/` vacía |
| 6.3 | Crear rutas principales | ❌ | No hay rutas definidas |
| 6.4 | Configurar protección de rutas (guards) | ❌ | No hay guards implementados |

### Guía para completar 6.2–6.4

**6.2 — Crear el archivo del router:**

```dart
// lib/config/routers/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importar screens (cuando existan)
// import 'package:hotel_app/presentation/screens/auth/login_screen.dart';
// import 'package:hotel_app/presentation/screens/dashboard/dashboard_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Placeholder(), // LoginScreen()
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const Placeholder(), // SplashScreen()
      ),
      ShellRoute(
        builder: (context, state, child) => const Placeholder(), // MainLayout(child)
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const Placeholder(), // DashboardScreen()
          ),
          GoRoute(
            path: '/rooms',
            name: 'rooms',
            builder: (context, state) => const Placeholder(), // RoomsScreen()
          ),
          GoRoute(
            path: '/rooms/:id',
            name: 'room-detail',
            builder: (context, state) => const Placeholder(), // RoomDetailScreen()
          ),
          GoRoute(
            path: '/reservations',
            name: 'reservations',
            builder: (context, state) => const Placeholder(), // ReservationsScreen()
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const Placeholder(), // NotificationsScreen()
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const Placeholder(), // ProfileScreen()
          ),
        ],
      ),
    ],
    // 6.4 — Guard / Redirect
    redirect: (context, state) {
      // final isAuthenticated = authState.status == AuthStatus.authenticated;
      // final isLoggingIn = state.matchedLocation == '/login';
      //
      // if (!isAuthenticated && !isLoggingIn) return '/login';
      // if (isAuthenticated && isLoggingIn) return '/dashboard';
      return null;
    },
  );
});
```

**6.3 — Rutas principales requeridas según la documentación:**

| Ruta | Pantalla |
|------|----------|
| `/splash` | Splash |
| `/login` | Login |
| `/dashboard` | Dashboard |
| `/rooms` | Habitaciones |
| `/rooms/:id` | Detalle de habitación |
| `/rooms/:id/checkin` | Check-in |
| `/rooms/:id/checkout` | Check-out |
| `/reservations` | Reservaciones |
| `/notifications` | Notificaciones |
| `/profile` | Perfil |

**6.4 — Integrar el router en `main.dart`:**

```dart
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme().getTheme(),
    );
  }
}
```

---

## 7. Configurar tema global de la aplicación

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 7.1 | Crear colores del tema | ❌ | No existe archivo de colores |
| 7.2 | Crear estilos y tipografías generales | ❌ | No existe archivo de tipografías |
| 7.3 | Definir `ThemeData` completo | ⚠️ | `app_theme.dart` existe pero es muy básico (sólo `colorSchemeSeed` y `brightness`) |
| 7.4 | Aplicar configuración global en `main.dart` | ❌ | `main.dart` no usa `AppTheme` |
| 7.5 | Integrar Material Design 3 | ⚠️ | `useMaterial3` no está explícitamente activado (es default en Flutter 3.x, pero debería ser explícito) |

### Guía para completar 7.1–7.5

**7.1 — Crear archivo de colores:**

```dart
// lib/config/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Colores primarios del hotel
  static const Color primary = Color(0xFF1A365D);       // Azul profundo
  static const Color primaryLight = Color(0xFF2B6CB0);
  static const Color primaryDark = Color(0xFF0D1B2A);

  // Colores secundarios
  static const Color secondary = Color(0xFFC69749);     // Dorado
  static const Color secondaryLight = Color(0xFFE8C97A);

  // Colores de estado
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);

  // Colores de fondo
  static const Color background = Color(0xFFF7FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF0F4F8);

  // Colores de texto
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);

  // Estados de habitación
  static const Color roomAvailable = Color(0xFF38A169);
  static const Color roomOccupied = Color(0xFFE53E3E);
  static const Color roomCleaning = Color(0xFFD69E2E);
  static const Color roomMaintenance = Color(0xFF805AD5);
}
```

**7.2 — Crear archivo de tipografía:**

```dart
// lib/config/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.inter(fontSize: 16),
    bodyMedium: GoogleFonts.inter(fontSize: 14),
    bodySmall: GoogleFonts.inter(fontSize: 12),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
  );
}
```

**7.3 — Completar `AppTheme`:**

```dart
// lib/config/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // Tema claro
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Tema oscuro
  ThemeData getDarkTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    brightness: Brightness.dark,
    textTheme: AppTextStyles.textTheme,
  );
}
```

---

## 8. Configurar assets

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 8.1 | Crear carpeta de recursos (`assets/`) | ❌ | No existe directorio `assets/` |
| 8.2 | Crear subcarpetas (images, icons, fonts, svg) | ❌ | — |
| 8.3 | Agregar imágenes, iconos y archivos necesarios | ❌ | — |
| 8.4 | Configurar assets en `pubspec.yaml` | ⚠️ | Solo `.env` está declarado como asset |

### Guía para completar 8.1–8.4

**8.1 y 8.2 — Crear estructura de assets:**

```powershell
mkdir assets
mkdir assets\images
mkdir assets\icons
mkdir assets\svg
mkdir assets\fonts
```

**8.3 — Agregar archivos placeholder:**

Agregar al menos un logo o ícono del hotel como placeholder en `assets/images/`.

**8.4 — Actualizar `pubspec.yaml`:**

```yaml
flutter:
  uses-material-design: true

  assets:
    - .env
    - assets/images/
    - assets/icons/
    - assets/svg/

  # Si se usan fuentes locales (opcional, google_fonts descarga dinámicamente)
  # fonts:
  #   - family: Poppins
  #     fonts:
  #       - asset: assets/fonts/Poppins-Regular.ttf
  #       - asset: assets/fonts/Poppins-Bold.ttf
  #         weight: 700
```

---

## 9. Implementar autenticación (Login)

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 9.1 | Crear modelo `User` | ❌ | Carpeta `domain/entities/` vacía |
| 9.2 | Crear pantalla de Login | ❌ | No existe `screens/auth/` |
| 9.3 | Crear pantalla de Splash | ❌ | No existe `screens/auth/` |
| 9.4 | Configurar flujo de autenticación | ❌ | No hay provider de autenticación |
| 9.5 | Manejar sesión del usuario (token storage) | ❌ | No hay servicio de almacenamiento |

### Guía para completar 9.1–9.5

**9.1 — Crear entidad User:**

```dart
// lib/domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role; // admin, receptionist, housekeeper, maintenance
  final String? avatarUrl;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
  });
}
```

**9.2 — Crear pantalla de Login:**

```dart
// lib/presentation/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const Icon(Icons.hotel, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Hotel App',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 48),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo electrónico';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: ref.read(authProvider.notifier).login(...)
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Iniciar Sesión'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

**9.5 — Crear servicio de almacenamiento de sesión:**

```dart
// lib/config/services/key_value_storage_service.dart
abstract class KeyValueStorageService {
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getKeyValue<T>(String key);
  Future<bool> removeKey(String key);
}

// lib/config/services/key_value_storage_service_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

class KeyValueStorageServiceImpl implements KeyValueStorageService {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getKeyValue<T>(String key) async {
    final prefs = await getSharedPrefs();
    switch (T) {
      case const (int):
        return prefs.getInt(key) as T?;
      case const (String):
        return prefs.getString(key) as T?;
      case const (bool):
        return prefs.getBool(key) as T?;
      default:
        throw UnimplementedError('GET not implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();
    switch (T) {
      case const (int):
        prefs.setInt(key, value as int);
      case const (String):
        prefs.setString(key, value as String);
      case const (bool):
        prefs.setBool(key, value as bool);
      default:
        throw UnimplementedError('SET not implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }
}
```

---

## 10. Crear modelos base del dominio

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 10.1 | Entidad `User` | ❌ | No creada |
| 10.2 | Entidad `Room` | ❌ | No creada |
| 10.3 | Entidad `Reservation` | ❌ | No creada |
| 10.4 | Entidad `Task` | ❌ | No creada |
| 10.5 | Entidad `Notification` | ❌ | No creada |
| 10.6 | Entidad `WearTask` | ❌ | No creada (documentación la incluye) |

### Guía para completar 10.1–10.6

Crear cada entidad en `lib/domain/entities/`:

```dart
// lib/domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
  });
}
```

```dart
// lib/domain/entities/room.dart
enum RoomStatus { available, occupied, cleaning, maintenance, reserved }

class Room {
  final String id;
  final String number;
  final String type; // single, double, suite
  final int floor;
  final RoomStatus status;
  final double pricePerNight;
  final String? currentGuestId;
  final String? notes;

  Room({
    required this.id,
    required this.number,
    required this.type,
    required this.floor,
    required this.status,
    required this.pricePerNight,
    this.currentGuestId,
    this.notes,
  });
}
```

```dart
// lib/domain/entities/reservation.dart
enum ReservationStatus { pending, confirmed, checkedIn, checkedOut, cancelled }

class Reservation {
  final String id;
  final String guestName;
  final String guestEmail;
  final String roomId;
  final DateTime checkIn;
  final DateTime checkOut;
  final ReservationStatus status;
  final int numberOfGuests;
  final String? specialRequests;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.guestName,
    required this.guestEmail,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.numberOfGuests,
    this.specialRequests,
    required this.createdAt,
  });
}
```

```dart
// lib/domain/entities/task.dart
enum TaskStatus { pending, inProgress, completed, cancelled }
enum TaskPriority { low, medium, high, urgent }

class Task {
  final String id;
  final String title;
  final String description;
  final String? roomId;
  final String? assignedTo;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.roomId,
    this.assignedTo,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.completedAt,
  });
}
```

```dart
// lib/domain/entities/notification.dart
enum NotificationType { task, reservation, alert, system }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedId;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.relatedId,
  });
}
```

```dart
// lib/domain/entities/wear_task.dart
class WearTask {
  final String id;
  final String taskId;
  final String title;
  final String roomNumber;
  final String status;
  final DateTime assignedAt;

  WearTask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.roomNumber,
    required this.status,
    required this.assignedAt,
  });
}
```

---

## 11. Crear Dashboard principal

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 11.1 | Diseñar pantalla principal después del login | ❌ | No existe `screens/dashboard/` |
| 11.2 | Integrar navegación hacia módulos principales | ❌ | — |

### Guía para completar 11.1–11.2

```dart
// lib/presentation/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navegar a notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Navegar a perfil
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    icon: Icons.bed,
                    title: 'Habitaciones',
                    subtitle: 'Gestionar',
                    onTap: () {/* TODO: context.push('/rooms') */},
                  ),
                  _DashboardCard(
                    icon: Icons.calendar_today,
                    title: 'Reservaciones',
                    subtitle: 'Ver todas',
                    onTap: () {/* TODO: context.push('/reservations') */},
                  ),
                  _DashboardCard(
                    icon: Icons.task_alt,
                    title: 'Tareas',
                    subtitle: 'Pendientes',
                    onTap: () {/* TODO: context.push('/tasks') */},
                  ),
                  _DashboardCard(
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                    subtitle: 'Alertas',
                    onTap: () {/* TODO: context.push('/notifications') */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 12. Crear estructura inicial de módulos

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 12.1 | Módulo Usuarios (auth) | ❌ | Subcarpetas no creadas |
| 12.2 | Módulo Habitaciones (rooms) | ❌ | Subcarpetas no creadas |
| 12.3 | Módulo Reservaciones (reservations) | ❌ | Subcarpetas no creadas |
| 12.4 | Módulo Tareas (tasks) | ❌ | No mencionado en estructura, pero sí en entidades |
| 12.5 | Módulo Notificaciones (notifications) | ❌ | Subcarpetas no creadas |
| 12.6 | Módulo Wear (wear) | ❌ | Subcarpetas no creadas |

### Guía para completar 12.1–12.6

Crear la estructura completa por cada módulo en las tres capas:

```powershell
# Por cada módulo, crear subcarpetas en las capas correspondientes
$modules = @("auth", "rooms", "reservations", "notifications", "wear")

foreach ($m in $modules) {
    # Providers
    New-Item -ItemType Directory -Force -Path "lib\presentation\providers\$m"
    # Screens
    New-Item -ItemType Directory -Force -Path "lib\presentation\screens\$m"
    # Widgets
    New-Item -ItemType Directory -Force -Path "lib\presentation\widgets\$m"
    # Infrastructure models
    New-Item -ItemType Directory -Force -Path "lib\infrastructure\models\$m"
}

# Carpetas adicionales específicas
New-Item -ItemType Directory -Force -Path "lib\presentation\providers\dashboard"
New-Item -ItemType Directory -Force -Path "lib\presentation\screens\dashboard"
New-Item -ItemType Directory -Force -Path "lib\presentation\screens\profile"
New-Item -ItemType Directory -Force -Path "lib\presentation\widgets\shared"
New-Item -ItemType Directory -Force -Path "lib\presentation\widgets\dashboard"
```

---

## 13. Configurar Repositorios (Repository Pattern)

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 13.1 | Definir interfaces (abstract classes) en `domain/repositories/` | ❌ | Carpeta vacía |
| 13.2 | Definir datasource abstracts en `domain/datasource/` | ❌ | Carpeta vacía |
| 13.3 | Implementar repositories en `infrastructure/repositories/` | ❌ | Carpeta vacía |
| 13.4 | Implementar datasources en `infrastructure/datasource/` | ❌ | Carpeta vacía |

### Guía para completar 13.1–13.4

Según la documentación, se necesitan estos repositorios:

```dart
// lib/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<dynamic> login(String email, String password);
  Future<void> logout();
  Future<dynamic> checkAuthStatus();
}

// lib/domain/repositories/room_repository.dart
abstract class RoomRepository {
  Future<List<dynamic>> getRooms();
  Future<dynamic> getRoomById(String id);
  Future<void> updateRoomStatus(String id, String status);
}

// lib/domain/repositories/reservation_repository.dart
abstract class ReservationRepository {
  Future<List<dynamic>> getReservations();
  Future<dynamic> getReservationById(String id);
  Future<void> createReservation(dynamic reservation);
  Future<void> checkIn(String reservationId);
  Future<void> checkOut(String reservationId);
}

// lib/domain/repositories/notification_repository.dart
abstract class NotificationRepository {
  Future<List<dynamic>> getNotifications();
  Future<void> markAsRead(String id);
}

// lib/domain/repositories/wear_repository.dart
abstract class WearRepository {
  Future<void> sendTask(dynamic task);
  Future<void> acceptTask(String taskId);
  Future<void> startTask(String taskId);
  Future<void> finishTask(String taskId);
  Stream<dynamic> receiveUpdates();
}
```

---

## 14. Configurar Servicios

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 14.1 | ApiService (Dio) | ❌ | Carpeta `config/services/` vacía |
| 14.2 | StorageService | ❌ | — |
| 14.3 | NotificationService | ❌ | — |
| 14.4 | SocketService (WebSocket) | ❌ | — |
| 14.5 | WearCommunicationService | ❌ | — |

### Guía para completar 14.1

```dart
// lib/config/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }
}
```

---

## 15. Configurar `.env`

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 15.1 | Crear `.env` con variables de entorno | ⚠️ | El archivo `.env` existe pero no fue posible verificar su contenido (puede estar vacío) |
| 15.2 | Crear `.env.template` con las variables de ejemplo | ⚠️ | El archivo existe pero está vacío |
| 15.3 | Cargar `.env` en `main.dart` | ❌ | `main.dart` no carga `dotenv` |

### Guía para completar 15.2–15.3

**15.2 — Completar `.env.template`:**

```env
# API Configuration
API_BASE_URL=http://localhost:3000/api

# WebSocket
WS_URL=ws://localhost:3000/ws

# App Configuration
APP_NAME=Hotel App
APP_ENV=development
```

**15.3 — Cargar dotenv en `main.dart`:**

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## 16. Crear documentación del proyecto (README)

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 16.1 | Objetivo del proyecto | ❌ | README es el boilerplate de Flutter |
| 16.2 | Instalación | ❌ | — |
| 16.3 | Arquitectura | ❌ | — |
| 16.4 | Convenciones de desarrollo | ❌ | — |
| 16.5 | Flujo de ramas Git | ❌ | — |

### Guía para completar 16.1–16.5

Reemplazar el contenido de `README.md` con:

```markdown
# 🏨 Hotel App

Aplicación multidispositivo desarrollada en Flutter para la gestión operativa de un hotel.
Permite administrar habitaciones, reservas, tareas y notificaciones con sincronización en tiempo real.

## 📋 Requisitos

- Flutter 3.x
- Dart SDK ^3.11.5
- Un editor compatible (VS Code / Android Studio)

## 🚀 Instalación

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/MonseCastanon/Hotel-Project.git
   cd hotel_app
   ```

2. Copiar las variables de entorno:
   ```bash
   cp .env.template .env
   ```

3. Instalar dependencias:
   ```bash
   flutter pub get
   ```

4. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture** con las siguientes capas:

| Capa | Descripción |
|------|-------------|
| `config/` | Configuración global: tema, rutas, constantes, helpers, servicios |
| `domain/` | Entidades, repositorios abstractos y datasources |
| `infrastructure/` | Implementación de repositorios, datasources, modelos y mappers |
| `presentation/` | UI: screens, widgets, views y providers (Riverpod) |

## 🛠️ Tecnologías

- **State Management:** Riverpod
- **Navegación:** GoRouter
- **HTTP Client:** Dio
- **Persistencia:** Hive + SharedPreferences
- **UI:** Material Design 3
- **Responsive:** flutter_screenutil

## 🌿 Flujo de ramas Git

| Rama | Propósito |
|------|-----------|
| `main` | Producción estable |
| `develop` | Integración de features |
| `feature/*` | Nuevas funcionalidades |
| `hotfix/*` | Correcciones urgentes |

### Convención de commits

Se utiliza **Conventional Commits**:

- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Documentación
- `style:` Formato (sin cambios de lógica)
- `refactor:` Refactorización
- `test:` Tests
- `chore:` Tareas de mantenimiento

## 📏 Convenciones de desarrollo

- Clean Architecture (SOLID)
- Repository Pattern
- Null Safety
- No usar `setState()` para lógica de negocio
- Riverpod para gestión de estado
- Linter oficial de Flutter
```

---

## 17. Validar configuración completa del proyecto

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 17.1 | Verificar compilación (`flutter build`) | ❌ | `main.dart` tiene errores de sintaxis |
| 17.2 | Revisar navegación funcional | ❌ | GoRouter no implementado |
| 17.3 | Validar arquitectura de carpetas completa | ⚠️ | Carpetas principales existen pero sin subcarpetas por módulo |
| 17.4 | Proyecto listo para desarrollo colaborativo | ❌ | README genérico, estructura incompleta |

---

## Resumen General

| Sección | Completado | Parcial | Faltante |
|---------|:----------:|:-------:|:--------:|
| 1. Proyecto Flutter | 1 | 1 | 0 |
| 2. Git y GitHub | 5 | 0 | 0 |
| 3. Arquitectura (Carpetas) | 0 | 6 | 0 |
| 4. Dependencias | 14 | 0 | 1 |
| 5. Riverpod | 1 | 0 | 3 |
| 6. GoRouter | 1 | 0 | 3 |
| 7. Tema global | 0 | 2 | 3 |
| 8. Assets | 0 | 1 | 3 |
| 9. Autenticación | 0 | 0 | 5 |
| 10. Modelos del dominio | 0 | 0 | 6 |
| 11. Dashboard | 0 | 0 | 2 |
| 12. Módulos iniciales | 0 | 0 | 6 |
| 13. Repositorios | 0 | 0 | 4 |
| 14. Servicios | 0 | 0 | 5 |
| 15. Variables de entorno | 0 | 2 | 1 |
| 16. README | 0 | 0 | 5 |
| 17. Validación | 0 | 1 | 3 |
| **TOTAL** | **22** | **13** | **50** |

---

## Orden de ejecución recomendado

> Para maximizar eficiencia, se recomienda implementar en este orden:

1. 🔧 **Corregir `main.dart`** — Sección 4.15 (permite que compile)
2. 🎨 **Completar el tema** — Sección 7 (base visual)
3. 📁 **Crear subcarpetas por módulo** — Sección 3 y 12
4. 📦 **Crear entidades del dominio** — Sección 10
5. 🔐 **Implementar Riverpod** — Sección 5
6. 🧭 **Implementar GoRouter** — Sección 6
7. 🔑 **Crear pantalla de Login** — Sección 9
8. 📊 **Crear Dashboard** — Sección 11
9. 📝 **Repositorios y Datasources** — Sección 13
10. ⚙️ **Servicios (API, Storage)** — Sección 14
11. 🖼️ **Configurar assets** — Sección 8
12. 🌍 **Configurar `.env`** — Sección 15
13. 📖 **Actualizar README** — Sección 16
14. ✅ **Validación final** — Sección 17
