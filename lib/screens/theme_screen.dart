import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final lightThemes = AppThemes.all.where((t) => !t.isDark).toList();
    final darkThemes = AppThemes.all.where((t) => t.isDark).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Apariencia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel(label: '☀️  Modos claros'),
          const SizedBox(height: 12),
          ...lightThemes.map((theme) => _ThemeCard(
                theme: theme,
                isSelected: themeProvider.current.id == theme.id,
                onTap: () => themeProvider.setTheme(theme.id),
              )),
          const SizedBox(height: 24),
          _SectionLabel(label: '🌙  Modos oscuros'),
          const SizedBox(height: 12),
          ...darkThemes.map((theme) => _ThemeCard(
                theme: theme,
                isSelected: themeProvider.current.id == theme.id,
                onTap: () => themeProvider.setTheme(theme.id),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── ETIQUETA DE SECCIÓN ─────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

// ─── CARD DE TEMA ─────────────────────────────────────────────────────────────
class _ThemeCard extends StatelessWidget {
  final AppThemeOption theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = theme.data.scaffoldBackgroundColor;
    final card = theme.data.cardColor;
    final primary = theme.data.colorScheme.primary;
    final onSurface = theme.data.colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // ── Preview mini del tema ──
            Container(
              width: 90,
              height: 80,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Simula AppBar
                  Container(
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Simula card
                  Container(
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: onSurface.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 6,
                        width: 40,
                        decoration: BoxDecoration(
                          color: onSurface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Simula FAB
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info del tema ──
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    theme.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Paleta de colores del tema
                  Row(
                    children: [
                      _ColorDot(color: bg),
                      const SizedBox(width: 4),
                      _ColorDot(color: card),
                      const SizedBox(width: 4),
                      _ColorDot(color: primary),
                      const SizedBox(width: 4),
                      _ColorDot(color: onSurface),
                    ],
                  ),
                ],
              ),
            ),

            // ── Check si está seleccionado ──
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        key: const ValueKey('selected'),
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                        key: const ValueKey('unselected'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PUNTO DE COLOR ───────────────────────────────────────────────────────────
class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withOpacity(0.15),
          width: 0.5,
        ),
      ),
    );
  }
}
