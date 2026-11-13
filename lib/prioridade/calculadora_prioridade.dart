import 'dart:math';

import 'package:caminho_livre/model/nivel_prioridade.dart';

/// Regra de negócio do índice de prioridade do Caminho Livre.
///
/// Prioridade = gravidade (1 a 5) × fator de entorno (1 a 3)
///              + bônus de confirmações (0,5 por confirmação, máximo 3).
class CalculadoraPrioridade {
  static const double bonusPorConfirmacao = 0.5;
  static const double bonusMaximo = 3.0;
  static const double limiteAlta = 12.0;
  static const double limiteMedia = 7.0;

  const CalculadoraPrioridade();

  double calcular({
    required int gravidade,
    required int fatorEntorno,
    required int confirmacoes,
  }) {
    if (gravidade < 1 || gravidade > 5) {
      throw ArgumentError('A gravidade deve estar entre 1 e 5');
    }

    if (fatorEntorno < 1 || fatorEntorno > 3) {
      throw ArgumentError('O fator de entorno deve estar entre 1 e 3');
    }

    if (confirmacoes < 0) {
      throw ArgumentError('As confirmações não podem ser negativas');
    }

    return (gravidade * fatorEntorno).toDouble() + bonus(confirmacoes);
  }

  /// Bônus das confirmações, limitado a [bonusMaximo].
  double bonus(int confirmacoes) {
    return min(confirmacoes * bonusPorConfirmacao, bonusMaximo);
  }

  NivelPrioridade classificar(double indice) {
    if (indice >= limiteAlta) {
      return NivelPrioridade.alta;
    }

    if (indice >= limiteMedia) {
      return NivelPrioridade.media;
    }

    return NivelPrioridade.baixa;
  }
}
