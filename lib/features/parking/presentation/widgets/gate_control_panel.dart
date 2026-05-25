import 'package:flutter/material.dart';

import '../../domain/entities/gate.dart';
import '../../domain/entities/gate_id.dart';
import 'gate_control_tile.dart';

class GateControlPanel extends StatelessWidget {
  const GateControlPanel({
    required this.gates,
    required this.connected,
    required this.onToggle,
    super.key,
  });

  final List<Gate> gates;
  final bool connected;
  final void Function(GateId gate, bool open) onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (var i = 0; i < gates.length; i++) ...[
            GateControlTile(
              gate: gates[i],
              enabled: connected,
              onChanged: (open) => onToggle(gates[i].id, open),
            ),
            if (i < gates.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
