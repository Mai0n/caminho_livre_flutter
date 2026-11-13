import 'package:caminho_livre/components/erro_card.dart';
import 'package:caminho_livre/components/estado_vazio.dart';
import 'package:caminho_livre/components/ocorrencia_card.dart';
import 'package:caminho_livre/core/app_routes.dart';
import 'package:caminho_livre/data/ocorrencia_repository.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:flutter/material.dart';

/// Ocorrências que o usuário marcou com a estrela (favoritas).
class AcompanhandoScreen extends StatefulWidget {
  const AcompanhandoScreen({super.key});

  @override
  State<AcompanhandoScreen> createState() => _AcompanhandoScreenState();
}

class _AcompanhandoScreenState extends State<AcompanhandoScreen> {
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
      final ocorrencias = await _repository.listarAcompanhadas();
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

  Future<void> _abrirDetalhe(Ocorrencia ocorrencia) async {
    await Navigator.pushNamed(context, AppRoutes.detalhe, arguments: ocorrencia);
    if (!mounted) {
      return;
    }
    _carregar();
  }

  Future<void> _deixarDeAcompanhar(Ocorrencia ocorrencia) async {
    await _repository.alternarAcompanhamento(ocorrencia);
    if (!mounted) {
      return;
    }
    setState(() {
      _ocorrencias.removeWhere((item) => item.id == ocorrencia.id);
    });
  }

  void _abrirFila() {
    Navigator.pushReplacementNamed(context, AppRoutes.ocorrencias);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acompanhando')),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    if (_carregando && _ocorrencias.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_mensagemErro != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ErroCard(mensagem: _mensagemErro!, onTentarNovamente: _carregar),
      );
    }

    if (_ocorrencias.isEmpty) {
      return Center(
        child: EstadoVazio(
          icone: Icons.star_border,
          titulo: 'Você ainda não acompanha nenhuma ocorrência',
          mensagem:
              'Toque na estrela de uma ocorrência para receber o andamento aqui.',
          textoAcao: 'Ver fila de ocorrências',
          onAcao: _abrirFila,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _ocorrencias.length,
        itemBuilder: (context, index) {
          final ocorrencia = _ocorrencias[index];
          return OcorrenciaCard(
            ocorrencia: ocorrencia,
            onTap: () => _abrirDetalhe(ocorrencia),
            onAlternarAcompanhamento: () => _deixarDeAcompanhar(ocorrencia),
          );
        },
      ),
    );
  }
}
