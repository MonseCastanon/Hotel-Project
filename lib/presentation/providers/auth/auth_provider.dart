import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  const AuthState({
    required this.isAuthenticated,
    this.email,
    this.isLoading = false,
  });

  final bool isAuthenticated;
  final String? email;
  final bool isLoading;

  AuthState copyWith({
    bool? isAuthenticated,
    String? email,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _initialize();
    return const AuthState(isAuthenticated: false, isLoading: true);
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final email = prefs.getString('auth_email');

    state = AuthState(
      isAuthenticated: token != null && token.isNotEmpty,
      email: email,
      isLoading: false,
    );
  }

  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Ingresa el correo y la contraseña');
    }

    if (!email.contains('@')) {
      throw Exception('Ingresa un correo válido');
    }

    // Validación estricta local
    if (email.trim().toLowerCase() != 'admin@hotel.com' || password != 'admin123') {
      throw Exception('Credenciales incorrectas');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', 'demo-token-${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setString('auth_email', email.trim().toLowerCase());

    state = AuthState(
      isAuthenticated: true,
      email: email.trim().toLowerCase(),
      isLoading: false,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_email');

    state = const AuthState(isAuthenticated: false, isLoading: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
