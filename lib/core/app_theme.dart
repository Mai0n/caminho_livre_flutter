import 'package:caminho_livre/core/app_cores.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get tema {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppCores.azul),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
