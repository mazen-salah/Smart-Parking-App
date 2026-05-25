import 'package:flutter/material.dart';

import '../../../../core/utils/duration_formatter.dart';
import '../../domain/entities/parking_space.dart';

class ParkingSpaceCard extends StatelessWidget {
  const ParkingSpaceCard({
    required this.space,
    required this.now,
    super.key,
  });

  final ParkingSpace space;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final occupied = space.occupied;
    final accent = occupied ? Colors.redAccent : Colors.greenAccent;
    final duration = space.occupiedDuration(now);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.18),
              accent.withValues(alpha: 0.04),
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bay ${space.id}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Icon(
                  occupied ? Icons.directions_car_filled : Icons.local_parking,
                  color: accent,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              occupied ? 'Occupied' : 'Free',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              occupied ? DurationFormatter.format(duration) : '--:--:--',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
