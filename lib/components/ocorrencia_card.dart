import 'package:caminho_livre/components/prioridade_badge.dart';
import 'package:caminho_livre/components/status_chip.dart';
import 'package:caminho_livre/components/visual_extensoes.dart';
import 'package:caminho_livre/model/ocorrencia.dart';
import 'package:flutter/material.dart';

/// Item da fila de ocorrências. Reutilizado na Home, na fila e em "Acompanhando".
class OcorrenciaCard extends StatelessWidget {
  final Ocorrencia ocorrencia;
  final VoidCallback onTap;
  final VoidCallback? onAlternarAcompanhamento;

  const OcorrenciaCard({
    super.key,
    required this.ocorrencia,
    required this.onTap,
    this.onAlternarAcompanhamento,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrioridadeBadge(indice: ocorrencia.indicePrioridade),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(ocorrencia.tipo.icone, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            ocorrencia.tipo.descricao,
                            style: tema.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ocorrencia.local,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        StatusChip(status: ocorrencia.status),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: tema.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${ocorrencia.confirmacoes}',
                          style: tema.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onAlternarAcompanhamento != null)
                IconButton(
                  onPressed: onAlternarAcompanhamento,
                  tooltip: ocorrencia.acompanhando
                      ? 'Deixar de acompanhar'
                      : 'Acompanhar ocorrência',
                  icon: Icon(
                    ocorrencia.acompanhando ? Icons.star : Icons.star_border,
                    color: ocorrencia.acompanhando
                        ? Colors.amber.shade700
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
