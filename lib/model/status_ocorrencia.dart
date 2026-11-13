/// Etapas pelas quais uma ocorrência passa até ser resolvida.
enum StatusOcorrencia {
  aberta('Aberta'),
  emAtendimento('Em atendimento'),
  resolvida('Resolvida');

  const StatusOcorrencia(this.descricao);

  final String descricao;

  /// Próxima etapa do fluxo. Retorna null quando já está resolvida.
  StatusOcorrencia? get proximo {
    switch (this) {
      case StatusOcorrencia.aberta:
        return StatusOcorrencia.emAtendimento;
      case StatusOcorrencia.emAtendimento:
        return StatusOcorrencia.resolvida;
      case StatusOcorrencia.resolvida:
        return null;
    }
  }
}
