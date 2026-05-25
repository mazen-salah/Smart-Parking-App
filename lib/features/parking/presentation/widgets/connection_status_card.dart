import 'package:flutter/material.dart';

class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({required this.connected, super.key});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = connected ? Colors.greenAccent : theme.colorScheme.error;
    final icon = connected ? Icons.wifi_rounded : Icons.wifi_off_rounded;
    final label = connected ? 'Connected' : 'Disconnected';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text('Device:', style: theme.textTheme.titleMedium),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
