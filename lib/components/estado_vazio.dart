import 'package:flutter/material.dart';

/// Mensagem exibida quando uma lista não tem itens.
class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String mensagem;
  final String? textoAcao;
  final VoidCallback? onAcao;

  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.mensagem,
    this.textoAcao,
    this.onAcao,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 64, color: tema.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium,
          ),
          if (textoAcao != null && onAcao != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onAcao, child: Text(textoAcao!)),
          ],
        ],
      ),
    );
  }
}
