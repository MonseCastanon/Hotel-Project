import 'package:flutter/material.dart';
import 'package:hotel_app/config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(isDarkMode: false).getTheme(),
      darkTheme: AppTheme(isDarkMode: true).getTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ThemePreviewScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: () => setState(() => _isDarkMode = !_isDarkMode),
      ),
    );
  }
}

// ─────────────────────── Pantalla de Preview del Theme ───────────────────────

class ThemePreviewScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ThemePreviewScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel App — Theme Preview'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Paleta de colores ──
            _SectionTitle('Paleta de Colores'),
            const SizedBox(height: 12),
            _ColorPaletteRow(),
            const SizedBox(height: 24),

            // ── ColorScheme Roles ──
            _SectionTitle('ColorScheme Roles'),
            const SizedBox(height: 12),
            _ColorRoleGrid(cs),
            const SizedBox(height: 24),

            // ── Tipografía ──
            _SectionTitle('Tipografía'),
            const SizedBox(height: 12),
            Text('Display Large', style: tt.displayLarge),
            Text('Display Medium', style: tt.displayMedium),
            Text('Headline Large', style: tt.headlineLarge),
            Text('Headline Medium', style: tt.headlineMedium),
            Text('Title Large', style: tt.titleLarge),
            Text('Title Medium', style: tt.titleMedium),
            Text('Body Large', style: tt.bodyLarge),
            Text('Body Medium', style: tt.bodyMedium),
            Text('Label Large', style: tt.labelLarge),
            const SizedBox(height: 24),

            // ── Botones ──
            _SectionTitle('Botones'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('ElevatedButton'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('FilledButton'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('OutlinedButton'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('TextButton'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Cards ──
            _SectionTitle('Cards'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: const Icon(Icons.hotel, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Suite Deluxe 401',
                                style: tt.titleMedium),
                            Text('Disponible · \$2,400/noche',
                                style: tt.bodySmall?.copyWith(
                                    color: cs.primary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Habitación amplia con vista al mar, cama king size y jacuzzi privado.',
                      style: tt.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Ver detalle'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Reservar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Inputs ──
            _SectionTitle('Inputs'),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nombre del huésped',
                prefixIcon: Icon(Icons.person_outline),
                hintText: 'Ej. Juan Pérez',
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 24),

            // ── Chips / Badges ──
            _SectionTitle('Status Chips'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusChip('Disponible', Colors.green),
                _StatusChip('Ocupada', Colors.red),
                _StatusChip('Reservada', AppColors.primary),
                _StatusChip('Mantenimiento', Colors.orange),
                _StatusChip('Confirmada', AppColors.secondary),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onToggleTheme,
        icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        label: Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
      ),
    );
  }
}

// ─────────────────────────── Widgets auxiliares ──────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        )),
        const Divider(),
      ],
    );
  }
}

class _ColorPaletteRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = [
      (AppColors.primary, '#FF661A', 'Primary'),
      (AppColors.secondary, '#EFB49F', 'Secondary'),
      (AppColors.backgroundLight, '#F0F0F0', 'Bg Light'),
      (AppColors.backgroundDark, '#303030', 'Bg Dark'),
      (AppColors.surface, '#F2F2F2', 'Surface'),
    ];

    return Row(
      children: colors.map((c) {
        final isLight = c.$1.computeLuminance() > 0.5;
        return Expanded(
          child: Container(
            height: 80,
            color: c.$1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.$3,
                    style: TextStyle(
                      color: isLight ? Colors.black87 : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )),
                Text(c.$2,
                    style: TextStyle(
                      color: isLight ? Colors.black54 : Colors.white70,
                      fontSize: 9,
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorRoleGrid extends StatelessWidget {
  final ColorScheme cs;
  const _ColorRoleGrid(this.cs);

  @override
  Widget build(BuildContext context) {
    final roles = [
      (cs.primary, cs.onPrimary, 'primary'),
      (cs.secondary, cs.onSecondary, 'secondary'),
      (cs.surface, cs.onSurface, 'surface'),
      (cs.primaryContainer, cs.onPrimaryContainer, 'primaryContainer'),
      (cs.error, cs.onError, 'error'),
      (cs.surfaceContainerHighest, cs.onSurfaceVariant, 'surfaceContainerHighest'),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: roles.map((r) {
        return Container(
          decoration: BoxDecoration(
            color: r.$1,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4),
          child: Text(r.$3,
              textAlign: TextAlign.center,
              style: TextStyle(color: r.$2, fontSize: 9)),
        );
      }).toList(),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
