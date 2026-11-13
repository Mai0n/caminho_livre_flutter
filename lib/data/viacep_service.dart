import 'dart:async';
import 'dart:convert';

import 'package:caminho_livre/model/endereco.dart';
import 'package:http/http.dart' as http;

/// Comunicação com o WebService ViaCEP.
class ViaCepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';
  static const Duration _tempoLimite = Duration(seconds: 10);

  final http.Client _client;

  /// O [client] pode ser trocado nos testes por um MockClient.
  ViaCepService({http.Client? client}) : _client = client ?? http.Client();

  Future<Endereco> buscarEndereco(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) {
      throw Exception('O CEP deve possuir 8 dígitos.');
    }

    final uri = Uri.parse('$_baseUrl/$cepLimpo/json/');
    final response = await _get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Não foi possível consultar o CEP. '
        'Código HTTP: ${response.statusCode}',
      );
    }

    final json = _decodificar(response.body);

    // O ViaCEP responde {"erro": true} ou {"erro": "true"} quando o CEP não existe.
    if (json['erro'] == true || json['erro'] == 'true') {
      throw Exception('CEP não encontrado.');
    }

    return Endereco.fromJson(json);
  }

  Map<String, dynamic> _decodificar(String corpo) {
    try {
      final dados = jsonDecode(corpo);
      if (dados is Map<String, dynamic>) {
        return dados;
      }
    } on FormatException {
      // Tratado logo abaixo com a mesma mensagem.
    }
    throw Exception('O serviço de CEP retornou uma resposta inválida.');
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      return await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(_tempoLimite);
    } on TimeoutException {
      throw Exception(
        'A consulta demorou demais. Verifique sua conexão e tente novamente.',
      );
    } on http.ClientException {
      throw Exception(
        'Sem conexão com o serviço de CEP. Verifique sua internet.',
      );
    }
  }
}
