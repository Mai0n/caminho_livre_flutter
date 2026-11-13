import 'package:caminho_livre/components/endereco_card.dart';
import 'package:caminho_livre/components/erro_card.dart';
import 'package:caminho_livre/components/gravidade_selector.dart';
import 'package:caminho_livre/components/prioridade_badge.dart';
import 'package:caminho_livre/components/secao_titulo.dart';
import 'package:caminho_livre/components/visual_extensoes.dart';
import 'package:caminho_livre/core/validadores.dart';
import 'package:caminho_livre/data/ocorrencia_repository.dart';
import 'package:caminho_livre/data/viacep_service.dart';
import 'package:caminho_livre/model/endereco.dart';
import 'package:caminho_livre/model/estado_consulta.dart';
import 'package:caminho_livre/model/proximidade.dart';
import 'package:caminho_livre/model/tipo_barreira.dart';
import 'package:caminho_livre/prioridade/calculadora_prioridade.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Formulário de registro de uma barreira. O endereço vem do ViaCEP.
class RegistrarOcorrenciaScreen extends StatefulWidget {
  const RegistrarOcorrenciaScreen({super.key});

  @override
  State<RegistrarOcorrenciaScreen> createState() =>
      _RegistrarOcorrenciaScreenState();
}

class _RegistrarOcorrenciaScreenState extends State<RegistrarOcorrenciaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final ViaCepService _viaCepService = ViaCepService();
  final OcorrenciaRepository _repository = OcorrenciaRepository();
  final CalculadoraPrioridade _calculadora = const CalculadoraPrioridade();

  TipoBarreira _tipo = TipoBarreira.calcadaQuebrada;
  int _gravidade = 3;
  Proximidade _proximidade = Proximidade.distante;

  EstadoConsulta _estadoConsulta = EstadoConsulta.inicial;
  Endereco? _endereco;
  String? _mensagemErro;
  bool _salvando = false;

  double get _prioridadeEstimada => _calculadora.calcular(
        gravidade: _gravidade,
        fatorEntorno: _proximidade.fatorEntorno,
        confirmacoes: 0,
      );

  Future<void> _buscarCep() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _estadoConsulta = EstadoConsulta.carregando;
      _mensagemErro = null;
      _endereco = null;
    });

    try {
      final endereco = await _viaCepService.buscarEndereco(_cepController.text);
      if (!mounted) {
        return;
      }
      setState(() {
        _endereco = endereco;
        _estadoConsulta = EstadoConsulta.sucesso;
      });
    } catch (erro) {
      if (!mounted) {
        return;
      }
      setState(() {
        _mensagemErro = erro.toString().replaceFirst('Exception: ', '');
        _estadoConsulta = EstadoConsulta.erro;
      });
    }
  }

  /// Quando o CEP é alterado, o endereço anterior deixa de valer.
  void _aoAlterarCep(String _) {
    if (_estadoConsulta == EstadoConsulta.inicial) {
      return;
    }
    setState(() {
      _estadoConsulta = EstadoConsulta.inicial;
      _endereco = null;
      _mensagemErro = null;
    });
  }

  Future<void> _enviar() async {
    final formularioValido = _formKey.currentState!.validate();
    final endereco = _endereco;

    if (!formularioValido) {
      return;
    }

    if (endereco == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Toque em "Buscar" para confirmar o endereço pelo CEP.'),
        ),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      final nova = await _repository.registrar(
        tipo: _tipo,
        gravidade: _gravidade,
        proximidade: _proximidade,
        endereco: endereco,
        referencia: _referenciaController.text,
        descricao: _descricaoController.text,
      );
      if (!mounted) {
        return;
      }
      Navigator.pop(context, nova);
    } catch (erro) {
      if (!mounted) {
        return;
      }
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o registro.')),
      );
    }
  }

  @override
  void dispose() {
    _cepController.dispose();
    _referenciaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar barreira')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              const SecaoTitulo(titulo: 'Tipo de barreira'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tipo in TipoBarreira.values)
                    ChoiceChip(
                      avatar: Icon(tipo.icone, size: 18),
                      label: Text(tipo.descricao),
                      selected: _tipo == tipo,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _tipo = tipo),
                    ),
                ],
              ),
              const SecaoTitulo(
                titulo: 'Gravidade',
                subtitulo: 'Quanto a barreira atrapalha quem passa por ali?',
              ),
              GravidadeSelector(
                valor: _gravidade,
                onChanged: (valor) => setState(() => _gravidade = valor),
              ),
              const SecaoTitulo(
                titulo: 'Distância até hospital, escola ou ponto de ônibus',
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final proximidade in Proximidade.values)
                    ChoiceChip(
                      label: Text(proximidade.descricao),
                      selected: _proximidade == proximidade,
                      onSelected: (_) =>
                          setState(() => _proximidade = proximidade),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(_proximidade.detalhe, style: tema.textTheme.bodyMedium),
              const SecaoTitulo(
                titulo: 'Local',
                subtitulo: 'O endereço é preenchido pelo WebService ViaCEP',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cepController,
                      enabled: _estadoConsulta != EstadoConsulta.carregando,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.search,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'CEP',
                        hintText: 'Exemplo: 01001000',
                        prefixIcon: Icon(Icons.pin_drop_outlined),
                      ),
                      validator: Validadores.cep,
                      onChanged: _aoAlterarCep,
                      onFieldSubmitted: (_) {
                        if (_estadoConsulta != EstadoConsulta.carregando) {
                          _buscarCep();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _estadoConsulta == EstadoConsulta.carregando
                          ? null
                          : _buscarCep,
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _construirResultadoCep(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenciaController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Número ou ponto de referência',
                  hintText: 'Exemplo: em frente ao nº 120',
                  prefixIcon: Icon(Icons.signpost_outlined),
                ),
                validator: Validadores.referencia,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Conte o que você viu',
                  alignLabelWithHint: true,
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      PrioridadeBadge(
                        indice: _prioridadeEstimada,
                        exibirNivel: true,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Prioridade estimada: $_gravidade × '
                          '${_proximidade.fatorEntorno}. Cada confirmação de '
                          'outro morador soma 0,5 (até 3).',
                          style: tema.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _salvando ? null : _enviar,
                icon: _salvando
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(_salvando ? 'Enviando...' : 'Enviar registro'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mostra cada estado da consulta: inicial, carregando, sucesso e erro.
  Widget _construirResultadoCep() {
    switch (_estadoConsulta) {
      case EstadoConsulta.inicial:
        return const Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Digite o CEP e toque em Buscar para preencher o endereço.'),
          ),
        );
      case EstadoConsulta.carregando:
        return const Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            title: Text('Consultando o CEP...'),
          ),
        );
      case EstadoConsulta.sucesso:
        return EnderecoCard(endereco: _endereco!);
      case EstadoConsulta.erro:
        return ErroCard(
          mensagem: _mensagemErro ?? 'Não foi possível consultar o CEP.',
          onTentarNovamente: _buscarCep,
        );
    }
  }
}
