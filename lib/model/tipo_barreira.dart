/// Tipos de barreira de acessibilidade que o cidadão pode registrar.
enum TipoBarreira {
  calcadaQuebrada('Calçada quebrada'),
  rampaAusente('Rampa ausente'),
  obstaculo('Obstáculo na calçada'),
  posteNaCalcada('Poste na calçada'),
  semaforoSemSom('Semáforo sem som'),
  outro('Outra barreira');

  const TipoBarreira(this.descricao);

  final String descricao;
}
