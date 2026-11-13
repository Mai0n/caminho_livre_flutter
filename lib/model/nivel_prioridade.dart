/// Faixas do índice de prioridade (alta, média e baixa).
enum NivelPrioridade {
  alta('Alta'),
  media('Média'),
  baixa('Baixa');

  const NivelPrioridade(this.descricao);

  final String descricao;
}
