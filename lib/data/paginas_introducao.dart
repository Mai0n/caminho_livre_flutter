import 'package:caminho_livre/core/app_assets.dart';
import 'package:caminho_livre/model/pagina_introducao.dart';
import 'package:flutter/material.dart';

/// Conteúdo das páginas da introdução.
const List<PaginaIntroducao> paginasIntroducao = [
  PaginaIntroducao(
    titulo: 'Bem-vindo ao Caminho Livre',
    descricao:
        'Calçadas acessíveis começam com quem anda nelas. '
        'Ajude a mapear as barreiras que impedem pessoas de circular pela cidade.',
    icone: Icons.accessible_forward,
    imagem: AppAssets.logo,
  ),
  PaginaIntroducao(
    titulo: 'Registre uma barreira',
    descricao:
        'Buraco, rampa ausente, obstáculo ou semáforo sem som: '
        'informe o tipo, a gravidade e o CEP do local em poucos toques.',
    icone: Icons.add_location_alt_outlined,
  ),
  PaginaIntroducao(
    titulo: 'Prioridade por impacto',
    descricao:
        'O índice de prioridade considera a gravidade, a proximidade de hospitais, '
        'escolas e pontos de ônibus e as confirmações de outros moradores.',
    icone: Icons.leaderboard_outlined,
  ),
  PaginaIntroducao(
    titulo: 'Acompanhe até resolver',
    descricao:
        'Siga as ocorrências que importam para você e veja quando o trecho '
        'volta a ficar livre.',
    icone: Icons.check_circle_outline,
  ),
];
