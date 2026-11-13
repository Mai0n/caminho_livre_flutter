import 'package:flutter/material.dart';

/// Bolinhas que mostram em qual página da introdução o usuário está.
class IndicadorPaginas extends StatelessWidget {
  final int quantidade;
  final int paginaAtual;

  const IndicadorPaginas({
    super.key,
    required this.quantidade,
    required this.paginaAtual,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Página ${paginaAtual + 1} de $quantidade',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < quantidade; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == paginaAtual ? 24 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: i == paginaAtual
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
        ],
      ),
    );
  }
}
