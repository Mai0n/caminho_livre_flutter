import 'package:caminho_livre/components/info_linha.dart';
import 'package:caminho_livre/components/prioridade_badge.dart';
import 'package:caminho_livre/components/secao_titulo.dart';
import 'package:caminho_livre/components/status_chip.dart';
import 'package:caminho_livre/components/visual_extensoes.dart';
import 'package:caminho_livre/core/formatadores.dart';
import 'package:caminho_livre/data/ocorrencia_repository.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:caminho_livre/prioridade/calculadora_prioridade.dart';
import 'package:flutter/material.dart';

/// Detalhes de uma ocorrência, recebida como parâmetro da lista.
class DetalheOcorrenciaScreen extends StatefulWidget {
  final Ocorrencia ocorrencia;

  const DetalheOcorrenciaScreen({super.key, required this.ocorrencia});

  @override
  State<DetalheOcorrenciaScreen> createState() =>
      _DetalheOcorrenciaScreenState();
}

class _DetalheOcorrenciaScreenState extends State<DetalheOcorrenciaScreen> {
  final OcorrenciaRepository _repository = OcorrenciaRepository();

  late Ocorrencia _ocorrencia;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _ocorrencia = widget.ocorrencia;
  }

  /// Executa uma ação no repositório e atualiza a tela com o resultado.
  Future<void> _executar(
    Future<Ocorrencia> Function(Ocorrencia) acao,
    String mensagem,
  ) async {
    setState(() => _salvando = true);

    try {
      final atualizada = await acao(_ocorrencia);
      if (!mounted) {
        return;
      }
      setState(() => _ocorrencia = atualizada);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(mensagem)));
    } catch (erro) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Não foi possível salvar. Tente novamente.')),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  void _confirmar() {
    _executar(
      _repository.confirmar,
      'Obrigado! Sua confirmação aumenta a prioridade da barreira.',
    );
  }

  void _avancarStatus() {
    final proximo = _ocorrencia.status.proximo;
    if (proximo == null) {
      return;
    }
    _executar(
      _repository.avancarStatus,
      'Status alterado para "${proximo.descricao}".',
    );
  }

  void _alternarAcompanhamento() {
    _executar(
      _repository.alternarAcompanhamento,
      _ocorrencia.acompanhando
          ? 'Você deixou de acompanhar esta ocorrência.'
          : 'Você está acompanhando esta ocorrência.',
    );
  }

  String get _textoProximoStatus {
    switch (_ocorrencia.status) {
      case StatusOcorrencia.aberta:
        return 'Iniciar atendimento';
      case StatusOcorrencia.emAtendimento:
        return 'Marcar como resolvida';
      case StatusOcorrencia.resolvida:
        return 'Barreira resolvida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final ocorrencia = _ocorrencia;

    return Scaffold(
      appBar: AppBar(
        title: Text('Protocolo ${ocorrencia.protocolo}'),
        actions: [
          IconButton(
            onPressed: _salvando ? null : _alternarAcompanhamento,
            tooltip: ocorrencia.acompanhando
                ? 'Deixar de acompanhar'
                : 'Acompanhar ocorrência',
            icon: Icon(
              ocorrencia.acompanhando ? Icons.star : Icons.star_border,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: tema.colorScheme.primaryContainer,
                    child: Icon(
                      ocorrencia.tipo.icone,
                      size: 30,
                      color: tema.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ocorrencia.tipo.descricao,
                          style: tema.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        StatusChip(status: ocorrencia.status),
                      ],
                    ),
                  ),
                  PrioridadeBadge(
                    indice: ocorrencia.indicePrioridade,
                    exibirNivel: true,
                  ),
                ],
              ),
            ),
          ),
          const SecaoTitulo(titulo: 'Como o índice foi calculado'),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoLinha(
                    titulo: 'Gravidade',
                    valor: '${ocorrencia.gravidade} de 5',
                  ),
                  InfoLinha(
                    titulo: 'Fator de entorno',
                    valor: '${ocorrencia.proximidade.fatorEntorno} '
                        '(${ocorrencia.proximidade.descricao} de hospital, '
                        'escola ou ponto de ônibus)',
                  ),
                  InfoLinha(
                    titulo: 'Confirmações de moradores',
                    valor: '${ocorrencia.confirmacoes} '
                        '(+${Formatadores.indice(ocorrencia.bonusConfirmacoes)}, '
                        'máximo +${Formatadores.indice(CalculadoraPrioridade.bonusMaximo)})',
                  ),
                  InfoLinha(
                    titulo: 'Índice de prioridade',
                    valor: '${ocorrencia.gravidade} × '
                        '${ocorrencia.proximidade.fatorEntorno} + '
                        '${Formatadores.indice(ocorrencia.bonusConfirmacoes)} = '
                        '${Formatadores.indice(ocorrencia.indicePrioridade)}',
                  ),
                ],
              ),
            ),
          ),
          const SecaoTitulo(titulo: 'Local'),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ocorrencia.endereco.cep.trim().isNotEmpty)
                    InfoLinha(
                      titulo: 'CEP',
                      valor: Formatadores.cep(ocorrencia.endereco.cep),
                    ),
                  InfoLinha(
                    titulo: 'Logradouro',
                    valor: ocorrencia.endereco.logradouro,
                  ),
                  InfoLinha(
                      titulo: 'Bairro', valor: ocorrencia.endereco.bairro),
                  InfoLinha(
                    titulo: 'Cidade',
                    valor: '${ocorrencia.endereco.localidade} - '
                        '${ocorrencia.endereco.uf}',
                  ),
                  InfoLinha(
                    titulo: 'Número ou referência',
                    valor: ocorrencia.referencia,
                  ),
                ],
              ),
            ),
          ),
          const SecaoTitulo(titulo: 'Registro'),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoLinha(titulo: 'Descrição', valor: ocorrencia.descricao),
                  InfoLinha(
                    titulo: 'Registrada em',
                    valor: Formatadores.data(ocorrencia.criadaEm),
                  ),
                  if (ocorrencia.resolvidaEm != null)
                    InfoLinha(
                      titulo: 'Resolvida em',
                      valor: Formatadores.data(ocorrencia.resolvidaEm!),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _salvando || ocorrencia.resolvida ? null : _confirmar,
            icon: const Icon(Icons.how_to_reg_outlined),
            label: const Text('Também vi esta barreira'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed:
                _salvando || ocorrencia.resolvida ? null : _avancarStatus,
            icon: Icon(
              ocorrencia.resolvida ? Icons.check_circle : Icons.arrow_forward,
            ),
            label: Text(_textoProximoStatus),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'O botão de status representa a ação da equipe da prefeitura '
            '(painel do gestor).',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
