import 'package:flutter/material.dart';

import '../../domain/entities/gate.dart';

class GateControlTile extends StatelessWidget {
  const GateControlTile({
    required this.gate,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final Gate gate;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            gate.open ? Icons.lock_open : Icons.lock,
            color: gate.open ? Colors.greenAccent : theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${gate.id.displayName} gate',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Text(
            gate.open ? 'Open' : 'Closed',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: gate.open
                  ? Colors.greenAccent
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: gate.open,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
