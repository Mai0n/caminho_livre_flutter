import 'package:flutter/widgets.dart';

/// Conteúdo de uma página da introdução (onboarding).
class PaginaIntroducao {
  final String titulo;
  final String descricao;
  final IconData icone;

  /// Caminho de uma imagem em assets. Quando informado, é exibido no lugar do ícone.
  final String? imagem;

  const PaginaIntroducao({
    required this.titulo,
    required this.descricao,
    required this.icone,
    this.imagem,
  });
}
