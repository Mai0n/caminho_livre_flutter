import 'dart:convert';

import 'package:caminho_livre/data/ocorrencias_iniciais.dart';
import 'package:caminho_livre/model/endereco.dart';
import 'package:caminho_livre/model/filtro_ocorrencias.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/proximidade.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:caminho_livre/model/tipo_barreira.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Acesso aos dados das ocorrências, salvas no aparelho em JSON
/// com SharedPreferences (persistência local).
class OcorrenciaRepository {
  static const String _chave = 'ocorrencias';

  /// Lista todas as ocorrências já ordenadas por prioridade.
  /// No primeiro uso, grava as ocorrências de demonstração.
  Future<List<Ocorrencia>> listar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_chave);

    if (texto == null) {
      final iniciais = ocorrenciasIniciais();
      await _salvarTodas(iniciais);
      return FiltroOcorrencias.ordenarPorPrioridade(iniciais);
    }

    final lista = (jsonDecode(texto) as List<dynamic>)
        .map((item) => Ocorrencia.fromJson(item as Map<String, dynamic>))
        .toList();

    return FiltroOcorrencias.ordenarPorPrioridade(lista);
  }

  Future<List<Ocorrencia>> listarAcompanhadas() async {
    final todas = await listar();
    return todas.where((ocorrencia) => ocorrencia.acompanhando).toList();
  }

  Future<Ocorrencia> registrar({
    required TipoBarreira tipo,
    required int gravidade,
    required Proximidade proximidade,
    required Endereco endereco,
    required String referencia,
    required String descricao,
  }) async {
    final nova = Ocorrencia(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: tipo,
      gravidade: gravidade,
      proximidade: proximidade,
      endereco: endereco,
      referencia: referencia.trim(),
      descricao: descricao.trim(),
      status: StatusOcorrencia.aberta,
      confirmacoes: 0,
      acompanhando: true,
      criadaEm: DateTime.now(),
    );

    final todas = await listar();
    await _salvarTodas([...todas, nova]);
    return nova;
  }

  /// Outro morador confirma que a barreira existe (+0,5 no índice, até 3).
  Future<Ocorrencia> confirmar(Ocorrencia ocorrencia) {
    return _atualizar(
      ocorrencia.copyWith(confirmacoes: ocorrencia.confirmacoes + 1),
    );
  }

  /// Leva a ocorrência para a próxima etapa: aberta -> em atendimento -> resolvida.
  Future<Ocorrencia> avancarStatus(Ocorrencia ocorrencia) {
    final proximo = ocorrencia.status.proximo;
    if (proximo == null) {
      return Future.value(ocorrencia);
    }

    return _atualizar(
      ocorrencia.copyWith(
        status: proximo,
        resolvidaEm:
            proximo == StatusOcorrencia.resolvida ? DateTime.now() : null,
      ),
    );
  }

  Future<Ocorrencia> alternarAcompanhamento(Ocorrencia ocorrencia) {
    return _atualizar(
      ocorrencia.copyWith(acompanhando: !ocorrencia.acompanhando),
    );
  }

  /// Volta para as ocorrências de demonstração (útil antes de gravar o vídeo).
  Future<void> restaurarDadosIniciais() async {
    await _salvarTodas(ocorrenciasIniciais());
  }

  Future<Ocorrencia> _atualizar(Ocorrencia atualizada) async {
    final todas = await listar();
    final novaLista = todas
        .map((item) => item.id == atualizada.id ? atualizada : item)
        .toList();
    await _salvarTodas(novaLista);
    return atualizada;
  }

  Future<void> _salvarTodas(List<Ocorrencia> ocorrencias) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(
      ocorrencias.map((ocorrencia) => ocorrencia.toJson()).toList(),
    );
    await prefs.setString(_chave, texto);
  }
}
