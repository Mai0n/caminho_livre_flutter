import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';

/// Regras de busca, filtro e ordenação da fila de ocorrências.
class FiltroOcorrencias {
  final String busca;

  /// Quando nulo, mostra todos os status.
  final StatusOcorrencia? status;

  const FiltroOcorrencias({this.busca = '', this.status});

  List<Ocorrencia> aplicar(List<Ocorrencia> ocorrencias) {
    final termo = _normalizar(busca);

    final filtradas = ocorrencias.where((ocorrencia) {
      final statusConfere = status == null || ocorrencia.status == status;
      if (!statusConfere) {
        return false;
      }

      if (termo.isEmpty) {
        return true;
      }

      final texto = _normalizar(
        '${ocorrencia.tipo.descricao} ${ocorrencia.local} '
        '${ocorrencia.descricao} ${ocorrencia.protocolo}',
      );
      return texto.contains(termo);
    }).toList();

    return ordenarPorPrioridade(filtradas);
  }

  /// Pendentes primeiro, da maior para a menor prioridade.
  /// As resolvidas ficam no fim da fila.
  static List<Ocorrencia> ordenarPorPrioridade(List<Ocorrencia> ocorrencias) {
    final ordenadas = List<Ocorrencia>.from(ocorrencias);
    ordenadas.sort((a, b) {
      if (a.resolvida != b.resolvida) {
        return a.resolvida ? 1 : -1;
      }
      return b.indicePrioridade.compareTo(a.indicePrioridade);
    });
    return ordenadas;
  }

  /// Deixa o texto em minúsculas e sem acentos, para a busca encontrar
  /// "calcada" mesmo quando o texto é "Calçada".
  static String _normalizar(String texto) {
    const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const semAcento = 'aaaaaeeeeiiiiooooouuuuc';

    var resultado = texto.toLowerCase().trim();
    for (var i = 0; i < comAcento.length; i++) {
      resultado = resultado.replaceAll(comAcento[i], semAcento[i]);
    }
    return resultado;
  }
}
