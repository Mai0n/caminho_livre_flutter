import 'package:caminho_livre/data/ocorrencia_repository.dart';
import 'package:caminho_livre/model/endereco.dart';
import 'package:caminho_livre/model/proximidade.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:caminho_livre/model/tipo_barreira.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OcorrenciaRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = OcorrenciaRepository();
  });

  test('primeiro uso carrega as ocorrências de demonstração', () async {
    final ocorrencias = await repository.listar();

    expect(ocorrencias, hasLength(7));
    expect(ocorrencias.first.id, '100001');
  });

  test('confirmar aumenta as confirmações e fica salvo', () async {
    final ocorrencias = await repository.listar();
    final alvo = ocorrencias.firstWhere((o) => o.id == '100004');

    await repository.confirmar(alvo);
    final recarregadas = await repository.listar();
    final atualizada = recarregadas.firstWhere((o) => o.id == '100004');

    expect(atualizada.confirmacoes, alvo.confirmacoes + 1);
    expect(atualizada.indicePrioridade, closeTo(6.5, 0.01));
  });

  test('avançar status até resolvida grava a data de resolução', () async {
    final ocorrencias = await repository.listar();
    final alvo = ocorrencias.firstWhere((o) => o.id == '100002');

    final resolvida = await repository.avancarStatus(alvo);

    expect(alvo.status, StatusOcorrencia.emAtendimento);
    expect(resolvida.status, StatusOcorrencia.resolvida);
    expect(resolvida.resolvidaEm, isNotNull);
  });

  test('registrar adiciona uma nova ocorrência aberta e acompanhada', () async {
    const endereco = Endereco(
      cep: '01001-000',
      logradouro: 'Praça da Sé',
      complemento: '',
      bairro: 'Sé',
      localidade: 'São Paulo',
      uf: 'SP',
      estado: 'São Paulo',
      regiao: 'Sudeste',
      ddd: '11',
    );

    final nova = await repository.registrar(
      tipo: TipoBarreira.obstaculo,
      gravidade: 2,
      proximidade: Proximidade.ate400m,
      endereco: endereco,
      referencia: ' Em frente à catedral ',
      descricao: '',
    );
    final todas = await repository.listar();
    final acompanhadas = await repository.listarAcompanhadas();

    expect(todas, hasLength(8));
    expect(nova.status, StatusOcorrencia.aberta);
    expect(nova.referencia, 'Em frente à catedral');
    expect(acompanhadas.any((o) => o.id == nova.id), isTrue);
  });
}
