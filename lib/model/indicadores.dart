import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';

/// Números exibidos no painel inicial.
class Indicadores {
  final int abertas;
  final int emAtendimento;
  final int resolvidas;

  /// Tempo médio, em dias, entre o registro e a resolução.
  /// Fica nulo enquanto nenhuma ocorrência foi resolvida.
  final double? tempoMedioDias;

  const Indicadores({
    required this.abertas,
    required this.emAtendimento,
    required this.resolvidas,
    required this.tempoMedioDias,
  });

  int get pendentes => abertas + emAtendimento;

  factory Indicadores.calcular(List<Ocorrencia> ocorrencias) {
    final resolvidas = ocorrencias.where((o) => o.resolvida).toList();
    final comData = resolvidas.where((o) => o.resolvidaEm != null).toList();

    double? tempoMedio;
    if (comData.isNotEmpty) {
      final totalDias = comData
          .map((o) => o.resolvidaEm!.difference(o.criadaEm).inDays)
          .reduce((a, b) => a + b);
      tempoMedio = totalDias / comData.length;
    }

    return Indicadores(
      abertas: ocorrencias
          .where((o) => o.status == StatusOcorrencia.aberta)
          .length,
      emAtendimento: ocorrencias
          .where((o) => o.status == StatusOcorrencia.emAtendimento)
          .length,
      resolvidas: resolvidas.length,
      tempoMedioDias: tempoMedio,
    );
  }
}
