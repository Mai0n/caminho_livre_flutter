/// Distância da barreira até um hospital, escola ou ponto de ônibus.
/// Define o fator de entorno usado no índice de prioridade.
enum Proximidade {
  ate150m('Até 150 m', 'Hospital, escola ou ponto de ônibus muito perto', 3),
  ate400m('De 150 m a 400 m', 'Hospital, escola ou ponto de ônibus próximo', 2),
  distante('Mais de 400 m', 'Nenhum desses locais por perto', 1);

  const Proximidade(this.descricao, this.detalhe, this.fatorEntorno);

  final String descricao;
  final String detalhe;
  final int fatorEntorno;
}
