import 'package:caminho_livre/model/pagina_introducao.dart';
import 'package:flutter/material.dart';

/// Conteúdo de uma página da introdução: imagem ou ícone, título e descrição.
class PaginaIntroducaoView extends StatelessWidget {
  final PaginaIntroducao pagina;

  const PaginaIntroducaoView({super.key, required this.pagina});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          if (pagina.imagem != null)
            Image.asset(pagina.imagem!, width: 160, height: 160)
          else
            CircleAvatar(
              radius: 80,
              backgroundColor: tema.colorScheme.primaryContainer,
              child: Icon(
                pagina.icone,
                size: 80,
                color: tema.colorScheme.onPrimaryContainer,
              ),
            ),
          const SizedBox(height: 40),
          Text(
            pagina.titulo,
            textAlign: TextAlign.center,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pagina.descricao,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
