import 'package:flutter/material.dart';

/// Título de seção usado nas telas.
class SecaoTitulo extends StatelessWidget {
  final String titulo;
  final String? subtitulo;

  const SecaoTitulo({super.key, required this.titulo, this.subtitulo});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitulo != null) ...[
            const SizedBox(height: 2),
            Text(subtitulo!, style: tema.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
