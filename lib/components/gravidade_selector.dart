import 'package:flutter/material.dart';

/// Seleção da gravidade da barreira, de 1 (leve) a 5 (impede a passagem).
class GravidadeSelector extends StatelessWidget {
  final int valor;
  final ValueChanged<int> onChanged;

  const GravidadeSelector({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  static const List<String> _descricoes = [
    'Leve: incomoda, mas dá para passar',
    'Moderada: exige desvio pequeno',
    'Séria: dificulta a passagem',
    'Grave: obriga a sair da calçada',
    'Crítica: impede a passagem',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var nivel = 1; nivel <= 5; nivel++)
              ChoiceChip(
                label: Text('$nivel'),
                selected: valor == nivel,
                onSelected: (_) => onChanged(nivel),
                tooltip: 'Gravidade $nivel',
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _descricoes[valor - 1],
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
