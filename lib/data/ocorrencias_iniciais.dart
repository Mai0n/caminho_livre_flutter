import 'package:caminho_livre/model/endereco.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:caminho_livre/model/proximidade.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:caminho_livre/model/tipo_barreira.dart';

/// Ocorrências fictícias carregadas no primeiro uso, para demonstrar
/// a fila priorizada e os indicadores. Endereços inventados.
List<Ocorrencia> ocorrenciasIniciais([DateTime? referencia]) {
  final hoje = referencia ?? DateTime.now();

  Endereco endereco(String logradouro, String bairro) {
    return Endereco(
      cep: '',
      logradouro: logradouro,
      complemento: '',
      bairro: bairro,
      localidade: 'São Paulo',
      uf: 'SP',
      estado: 'São Paulo',
      regiao: 'Sudeste',
      ddd: '11',
    );
  }

  return [
    Ocorrencia(
      id: '100001',
      tipo: TipoBarreira.rampaAusente,
      gravidade: 4,
      proximidade: Proximidade.ate150m,
      endereco: endereco('Avenida do Hospital', 'Centro'),
      referencia: 'Em frente à entrada do pronto-socorro',
      descricao: 'Não há rampa na esquina. Cadeirantes precisam descer pela rua.',
      status: StatusOcorrencia.aberta,
      confirmacoes: 5,
      acompanhando: true,
      criadaEm: hoje.subtract(const Duration(days: 6)),
    ),
    Ocorrencia(
      id: '100002',
      tipo: TipoBarreira.calcadaQuebrada,
      gravidade: 4,
      proximidade: Proximidade.ate150m,
      endereco: endereco('Rua da Escola', 'Vila Nova'),
      referencia: 'Nº 210, ao lado do portão da escola',
      descricao: 'Buraco grande que ocupa toda a largura da calçada.',
      status: StatusOcorrencia.emAtendimento,
      confirmacoes: 0,
      acompanhando: false,
      criadaEm: hoje.subtract(const Duration(days: 4)),
    ),
    Ocorrencia(
      id: '100003',
      tipo: TipoBarreira.semaforoSemSom,
      gravidade: 3,
      proximidade: Proximidade.ate150m,
      endereco: endereco('Praça Central', 'Centro'),
      referencia: 'Travessia para o ponto de ônibus',
      descricao: 'O sinal sonoro para pedestres está desligado.',
      status: StatusOcorrencia.aberta,
      confirmacoes: 1,
      acompanhando: false,
      criadaEm: hoje.subtract(const Duration(days: 3)),
    ),
    Ocorrencia(
      id: '100004',
      tipo: TipoBarreira.posteNaCalcada,
      gravidade: 3,
      proximidade: Proximidade.ate400m,
      endereco: endereco('Rua das Flores', 'Jardim Primavera'),
      referencia: 'Nº 45',
      descricao: 'Poste no meio de uma calçada estreita.',
      status: StatusOcorrencia.aberta,
      confirmacoes: 0,
      acompanhando: false,
      criadaEm: hoje.subtract(const Duration(days: 2)),
    ),
    Ocorrencia(
      id: '100005',
      tipo: TipoBarreira.obstaculo,
      gravidade: 2,
      proximidade: Proximidade.distante,
      endereco: endereco('Rua dos Ipês', 'Jardim Primavera'),
      referencia: 'Próximo ao nº 300',
      descricao: 'Entulho de obra deixado sobre a calçada.',
      status: StatusOcorrencia.aberta,
      confirmacoes: 2,
      acompanhando: false,
      criadaEm: hoje.subtract(const Duration(days: 1)),
    ),
    Ocorrencia(
      id: '100006',
      tipo: TipoBarreira.rampaAusente,
      gravidade: 4,
      proximidade: Proximidade.ate400m,
      endereco: endereco('Rua das Acácias', 'Vila Nova'),
      referencia: 'Esquina com a Rua da Escola',
      descricao: 'Rampa construída pela prefeitura.',
      status: StatusOcorrencia.resolvida,
      confirmacoes: 4,
      acompanhando: false,
      criadaEm: hoje.subtract(const Duration(days: 30)),
      resolvidaEm: hoje.subtract(const Duration(days: 21)),
    ),
    Ocorrencia(
      id: '100007',
      tipo: TipoBarreira.calcadaQuebrada,
      gravidade: 3,
      proximidade: Proximidade.ate150m,
      endereco: endereco('Avenida Brasil', 'Centro'),
      referencia: 'Ponto de ônibus em frente ao nº 1.000',
      descricao: 'Calçada refeita.',
      status: StatusOcorrencia.resolvida,
      confirmacoes: 3,
      acompanhando: false,
      criadaEm: hoje.subtract(const Duration(days: 40)),
      resolvidaEm: hoje.subtract(const Duration(days: 27)),
    ),
  ];
}
