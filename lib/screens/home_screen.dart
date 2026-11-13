import 'package:caminho_livre/components/erro_card.dart';
import 'package:caminho_livre/components/indicador_card.dart';
import 'package:caminho_livre/components/logo_app.dart';
import 'package:caminho_livre/components/ocorrencia_card.dart';
import 'package:caminho_livre/components/secao_titulo.dart';
import 'package:caminho_livre/core/app_cores.dart';
import 'package:caminho_livre/core/app_routes.dart';
import 'package:caminho_livre/core/formatadores.dart';
import 'package:caminho_livre/data/ocorrencia_repository.dart';
import 'package:caminho_livre/model/indicadores.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _quantidadeDestaques = 3;

  final OcorrenciaRepository _repository = OcorrenciaRepository();

  List<Ocorrencia> _ocorrencias = [];
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final ocorrencias = await _repository.listar();
      if (!mounted) {
        return;
      }
      setState(() {
        _ocorrencias = ocorrencias;
      });
    } catch (erro) {
      if (!mounted) {
        return;
      }
      setState(() {
        _mensagemErro = 'Não foi possível carregar as ocorrências.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  /// Abre uma tela e recarrega o painel quando o usuário volta.
  Future<void> _abrir(String rota, {Object? argumentos}) async {
    await Navigator.pushNamed(context, rota, arguments: argumentos);
    if (!mounted) {
      return;
    }
    _carregar();
  }

  Future<void> _registrar() async {
    final resultado = await Navigator.pushNamed(context, AppRoutes.registrar);
    if (!mounted) {
      return;
    }

    if (resultado is Ocorrencia) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Barreira registrada. Protocolo ${resultado.protocolo}.',
          ),
        ),
      );
    }
    _carregar();
  }

  Future<void> _alternarAcompanhamento(Ocorrencia ocorrencia) async {
    await _repository.alternarAcompanhamento(ocorrencia);
    if (!mounted) {
      return;
    }
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caminho Livre'),
        actions: [
          IconButton(
            onPressed: () => _abrir(AppRoutes.acompanhando),
            tooltip: 'Ocorrências que acompanho',
            icon: const Icon(Icons.star_outline),
          ),
          IconButton(
            onPressed: () => _abrir(AppRoutes.sobre),
            tooltip: 'Sobre o projeto',
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registrar,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Registrar barreira'),
      ),
      body: RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            _construirCabecalho(context),
            ..._construirConteudo(),
          ],
        ),
      ),
    );
  }

  Widget _construirCabecalho(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      color: tema.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const LogoApp(tamanho: 64),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá!',
                    style: tema.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: tema.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Encontrou uma barreira na calçada? Registre e ajude '
                    'a prefeitura a priorizar o que mais atrapalha.',
                    style: TextStyle(color: tema.colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _construirConteudo() {
    if (_carregando && _ocorrencias.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (_mensagemErro != null) {
      return [
        const SizedBox(height: 16),
        ErroCard(mensagem: _mensagemErro!, onTentarNovamente: _carregar),
      ];
    }

    final indicadores = Indicadores.calcular(_ocorrencias);
    final destaques = _ocorrencias
        .where((ocorrencia) => !ocorrencia.resolvida)
        .take(_quantidadeDestaques)
        .toList();

    return [
      const SecaoTitulo(
        titulo: 'Painel da cidade',
        subtitulo: 'Toque em um número para ver as ocorrências',
      ),
      Row(
        children: [
          Expanded(
            child: IndicadorCard(
              titulo: 'Abertas',
              valor: '${indicadores.abertas}',
              icone: Icons.error_outline,
              cor: AppCores.statusAberta,
              onTap: () => _abrir(
                AppRoutes.ocorrencias,
                argumentos: StatusOcorrencia.aberta,
              ),
            ),
          ),
          Expanded(
            child: IndicadorCard(
              titulo: 'Resolvidas',
              valor: '${indicadores.resolvidas}',
              icone: Icons.check_circle_outline,
              cor: AppCores.statusResolvida,
              onTap: () => _abrir(
                AppRoutes.ocorrencias,
                argumentos: StatusOcorrencia.resolvida,
              ),
            ),
          ),
          Expanded(
            child: IndicadorCard(
              titulo: 'Tempo médio',
              valor: Formatadores.dias(indicadores.tempoMedioDias),
              icone: Icons.timer_outlined,
              cor: AppCores.azul,
            ),
          ),
        ],
      ),
      const SecaoTitulo(titulo: 'O que você quer fazer?'),
      ElevatedButton.icon(
        onPressed: _registrar,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Registrar uma barreira'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () => _abrir(AppRoutes.ocorrencias),
        icon: const Icon(Icons.format_list_numbered),
        label: const Text('Ver fila de ocorrências'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      const SecaoTitulo(
        titulo: 'Prioridade mais alta',
        subtitulo: 'Barreiras pendentes com maior impacto na mobilidade',
      ),
      if (destaques.isEmpty)
        const Text('Nenhuma barreira pendente. A cidade está livre!')
      else
        for (final ocorrencia in destaques)
          OcorrenciaCard(
            ocorrencia: ocorrencia,
            onTap: () => _abrir(AppRoutes.detalhe, argumentos: ocorrencia),
            onAlternarAcompanhamento: () => _alternarAcompanhamento(ocorrencia),
          ),
    ];
  }
}
