import 'package:caminho_livre/components/logo_app.dart';
import 'package:caminho_livre/core/app_routes.dart';
import 'package:caminho_livre/data/preferencias_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _duracao = Duration(seconds: 2);

  final PreferenciasService _preferenciasService = PreferenciasService();

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  /// Espera a animação da splash e decide a próxima tela:
  /// se o usuário já marcou "Não mostrar novamente", vai direto para a Home.
  Future<void> _iniciar() async {
    await Future.delayed(_duracao);
    final introducaoVista = await _preferenciasService.introducaoVista();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      introducaoVista ? AppRoutes.home : AppRoutes.introducao,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LogoApp(tamanho: 160),
            const SizedBox(height: 24),
            Text(
              'Caminho Livre',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Calçadas acessíveis começam com quem anda nelas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
