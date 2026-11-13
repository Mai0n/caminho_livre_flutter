import 'package:flutter/material.dart';

/// Linha "título / valor" usada nos cards de endereço e de detalhes.
class InfoLinha extends StatelessWidget {
  final String titulo;
  final String valor;

  const InfoLinha({super.key, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    final valorExibido = valor.trim().isEmpty ? 'Não informado' : valor;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(valorExibido, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
