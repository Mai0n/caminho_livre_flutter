import 'package:caminho_livre/components/info_linha.dart';
import 'package:caminho_livre/components/logo_app.dart';
import 'package:caminho_livre/components/secao_titulo.dart';
import 'package:caminho_livre/core/app_routes.dart';
import 'package:caminho_livre/data/ocorrencia_repository.dart';
import 'package:flutter/material.dart';

/// Informações do projeto, equipe e opções do aplicativo.
class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  static const List<_Integrante> _equipe = [
    _Integrante(nome: 'Maria Eduarda Fiori', rm: 'RM559149'),
    _Integrante(nome: 'Henrique Maion', rm: 'RM557578'),
    _Integrante(nome: 'Nilton Eberlein', rm: 'RM557624'),
  ];

  static const List<_Ods> _ods = [
    _Ods(numero: 11, titulo: 'Cidades e comunidades sustentáveis'),
    _Ods(numero: 10, titulo: 'Redução das desigualdades'),
    _Ods(numero: 9, titulo: 'Indústria, inovação e infraestrutura'),
  ];

  Future<void> _restaurarDados(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Restaurar dados de demonstração?'),
        content: const Text(
          'As ocorrências registradas neste aparelho serão substituídas '
          'pelas ocorrências de exemplo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      return;
    }

    await OcorrenciaRepository().restaurarDadosIniciais();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados de demonstração restaurados.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o Caminho Livre')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: LogoApp(tamanho: 96)),
          const SizedBox(height: 16),
          Text(
            'Plataforma em que qualquer pessoa registra uma barreira de '
            'acessibilidade na calçada. As ocorrências são ordenadas por impacto '
            'na mobilidade para que a prefeitura resolva primeiro o que mais '
            'atrapalha.',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyLarge,
          ),
          const SecaoTitulo(
            titulo: 'Global Solution 2026 · CitizenTech',
            subtitulo: 'Objetivos de Desenvolvimento Sustentável conectados',
          ),
          Card(
            child: Column(
              children: [
                for (final ods in _ods)
                  ListTile(
                    leading: CircleAvatar(child: Text('${ods.numero}')),
                    title: Text('ODS ${ods.numero}'),
                    subtitle: Text(ods.titulo),
                  ),
              ],
            ),
          ),
          const SecaoTitulo(titulo: 'Índice de prioridade'),
          const Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoLinha(
                    titulo: 'Fórmula',
                    valor: 'Gravidade (1 a 5) × fator de entorno (1 a 3) + '
                        'bônus de confirmações (0,5 cada, até 3)',
                  ),
                  InfoLinha(
                    titulo: 'Fator de entorno',
                    valor: '3 até 150 m de hospital, escola ou ponto de ônibus; '
                        '2 entre 150 m e 400 m; 1 nos demais casos',
                  ),
                  InfoLinha(
                    titulo: 'Faixas',
                    valor: 'Alta a partir de 12 · Média a partir de 7 · '
                        'Baixa abaixo de 7',
                  ),
                ],
              ),
            ),
          ),
          const SecaoTitulo(titulo: 'Equipe Sem Degrau'),
          Card(
            child: Column(
              children: [
                for (final integrante in _equipe)
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(integrante.nome),
                    subtitle: Text(integrante.rm),
                  ),
              ],
            ),
          ),
          const SecaoTitulo(titulo: 'Dados'),
          const Card(
            child: ListTile(
              leading: Icon(Icons.cloud_outlined),
              title: Text('WebService ViaCEP'),
              subtitle: Text('Consulta de endereço pelo CEP (viacep.com.br)'),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.introducao,
              arguments: true,
            ),
            icon: const Icon(Icons.slideshow_outlined),
            label: const Text('Rever introdução'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _restaurarDados(context),
            icon: const Icon(Icons.restore),
            label: const Text('Restaurar dados de demonstração'),
          ),
        ],
      ),
    );
  }
}

class _Integrante {
  final String nome;
  final String rm;

  const _Integrante({required this.nome, required this.rm});
}

class _Ods {
  final int numero;
  final String titulo;

  const _Ods({required this.numero, required this.titulo});
}
