/// Validações usadas nos formulários.
class Validadores {
  Validadores._();

  static String? cep(String? valor) {
    final digitos = (valor ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.isEmpty) {
      return 'Informe o CEP do local';
    }
    if (digitos.length != 8) {
      return 'O CEP deve possuir 8 dígitos';
    }
    return null;
  }

  static String? referencia(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o número ou um ponto de referência';
    }
    return null;
  }
}
