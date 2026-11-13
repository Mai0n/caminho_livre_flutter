import 'package:caminho_livre/components/visual_extensoes.dart';
import 'package:caminho_livre/core/formatadores.dart';
import 'package:caminho_livre/prioridade/calculadora_prioridade.dart';
import 'package:flutter/material.dart';

/// Quadro com o índice de prioridade. Laranja = alta, azul = média, cinza = baixa.
class PrioridadeBadge extends StatelessWidget {
  final double indice;
  final bool exibirNivel;

  const PrioridadeBadge({
    super.key,
    required this.indice,
    this.exibirNivel = false,
  });

  @override
  Widget build(BuildContext context) {
    final nivel = const CalculadoraPrioridade().classificar(indice);

    return Semantics(
      label: 'Prioridade ${nivel.descricao}, índice ${Formatadores.indice(indice)}',
      child: ExcludeSemantics(
        child: Container(
          constraints: const BoxConstraints(minWidth: 56),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: nivel.cor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Formatadores.indice(indice),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (exibirNivel)
                Text(
                  nivel.descricao,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
