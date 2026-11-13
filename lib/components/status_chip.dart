import 'package:caminho_livre/components/visual_extensoes.dart';
import 'package:caminho_livre/model/status_ocorrencia.dart';
import 'package:flutter/material.dart';

/// Etiqueta colorida com o status da ocorrência.
class StatusChip extends StatelessWidget {
  final StatusOcorrencia status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icone, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            status.descricao,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
