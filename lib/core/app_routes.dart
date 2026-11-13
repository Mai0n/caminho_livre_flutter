import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:caminho_livre/screens/acompanhando_screen.dart';
import 'package:caminho_livre/screens/detalhe_ocorrencia_screen.dart';
import 'package:caminho_livre/screens/home_screen.dart';
import 'package:caminho_livre/screens/ocorrencias_screen.dart';
import 'package:caminho_livre/screens/onboarding_screen.dart';
import 'package:caminho_livre/screens/registrar_ocorrencia_screen.dart';
import 'package:caminho_livre/screens/sobre_screen.dart';
import 'package:caminho_livre/screens/splash_screen.dart';
import 'package:flutter/material.dart';

/// Rotas nomeadas do aplicativo e criação das telas com seus parâmetros.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String introducao = '/introducao';
  static const String home = '/home';
  static const String ocorrencias = '/ocorrencias';
  static const String detalhe = '/detalhe';
  static const String registrar = '/registrar';
  static const String acompanhando = '/acompanhando';
  static const String sobre = '/sobre';

  static Route<dynamic> gerarRota(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _rota(const SplashScreen(), settings);

      case introducao:
        // Parâmetro: true quando aberta pela tela Sobre ("Rever introdução").
        final aberturaManual = settings.arguments as bool? ?? false;
        return _rota(OnboardingScreen(aberturaManual: aberturaManual), settings);

      case home:
        return _rota(const HomeScreen(), settings);

      case ocorrencias:
        // Parâmetro: filtro de status inicial (vem dos indicadores da Home).
        final statusInicial = settings.arguments as StatusOcorrencia?;
        return _rota(OcorrenciasScreen(statusInicial: statusInicial), settings);

      case detalhe:
        // Parâmetro: a ocorrência selecionada na lista.
        final ocorrencia = settings.arguments as Ocorrencia;
        return _rota(DetalheOcorrenciaScreen(ocorrencia: ocorrencia), settings);

      case registrar:
        return _rota(const RegistrarOcorrenciaScreen(), settings);

      case acompanhando:
        return _rota(const AcompanhandoScreen(), settings);

      case sobre:
        return _rota(const SobreScreen(), settings);

      default:
        return _rota(const HomeScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _rota(Widget tela, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(builder: (_) => tela, settings: settings);
  }
}
