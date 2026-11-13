/// Representa os dados de endereço recebidos do WebService ViaCEP.
class Endereco {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String estado;
  final String regiao;
  final String ddd;

  const Endereco({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.estado,
    required this.regiao,
    required this.ddd,
  });

  /// Transforma o mapa recebido da API em um objeto Dart.
  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: (json['cep'] ?? '').toString(),
      logradouro: (json['logradouro'] ?? '').toString(),
      complemento: (json['complemento'] ?? '').toString(),
      bairro: (json['bairro'] ?? '').toString(),
      localidade: (json['localidade'] ?? '').toString(),
      uf: (json['uf'] ?? '').toString(),
      estado: (json['estado'] ?? '').toString(),
      regiao: (json['regiao'] ?? '').toString(),
      ddd: (json['ddd'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'estado': estado,
      'regiao': regiao,
      'ddd': ddd,
    };
  }

  /// Endereço em uma linha, ignorando as partes vazias.
  String get resumo {
    final partes = <String>[
      logradouro,
      bairro,
      [localidade, uf].where((parte) => parte.trim().isNotEmpty).join('/'),
    ].where((parte) => parte.trim().isNotEmpty).toList();

    return partes.isEmpty ? 'Endereço não informado' : partes.join(', ');
  }
}
