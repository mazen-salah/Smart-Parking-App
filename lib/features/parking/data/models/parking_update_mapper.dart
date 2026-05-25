import '../../domain/entities/gate.dart';
import '../../domain/entities/gate_id.dart';
import '../../domain/entities/parking_space.dart';
import '../../domain/entities/parking_update.dart';

/// Translates raw JSON frames from the firmware into typed domain updates.
/// See `docs/PROTOCOL.md` in the firmware repo for the wire format.
class ParkingUpdateMapper {
  const ParkingUpdateMapper();

  ParkingUpdate? fromJson(Map<String, dynamic> json, {DateTime? now}) {
    final type = json['type'];
    if (type is! String) return null;
    final timestamp = now ?? DateTime.now();

    switch (type) {
      case 'hello':
        return const HelloUpdate();

      case 'parking':
        return _parking(json, timestamp);

      case 'gate':
        return _gate(json);

      case 'snapshot':
        return _snapshot(json, timestamp);
    }
    return null;
  }

  SpaceUpdate? _parking(Map<String, dynamic> json, DateTime now) {
    final id = (json['id'] as num?)?.toInt();
    final occupied = json['occupied'];
    if (id == null || occupied is! bool) return null;
    final sinceMs = (json['since_ms'] as num?)?.toInt() ?? 0;
    return SpaceUpdate(
      ParkingSpace(
        id: id,
        occupied: occupied,
        occupiedSince: occupied ? now.subtract(Duration(milliseconds: sinceMs)) : null,
      ),
    );
  }

  GateUpdate? _gate(Map<String, dynamic> json) {
    final gateName = json['gate'];
    final open = json['open'];
    if (gateName is! String || open is! bool) return null;
    final id = GateId.fromWire(gateName);
    if (id == null) return null;
    return GateUpdate(Gate(id: id, open: open));
  }

  SnapshotUpdate? _snapshot(Map<String, dynamic> json, DateTime now) {
    final spacesRaw = json['spaces'];
    final gatesRaw = json['gates'];
    if (spacesRaw is! List || gatesRaw is! Map) return null;

    final spaces = <ParkingSpace>[];
    for (final item in spacesRaw) {
      if (item is! Map) continue;
      final id = (item['id'] as num?)?.toInt();
      final occupied = item['occupied'];
      if (id == null || occupied is! bool) continue;
      final sinceMs = (item['since_ms'] as num?)?.toInt() ?? 0;
      spaces.add(
        ParkingSpace(
          id: id,
          occupied: occupied,
          occupiedSince:
              occupied ? now.subtract(Duration(milliseconds: sinceMs)) : null,
        ),
      );
    }

    final gates = <Gate>[];
    gatesRaw.forEach((key, value) {
      if (key is! String || value is! bool) return;
      final id = GateId.fromWire(key);
      if (id == null) return;
      gates.add(Gate(id: id, open: value));
    });

    return SnapshotUpdate(spaces: spaces, gates: gates);
  }
}
