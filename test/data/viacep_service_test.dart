import 'dart:convert';

import 'package:caminho_livre/data/viacep_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const cabecalhos = {'content-type': 'application/json; charset=utf-8'};

  test('CEP válido deve retornar o endereço convertido do JSON', () async {
    // ARRANGE
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://viacep.com.br/ws/01001000/json/');
      return http.Response(
        jsonEncode({
          'cep': '01001-000',
          'logradouro': 'Praça da Sé',
          'bairro': 'Sé',
          'localidade': 'São Paulo',
          'uf': 'SP',
        }),
        200,
        headers: cabecalhos,
      );
    });
    final service = ViaCepService(client: client);

    // ACT
    final endereco = await service.buscarEndereco('01001-000');

    // ASSERT
    expect(endereco.logradouro, 'Praça da Sé');
    expect(endereco.localidade, 'São Paulo');
    expect(endereco.uf, 'SP');
    expect(endereco.complemento, '');
  });

  test('CEP inexistente deve gerar erro de CEP não encontrado', () async {
    final client = MockClient((request) async {
      return http.Response('{"erro": "true"}', 200, headers: cabecalhos);
    });
    final service = ViaCepService(client: client);

    await expectLater(
      service.buscarEndereco('99999999'),
      throwsA(
        isA<Exception>().having(
          (erro) => erro.toString(),
          'mensagem',
          contains('CEP não encontrado'),
        ),
      ),
    );
  });

  test('resposta HTTP diferente de 200 deve gerar erro', () async {
    final client = MockClient((request) async {
      return http.Response('Erro interno', 500);
    });
    final service = ViaCepService(client: client);

    await expectLater(
      service.buscarEndereco('01001000'),
      throwsA(
        isA<Exception>().having(
          (erro) => erro.toString(),
          'mensagem',
          contains('500'),
        ),
      ),
    );
  });

  test('CEP com menos de 8 dígitos gera erro sem chamar a API', () async {
    var chamouApi = false;
    final client = MockClient((request) async {
      chamouApi = true;
      return http.Response('{}', 200);
    });
    final service = ViaCepService(client: client);

    await expectLater(service.buscarEndereco('0100'), throwsException);
    expect(chamouApi, isFalse);
  });
}
