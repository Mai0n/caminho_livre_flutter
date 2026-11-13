import 'package:caminho_livre/components/indicador_paginas.dart';
import 'package:caminho_livre/components/pagina_introducao_view.dart';
import 'package:caminho_livre/core/app_routes.dart';
import 'package:caminho_livre/data/paginas_introducao.dart';
import 'package:caminho_livre/data/preferencias_service.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  /// true quando o usuário abriu a introdução de novo pela tela Sobre.
  /// Nesse caso, ao terminar, a tela apenas volta para a anterior.
  final bool aberturaManual;

  const OnboardingScreen({super.key, this.aberturaManual = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final PreferenciasService _preferenciasService = PreferenciasService();

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = false;

  bool get _ultimaPagina => _paginaAtual == paginasIntroducao.length - 1;

  @override
  void initState() {
    super.initState();
    _carregarPreferencia();
  }

  /// Mostra a caixa "Não mostrar novamente" com a opção já salva.
  Future<void> _carregarPreferencia() async {
    final vista = await _preferenciasService.introducaoVista();
    if (!mounted) {
      return;
    }
    setState(() {
      _naoMostrarNovamente = vista;
    });
  }

  void _avancar() {
    if (_ultimaPagina) {
      _concluir();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _voltar() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Salva a opção "Não mostrar novamente" e segue para a Home.
  Future<void> _concluir() async {
    await _preferenciasService.salvarIntroducaoVista(_naoMostrarNovamente);

    if (!mounted) {
      return;
    }

    if (widget.aberturaManual) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _concluir,
                child: const Text('Pular'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: paginasIntroducao.length,
                onPageChanged: (pagina) {
                  setState(() {
                    _paginaAtual = pagina;
                  });
                },
                itemBuilder: (context, index) {
                  return PaginaIntroducaoView(pagina: paginasIntroducao[index]);
                },
              ),
            ),
            IndicadorPaginas(
              quantidade: paginasIntroducao.length,
              paginaAtual: _paginaAtual,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _naoMostrarNovamente,
              onChanged: (valor) {
                setState(() {
                  _naoMostrarNovamente = valor ?? false;
                });
              },
              title: const Text('Não mostrar novamente'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _paginaAtual == 0 ? null : _voltar,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _avancar,
                      icon: Icon(
                        _ultimaPagina ? Icons.check : Icons.arrow_forward,
                      ),
                      label: Text(_ultimaPagina ? 'Começar' : 'Avançar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
