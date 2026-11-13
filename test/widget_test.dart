import 'package:caminho_livre/components/erro_card.dart';
import 'package:caminho_livre/components/gravidade_selector.dart';
import 'package:caminho_livre/components/prioridade_badge.dart';
import 'package:caminho_livre/components/status_chip.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _emTela(Widget filho) {
  return MaterialApp(home: Scaffold(body: Center(child: filho)));
}

void main() {
  testWidgets('PrioridadeBadge mostra o índice com vírgula e o nível', (
    tester,
  ) async {
    await tester.pumpWidget(
      _emTela(const PrioridadeBadge(indice: 14.5, exibirNivel: true)),
    );

    expect(find.text('14,5'), findsOneWidget);
    expect(find.text('Alta'), findsOneWidget);
  });

  testWidgets('StatusChip mostra a descrição do status', (tester) async {
    await tester.pumpWidget(
      _emTela(const StatusChip(status: StatusOcorrencia.emAtendimento)),
    );

    expect(find.text('Em atendimento'), findsOneWidget);
  });

  testWidgets('ErroCard chama a ação de tentar novamente', (tester) async {
    var tentativas = 0;

    await tester.pumpWidget(
      _emTela(
        ErroCard(
          mensagem: 'CEP não encontrado.',
          onTentarNovamente: () => tentativas++,
        ),
      ),
    );
    await tester.tap(find.text('Tentar novamente'));

    expect(find.text('CEP não encontrado.'), findsOneWidget);
    expect(tentativas, 1);
  });

  testWidgets('GravidadeSelector avisa o valor escolhido', (tester) async {
    int? escolhido;

    await tester.pumpWidget(
      _emTela(
        GravidadeSelector(valor: 3, onChanged: (valor) => escolhido = valor),
      ),
    );
    await tester.tap(find.text('5'));

    expect(escolhido, 5);
  });
}
