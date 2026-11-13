import 'package:caminho_livre/components/erro_card.dart';
import 'package:caminho_livre/components/estado_vazio.dart';
import 'package:caminho_livre/components/ocorrencia_card.dart';
import 'package:caminho_livre/core/app_routes.dart';
import 'package:caminho_livre/data/ocorrencia_repository.dart';
import 'package:caminho_livre/model/filtro_ocorrencias.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:flutter/material.dart';

/// Fila de ocorrências ordenada por prioridade, com busca e filtro por status.
class OcorrenciasScreen extends StatefulWidget {
  final StatusOcorrencia? statusInicial;

  const OcorrenciasScreen({super.key, this.statusInicial});

  @override
  State<OcorrenciasScreen> createState() => _OcorrenciasScreenState();
}

class _OcorrenciasScreenState extends State<OcorrenciasScreen> {
  final OcorrenciaRepository _repository = OcorrenciaRepository();
  final TextEditingController _buscaController = TextEditingController();

  List<Ocorrencia> _todas = [];
  StatusOcorrencia? _statusSelecionado;
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _statusSelecionado = widget.statusInicial;
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
        _todas = ocorrencias;
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

  List<Ocorrencia> get _filtradas {
    final filtro = FiltroOcorrencias(
      busca: _buscaController.text,
      status: _statusSelecionado,
    );
    return filtro.aplicar(_todas);
  }

  void _selecionarStatus(StatusOcorrencia? status) {
    setState(() {
      _statusSelecionado = status;
    });
  }

  void _limparBusca() {
    _buscaController.clear();
    setState(() {});
  }

  Future<void> _abrirDetalhe(Ocorrencia ocorrencia) async {
    await Navigator.pushNamed(context, AppRoutes.detalhe, arguments: ocorrencia);
    if (!mounted) {
      return;
    }
    _carregar();
  }

  Future<void> _alternarAcompanhamento(Ocorrencia ocorrencia) async {
    final atualizada = await _repository.alternarAcompanhamento(ocorrencia);
    if (!mounted) {
      return;
    }
    setState(() {
      _todas = _todas
          .map((item) => item.id == atualizada.id ? atualizada : item)
          .toList();
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            atualizada.acompanhando
                ? 'Você está acompanhando ${atualizada.protocolo}.'
                : 'Você deixou de acompanhar ${atualizada.protocolo}.',
          ),
        ),
      );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fila de ocorrências')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _buscaController,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: 'Buscar por rua, bairro, tipo ou protocolo',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscaController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _limparBusca,
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _construirFiltro('Todas', null),
                for (final status in StatusOcorrencia.values)
                  _construirFiltro(status.descricao, status),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _construirLista()),
        ],
      ),
    );
  }

  Widget _construirFiltro(String rotulo, StatusOcorrencia? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(rotulo),
        selected: _statusSelecionado == status,
        onSelected: (_) => _selecionarStatus(status),
      ),
    );
  }

  Widget _construirLista() {
    if (_carregando && _todas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_mensagemErro != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ErroCard(mensagem: _mensagemErro!, onTentarNovamente: _carregar),
      );
    }

    final filtradas = _filtradas;

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        itemCount: filtradas.isEmpty ? 1 : filtradas.length + 1,
        itemBuilder: (context, index) {
          if (filtradas.isEmpty) {
            return const EstadoVazio(
              icone: Icons.search_off,
              titulo: 'Nenhuma ocorrência encontrada',
              mensagem: 'Tente outro termo de busca ou outro filtro.',
            );
          }

          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${filtradas.length} ocorrência(s) · ordenadas por prioridade',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }

          final ocorrencia = filtradas[index - 1];
          return OcorrenciaCard(
            ocorrencia: ocorrencia,
            onTap: () => _abrirDetalhe(ocorrencia),
            onAlternarAcompanhamento: () => _alternarAcompanhamento(ocorrencia),
          );
        },
      ),
    );
  }
}
