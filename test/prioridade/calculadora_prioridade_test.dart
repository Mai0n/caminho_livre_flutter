import 'package:caminho_livre/model/nivel_prioridade.dart';
import 'package:caminho_livre/prioridade/calculadora_prioridade.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculadora = CalculadoraPrioridade();

  test('exemplo do pitch: rampa perto de hospital com 5 confirmações vale 14,5', () {
    // ARRANGE
    const gravidade = 4;
    const fatorEntorno = 3;
    const confirmacoes = 5;

    // ACT
    final indice = calculadora.calcular(
      gravidade: gravidade,
      fatorEntorno: fatorEntorno,
      confirmacoes: confirmacoes,
    );

    // ASSERT
    expect(indice, closeTo(14.5, 0.01));
  });

  test('sem confirmações o índice é gravidade vezes fator de entorno', () {
    final indice = calculadora.calcular(
      gravidade: 3,
      fatorEntorno: 2,
      confirmacoes: 0,
    );

    expect(indice, closeTo(6.0, 0.01));
  });

  test('bônus de confirmações é limitado a 3', () {
    final indice = calculadora.calcular(
      gravidade: 4,
      fatorEntorno: 3,
      confirmacoes: 10,
    );

    expect(indice, closeTo(15.0, 0.01));
  });

  test('índice máximo possível é 18', () {
    final indice = calculadora.calcular(
      gravidade: 5,
      fatorEntorno: 3,
      confirmacoes: 6,
    );

    expect(indice, closeTo(18.0, 0.01));
  });

  test('gravidade zero deve gerar erro', () {
    expect(
      () => calculadora.calcular(gravidade: 0, fatorEntorno: 1, confirmacoes: 0),
      throwsArgumentError,
    );
  });

  test('gravidade acima de 5 deve gerar erro', () {
    expect(
      () => calculadora.calcular(gravidade: 6, fatorEntorno: 1, confirmacoes: 0),
      throwsArgumentError,
    );
  });

  test('fator de entorno fora de 1 a 3 deve gerar erro', () {
    expect(
      () => calculadora.calcular(gravidade: 3, fatorEntorno: 4, confirmacoes: 0),
      throwsArgumentError,
    );
  });

  test('confirmações negativas devem gerar erro', () {
    expect(
      () => calculadora.calcular(gravidade: 3, fatorEntorno: 1, confirmacoes: -1),
      throwsArgumentError,
    );
  });

  test('índice 12 ou mais é prioridade alta', () {
    expect(calculadora.classificar(12.0), NivelPrioridade.alta);
  });

  test('índice entre 7 e 11,9 é prioridade média', () {
    expect(calculadora.classificar(11.9), NivelPrioridade.media);
    expect(calculadora.classificar(7.0), NivelPrioridade.media);
  });

  test('índice abaixo de 7 é prioridade baixa', () {
    expect(calculadora.classificar(6.5), NivelPrioridade.baixa);
  });
}
