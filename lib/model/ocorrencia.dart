import 'package:caminho_livre/model/endereco.dart';
import 'package:caminho_livre/model/nivel_prioridade.dart';
import 'package:caminho_livre/model/proximidade.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:caminho_livre/model/tipo_barreira.dart';
import 'package:caminho_livre/prioridade/calculadora_prioridade.dart';

/// Barreira de acessibilidade registrada por um cidadão.
class Ocorrencia {
  static const CalculadoraPrioridade _calculadora = CalculadoraPrioridade();

  final String id;
  final TipoBarreira tipo;
  final int gravidade;
  final Proximidade proximidade;
  final Endereco endereco;
  final String referencia;
  final String descricao;
  final StatusOcorrencia status;
  final int confirmacoes;
  final bool acompanhando;
  final DateTime criadaEm;
  final DateTime? resolvidaEm;

  const Ocorrencia({
    required this.id,
    required this.tipo,
    required this.gravidade,
    required this.proximidade,
    required this.endereco,
    required this.referencia,
    required this.descricao,
    required this.status,
    required this.confirmacoes,
    required this.acompanhando,
    required this.criadaEm,
    this.resolvidaEm,
  });

  /// Número de protocolo exibido ao cidadão.
  String get protocolo {
    final sufixo = id.length > 6 ? id.substring(id.length - 6) : id;
    return 'CL-$sufixo';
  }

  double get indicePrioridade => _calculadora.calcular(
        gravidade: gravidade,
        fatorEntorno: proximidade.fatorEntorno,
        confirmacoes: confirmacoes,
      );

  double get bonusConfirmacoes => _calculadora.bonus(confirmacoes);

  NivelPrioridade get nivelPrioridade =>
      _calculadora.classificar(indicePrioridade);

  bool get resolvida => status == StatusOcorrencia.resolvida;

  /// Endereço resumido com o número ou ponto de referência.
  String get local {
    if (referencia.trim().isEmpty) {
      return endereco.resumo;
    }
    return '${endereco.resumo} · $referencia';
  }

  Ocorrencia copyWith({
    StatusOcorrencia? status,
    int? confirmacoes,
    bool? acompanhando,
    DateTime? resolvidaEm,
  }) {
    return Ocorrencia(
      id: id,
      tipo: tipo,
      gravidade: gravidade,
      proximidade: proximidade,
      endereco: endereco,
      referencia: referencia,
      descricao: descricao,
      status: status ?? this.status,
      confirmacoes: confirmacoes ?? this.confirmacoes,
      acompanhando: acompanhando ?? this.acompanhando,
      criadaEm: criadaEm,
      resolvidaEm: resolvidaEm ?? this.resolvidaEm,
    );
  }

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    final resolvidaEm = json['resolvidaEm'];

    return Ocorrencia(
      id: json['id'] as String,
      tipo: TipoBarreira.values.byName(json['tipo'] as String),
      gravidade: json['gravidade'] as int,
      proximidade: Proximidade.values.byName(json['proximidade'] as String),
      endereco: Endereco.fromJson(json['endereco'] as Map<String, dynamic>),
      referencia: (json['referencia'] ?? '') as String,
      descricao: (json['descricao'] ?? '') as String,
      status: StatusOcorrencia.values.byName(json['status'] as String),
      confirmacoes: json['confirmacoes'] as int,
      acompanhando: (json['acompanhando'] ?? false) as bool,
      criadaEm: DateTime.parse(json['criadaEm'] as String),
      resolvidaEm: resolvidaEm == null ? null : DateTime.parse(resolvidaEm as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'gravidade': gravidade,
      'proximidade': proximidade.name,
      'endereco': endereco.toJson(),
      'referencia': referencia,
      'descricao': descricao,
      'status': status.name,
      'confirmacoes': confirmacoes,
      'acompanhando': acompanhando,
      'criadaEm': criadaEm.toIso8601String(),
      'resolvidaEm': resolvidaEm?.toIso8601String(),
    };
  }
}
