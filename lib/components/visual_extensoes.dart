import 'package:caminho_livre/core/app_cores.dart';
import 'package:caminho_livre/model/nivel_prioridade.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:caminho_livre/model/tipo_barreira.dart';
import 'package:flutter/material.dart';

/// Ícones e cores ficam na camada visual, fora dos modelos.

extension TipoBarreiraVisual on TipoBarreira {
  IconData get icone {
    switch (this) {
      case TipoBarreira.calcadaQuebrada:
        return Icons.warning_amber_rounded;
      case TipoBarreira.rampaAusente:
        return Icons.accessible;
      case TipoBarreira.obstaculo:
        return Icons.block;
      case TipoBarreira.posteNaCalcada:
        return Icons.light_outlined;
      case TipoBarreira.semaforoSemSom:
        return Icons.traffic_outlined;
      case TipoBarreira.outro:
        return Icons.report_outlined;
    }
  }
}

extension StatusOcorrenciaVisual on StatusOcorrencia {
  Color get cor {
    switch (this) {
      case StatusOcorrencia.aberta:
        return AppCores.statusAberta;
      case StatusOcorrencia.emAtendimento:
        return AppCores.statusEmAtendimento;
      case StatusOcorrencia.resolvida:
        return AppCores.statusResolvida;
    }
  }

  IconData get icone {
    switch (this) {
      case StatusOcorrencia.aberta:
        return Icons.error_outline;
      case StatusOcorrencia.emAtendimento:
        return Icons.construction;
      case StatusOcorrencia.resolvida:
        return Icons.check_circle_outline;
    }
  }
}

extension NivelPrioridadeVisual on NivelPrioridade {
  Color get cor {
    switch (this) {
      case NivelPrioridade.alta:
        return AppCores.laranja;
      case NivelPrioridade.media:
        return AppCores.azul;
      case NivelPrioridade.baixa:
        return AppCores.cinza;
    }
  }
}
