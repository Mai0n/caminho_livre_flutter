import 'package:caminho_livre/core/app_assets.dart';
import 'package:flutter/material.dart';

/// Logo do aplicativo, carregado da pasta assets.
class LogoApp extends StatelessWidget {
  final double tamanho;

  const LogoApp({super.key, this.tamanho = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: tamanho,
      height: tamanho,
      semanticLabel: 'Logo do Caminho Livre',
    );
  }
}
