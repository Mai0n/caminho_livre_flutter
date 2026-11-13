import 'package:caminho_livre/data/ocorrencias_iniciais.dart';
import 'package:caminho_livre/model/filtro_ocorrencias.dart';
import 'package:caminho_livre/model/indicadores.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ocorrencias = ocorrenciasIniciais(DateTime(2026, 11, 12));

  test('ocorrência convertida para JSON e de volta mantém os dados', () {
    // ARRANGE
    final original = ocorrencias.first;

    // ACT
    final copia = Ocorrencia.fromJson(original.toJson());

    // ASSERT
    expect(copia.id, original.id);
    expect(copia.tipo, original.tipo);
    expect(copia.proximidade, original.proximidade);
    expect(copia.status, original.status);
    expect(copia.endereco.logradouro, original.endereco.logradouro);
    expect(copia.criadaEm, original.criadaEm);
    expect(copia.indicePrioridade, closeTo(original.indicePrioridade, 0.01));
  });

  test('a ocorrência de exemplo do pitch tem índice 14,5', () {
    final rampaHospital = ocorrencias.firstWhere((o) => o.id == '100001');

    expect(rampaHospital.indicePrioridade, closeTo(14.5, 0.01));
  });

  test('fila coloca pendentes primeiro, da maior para a menor prioridade', () {
    final fila = FiltroOcorrencias.ordenarPorPrioridade(ocorrencias);

    expect(fila.first.id, '100001');
    expect(fila.last.resolvida, isTrue);
  });

  test('filtro por status mostra apenas o status escolhido', () {
    const filtro = FiltroOcorrencias(status: StatusOcorrencia.resolvida);

    final resultado = filtro.aplicar(ocorrencias);

    expect(resultado, hasLength(2));
    expect(resultado.every((o) => o.resolvida), isTrue);
  });

  test('busca ignora acentos e maiúsculas', () {
    const filtro = FiltroOcorrencias(busca: 'acacias');

    final resultado = filtro.aplicar(ocorrencias);

    expect(resultado, hasLength(1));
    expect(resultado.first.endereco.logradouro, 'Rua das Acácias');
  });

  test('indicadores contam abertas, resolvidas e tempo médio', () {
    final indicadores = Indicadores.calcular(ocorrencias);

    expect(indicadores.abertas, 4);
    expect(indicadores.emAtendimento, 1);
    expect(indicadores.resolvidas, 2);
    expect(indicadores.tempoMedioDias, closeTo(11.0, 0.01));
  });

  test('status avança de aberta para em atendimento e depois resolvida', () {
    expect(StatusOcorrencia.aberta.proximo, StatusOcorrencia.emAtendimento);
    expect(StatusOcorrencia.emAtendimento.proximo, StatusOcorrencia.resolvida);
    expect(StatusOcorrencia.resolvida.proximo, isNull);
  });
}
