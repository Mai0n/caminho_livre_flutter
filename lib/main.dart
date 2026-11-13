import 'package:caminho_livre/core/app_routes.dart';
import 'package:caminho_livre/core/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CaminhoLivreApp());
}

class CaminhoLivreApp extends StatelessWidget {
  const CaminhoLivreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caminho Livre',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.gerarRota,
    );
  }
}
