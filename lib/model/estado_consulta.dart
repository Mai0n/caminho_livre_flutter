/// Estados possíveis de uma consulta ao WebService.
enum EstadoConsulta {
  /// Antes de qualquer requisição.
  inicial,

  /// Requisição em andamento.
  carregando,

  /// Dados recebidos corretamente.
  sucesso,

  /// Houve algum problema na requisição.
  erro,
}
