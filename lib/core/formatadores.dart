/// Funções de formatação de textos exibidos na interface.
class Formatadores {
  Formatadores._();

  /// 14.5 -> "14,5"
  static String indice(double valor) {
    return valor.toStringAsFixed(1).replaceAll('.', ',');
  }

  /// DateTime -> "05/11/2026"
  static String data(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year}';
  }

  /// 11.0 -> "11 dias"; 1.0 -> "1 dia"; null -> "—"
  static String dias(double? valor) {
    if (valor == null) {
      return '—';
    }
    final arredondado = valor.round();
    return arredondado == 1 ? '1 dia' : '$arredondado dias';
  }

  /// "01001000" -> "01001-000"
  static String cep(String cep) {
    final digitos = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitos.length != 8) {
      return cep;
    }
    return '${digitos.substring(0, 5)}-${digitos.substring(5)}';
  }
}
