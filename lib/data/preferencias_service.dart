import 'package:shared_preferences/shared_preferences.dart';

/// Preferências do usuário salvas no aparelho com SharedPreferences.
class PreferenciasService {
  static const String _chaveIntroducaoVista = 'introducao_vista';

  /// true quando o usuário marcou "Não mostrar novamente" na introdução.
  Future<bool> introducaoVista() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chaveIntroducaoVista) ?? false;
  }

  Future<void> salvarIntroducaoVista(bool vista) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveIntroducaoVista, vista);
  }
}
