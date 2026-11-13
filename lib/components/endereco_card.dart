import 'package:caminho_livre/components/info_linha.dart';
import 'package:caminho_livre/model/endereco.dart';
import 'package:flutter/material.dart';

/// Exibe o endereço retornado pelo ViaCEP.
class EnderecoCard extends StatelessWidget {
  final Endereco endereco;

  const EnderecoCard({super.key, required this.endereco});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 8),
                Text(
                  'Endereço encontrado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            InfoLinha(titulo: 'CEP', valor: endereco.cep),
            InfoLinha(titulo: 'Logradouro', valor: endereco.logradouro),
            InfoLinha(titulo: 'Bairro', valor: endereco.bairro),
            InfoLinha(
              titulo: 'Cidade',
              valor: '${endereco.localidade} - ${endereco.uf}',
            ),
          ],
        ),
      ),
    );
  }
}
